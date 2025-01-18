import 'dart:convert';
import 'dart:io';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:projeto_mobile/provider/historyMedProvider.dart';
import 'package:provider/provider.dart';
import 'package:projeto_mobile/model/medicationModel.dart';
import 'package:projeto_mobile/view/addMedicationScreen.dart';
import 'package:projeto_mobile/view/medicationDetailsScreen.dart';
import 'package:projeto_mobile/provider/medicationProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

// Função para salvar as informações do alarme
Future<void> _saveAlarmInfo(
    int alarmId, String userName, String medicationName) async {
  final prefs = await SharedPreferences.getInstance();
  final alarmInfo = {
    'userName': userName,
    'medicationName': medicationName,
  };
  await prefs.setString('alarm_$alarmId', jsonEncode(alarmInfo));
}

// Modifique a função _alarmCallback para receber o ID do alarme
@pragma('vm:entry-point')
void _alarmCallback(int alarmId) async {
  final prefs = await SharedPreferences.getInstance();
  final String? alarmInfoString = prefs.getString('alarm_$alarmId');

  if (alarmInfoString != null) {
    final alarmInfo = jsonDecode(alarmInfoString);
    await showNotification(
      userName: alarmInfo['userName'],
      medicationName: alarmInfo['medicationName'],
    );

    // Limpar as informações após mostrar a notificação
    await prefs.remove('alarm_$alarmId');
  }

  print("Alarme $alarmId disparado!");
}

int _getWeekdayFromName(String dayName) {
  switch (dayName.toLowerCase()) {
    case 'dom':
      return DateTime.sunday;
    case 'seg':
      return DateTime.monday;
    case 'ter':
      return DateTime.tuesday;
    case 'qua':
      return DateTime.wednesday;
    case 'qui':
      return DateTime.thursday;
    case 'sex':
      return DateTime.friday;
    case 'sáb':
      return DateTime.saturday;
    default:
      throw ArgumentError("Dia inválido: $dayName");
  }
}

int _generateAlarmId(DateTime dateTime, String medicationName) {
  return dateTime.hashCode ^ medicationName.hashCode;
}

Future<void> scheduleMedicationAlarms(MedicationModel medication) async {
  final List<String> times =
      medication.medicationTime; // Horários em formato "HH:mm"
  final List<String> daysOfWeek =
      medication.daysOfWeek; // Dias selecionados (ex.: "Segunda")

  for (String time in times) {
    // Separar a hora e os minutos
    final parts = time.split(":");
    print(parts);
    final int hour = int.parse(parts[0]);
    final int minute = int.parse(parts[1]);

    for (String day in daysOfWeek) {
      // Calcular a data/hora do próximo alarme para o dia selecionado
      final DateTime now = DateTime.now();
      int weekday = _getWeekdayFromName(day);
      int daysUntilNext = (weekday - now.weekday) % 7;
      if (daysUntilNext < 0) daysUntilNext += 7;

      DateTime alarmDateTime = DateTime(
          now.year,
          now.month,
          now.day + daysUntilNext,
          hour,
          minute,
          0,
        );

      // Se o horário já passou hoje, programe para a próxima semana
      if (alarmDateTime.isBefore(now)) {
        alarmDateTime = alarmDateTime.add(const Duration(days: 7));
      }

      final int alarmId =
          _generateAlarmId(alarmDateTime, medication.medicationName);

      // Salvar as informações do alarme antes de agendá-lo
      await _saveAlarmInfo(
        alarmId,
        medication.userName,
        medication.medicationName,
      );

      print(alarmDateTime);

      // Agendar o alarme
      await AndroidAlarmManager.oneShotAt(
        alarmDateTime,
        _generateAlarmId(alarmDateTime, medication.medicationName), // ID único
        _alarmCallback, // Função que será executada
        exact: true,
        wakeup: true,
      );
    }
  }
}

Future<void> cancelMedicationAlarms(MedicationModel medication) async {
  final List<String> times = medication.medicationTime;
  final List<String> daysOfWeek = medication.daysOfWeek;

  for (String time in times) {
    final parts = time.split(":");
    final int hour = int.parse(parts[0]);
    final int minute = int.parse(parts[1]);

    for (String day in daysOfWeek) {
      final DateTime now = DateTime.now();
      int weekday = _getWeekdayFromName(day);
      int daysUntilNext = (weekday - now.weekday) % 7;
      if (daysUntilNext < 0) daysUntilNext += 7;

      DateTime alarmDateTime = now
          .add(Duration(days: daysUntilNext))
          .copyWith(hour: hour, minute: minute, second: 0);

      if (alarmDateTime.isBefore(now)) {
        alarmDateTime = alarmDateTime.add(const Duration(days: 7));
      }

      final int alarmId =
          _generateAlarmId(alarmDateTime, medication.medicationName);
      await AndroidAlarmManager.cancel(alarmId);

      // Também remover as informações salvas no SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('alarm_$alarmId');
    }
  }
}

