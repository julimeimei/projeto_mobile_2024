import 'dart:io';
import 'package:flutter/material.dart';
import 'package:projeto_mobile/model/medicationModel.dart';
import 'package:projeto_mobile/view/addMedicationScreen.dart';
import 'package:projeto_mobile/view/medicationDetailsScreen.dart';
import 'package:sizer/sizer.dart';

class MedicationScreen extends StatefulWidget {
  final List<MedicationModel> medications;
  final Function(MedicationModel) onMedicationAdded;

  MedicationScreen({
    required this.medications,
    required this.onMedicationAdded,
    super.key,
  });

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

  void toggleSelectAll() {
    setState(() {
      if (selectedMedications.length == widget.medications.length) {
        selectedMedications.clear();
      } else {
        selectedMedications = List.from(widget.medications);
      }
    });
  }

  void confirmDeleteSelectedMedications() {
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
              onPressed: () {
                deleteSelectedMedications(); // Chama a função para excluir os itens
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

  void deleteSelectedMedications() {
    setState(() {
      widget.medications
          .removeWhere((med) => selectedMedications.contains(med));
      selectedMedications.clear();
      isSelectionMode = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  value:
                      selectedMedications.length == widget.medications.length,
                  onChanged: (value) => toggleSelectAll(),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: confirmDeleteSelectedMedications,
                ),
              ],
            )
          : null,
      body: ListView.builder(
        itemCount: widget.medications.length + 1, // Um item a mais para o botão
        itemBuilder: (context, index) {
          if (index == widget.medications.length) {
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
                        widget.onMedicationAdded(newMedication);
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
            final medication = widget.medications[index];
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
                        onChanged: (value) {
                          setState(() {
                            medication.isActive = value;
                          });
                        },
                      ),
                onTap: () async {
                  if (isSelectionMode) {
                    setState(() {
                      isSelected
                          ? selectedMedications.remove(medication)
                          : selectedMedications.add(medication);
                    });
                  } else {
                    final updatedMedication = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MedicationDetailsScreen(
                          medication: medication,
                        ),
                      ),
                    );

                    if (updatedMedication != null) {
                      setState(() {
                        widget.medications[index] = updatedMedication;
                      });
                    }
                  }
                },
                onLongPress: toggleSelectionMode,
              ),
            );
          }
        },
      ),
    );
  }
}