Future<void> manageMedicationAlarms(MedicationModel medication) async {
  if (medication.isActive) {
    // Se o medicamento está ativo, agendar os alarmes
    await scheduleMedicationAlarms(medication);
  } else {
    // Se o medicamento está inativo, cancelar os alarmes
    await cancelMedicationAlarms(medication);
  }
}

class MedicationScreen extends StatefulWidget {
  const MedicationScreen({Key? key}) : super(key: key);

  @override
  State<MedicationScreen> createState() => _MedicationScreenState();
}

class _MedicationScreenState extends State<MedicationScreen> {
  bool isSelectionMode = false;
  List<MedicationModel> selectedMedications = [];

  void toggleSelectionMode() {
    setState(() {
      isSelectionMode = !isSelectionMode;
      selectedMedications.clear();
    });
  }

  void toggleSelectAll(List<MedicationModel> medications) {
    setState(() {
      if (selectedMedications.length == medications.length) {
        selectedMedications.clear();
      } else {
        selectedMedications = List.from(medications);
      }
    });
  }

  void confirmDeleteSelectedMedications(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Excluir medicamentos"),
          content:
              Text("Deseja realmente remover os medicamentos selecionados?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
              },
              child:
                  Text("Cancelar", style: TextStyle(color: Colors.blue[600])),
            ),
            TextButton(
              onPressed: () async {
                 await deleteSelectedMedications(context); // Exclui os medicamentos
                Navigator.of(context).pop(); // Fecha o diálogo
              },
              child: Text(
                "Remover",
                style: TextStyle(color: Colors.blue[600]),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteSelectedMedications(BuildContext context) async {
    final provider = Provider.of<MedicationProvider>(context, listen: false);
    final historyProvider =
        Provider.of<HistoryMedicationProvider>(context, listen: false);
    for (var medication in selectedMedications) {
      //Cancelando alarmes
      await cancelMedicationAlarms(medication);

      historyProvider.addHistoryMedication(medication.copy(),
          action: "Removido");
      provider.removeMedication(medication);
    }

    // Mostrar feedback ao usuário
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Medicamentos e alarmes removidos com sucesso'),
        duration: Duration(seconds: 2),
      ),
    );
    
    setState(() {
      selectedMedications.clear();
      isSelectionMode = false;
    });
  }

  @override
  void initState() {
    Future.microtask(() {
      Provider.of<MedicationProvider>(context, listen: false)
          .fetchMedications();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MedicationProvider>(
      builder: (context, provider, child) {
        final medications = provider.medications;

        return Scaffold(
          appBar: isSelectionMode
              ? AppBar(
                  title: Text('${selectedMedications.length} selecionado(s)'),
                  leading: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: toggleSelectionMode,
                  ),
                  actions: [
                    Checkbox(
                      value: selectedMedications.length == medications.length,
                      onChanged: (value) => toggleSelectAll(medications),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () =>
                          confirmDeleteSelectedMedications(context),
                    ),
                  ],
                )
              : null,
          body: ListView.builder(
            itemCount: medications.length + 1, // Um item a mais para o botão
            itemBuilder: (context, index) {
              if (index == medications.length) {
                // Último item - botão de adicionar medicamento
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
                  child: Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          final newMedication = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddMedicationScreen(),
                            ),
                          );

                          if (newMedication != null) {
                            provider.addMedication(newMedication);
                          }
                        },
                        child: Icon(
                          Icons.add_circle_outline_outlined,
                          color: Colors.blueAccent[400],
                          size: 25,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      const Text(
                        'Adicionar novo medicamento',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                );
              } else {
                // Itens da lista de medicamentos
                final medication = medications[index];
                final isSelected = selectedMedications.contains(medication);

                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 1.h),
                  child: ListTile(
                    leading: medication.imageURL.isNotEmpty
                        ? ClipOval(
                            child: Image.file(
                              File(medication.imageURL),
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Icon(Icons.medication),
                    title: Text(medication.medicationName),
                    trailing: isSelectionMode
                        ? Checkbox(
                            value: isSelected,
                            onChanged: (value) {
                              setState(() {
                                isSelected
                                    ? selectedMedications.remove(medication)
                                    : selectedMedications.add(medication);
                              });
                            },
                          )
                        : Switch(
                            activeTrackColor: Colors.black,
                            value: medication.isActive,
                            onChanged: (value) async {
                              final updatedMedication =
                                  medication.copyWith(isActive: value);
                              provider.editMedication(
                                updatedMedication,
                              );
                              // Gerenciar os alarmes
                              await manageMedicationAlarms(updatedMedication);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(value
                                      ? 'Alarmes ativados para ${medication.medicationName}'
                                      : 'Alarmes desativados para ${medication.medicationName}'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                          ),
                    onTap: () {
                      if (isSelectionMode) {
                        setState(() {
                          isSelected
                              ? selectedMedications.remove(medication)
                              : selectedMedications.add(medication);
                        });
                      } else {
                        // Define o medicamento selecionado no provider
                        context
                            .read<MedicationProvider>()
                            .selectMedication(medication);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MedicationDetailsScreen(),
                          ),
                        );
                      }
                    },
                    onLongPress: toggleSelectionMode,
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }
}
