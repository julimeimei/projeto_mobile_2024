import 'dart:io';

import 'package:flutter/material.dart';
import 'package:projeto_mobile/model/medicationModel.dart';
import 'package:projeto_mobile/provider/historyMedProvider.dart';
import 'package:projeto_mobile/view/mainScreen.dart';
import 'package:projeto_mobile/view/medicationDetailsScreen.dart';
import 'package:projeto_mobile/view/medicationHistoryScreen.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class HistoryScreen extends StatefulWidget {
  final List<MedicationModel> medicationHistory;

  HistoryScreen({required this.medicationHistory, super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  bool isSelectionMode = false;
  List<MedicationModel> selectedItems = [];

  void toggleSelectionMode() {
    setState(() {
      isSelectionMode = !isSelectionMode;
      selectedItems.clear();
    });
  }

  void toggleSelectAll() {
    setState(() {
      if (selectedItems.length == widget.medicationHistory.length) {
        selectedItems.clear();
      } else {
        selectedItems = List.from(widget.medicationHistory);
      }
    });
  }

  void confirmDeleteSelectedItems() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Excluir histórico"),
          content: Text("Deseja realmente remover os itens selecionados?"),
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
                deleteSelectedItems(); // Chama a função para excluir os itens
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

  void deleteSelectedItems() {
    setState(() {
      widget.medicationHistory
          .removeWhere((med) => selectedItems.contains(med));
      selectedItems.clear();
      isSelectionMode = false;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HistoryMedicationProvider>(context, listen: false)
          .fetchHistoryMedications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isSelectionMode
          ? AppBar(
              title: Text('${selectedItems.length} selecionado(s)'),
              leading: IconButton(
                icon: Icon(Icons.close),
                onPressed: toggleSelectionMode,
              ),
              actions: [
                Checkbox(
                  value:
                      selectedItems.length == widget.medicationHistory.length,
                  onChanged: (value) => toggleSelectAll(),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: confirmDeleteSelectedItems,
                ),
              ],
            )
          : AppBar(
              backgroundColor: Colors.blue[400],
              title: const Text('Histórico'),
              centerTitle: true,
            ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Image.asset(
                'images/remanegy-high-resolution-logo-transparent.png',
                height: 30,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Tela inicial'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configurações'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Consumer<HistoryMedicationProvider>(
        builder: (context, historyProvider, _) {
          final medicationsPerDate = historyProvider.medicationsPerDate;

          // if (medicationsPerDate.isEmpty) {
          //   return Center(child: Text("Nenhum medicamento adicionado ainda."));
          // }
          if (medicationsPerDate.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.medication_outlined,
                      size: 100, color: Colors.grey),
                  Text(
                    "Nenhum medicamento no histórico",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView(
            children: medicationsPerDate.keys.map((data) {
              final medicamentos = medicationsPerDate[data]!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(data,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  // ListView.builder para exibir os medicamentos
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: medicamentos.length,
                    itemBuilder: (context, index) {
                      final medicamento = medicamentos[index];
                      final isSelected = selectedItems.contains(medicamento);
                      print(medicamento.action);
                      return ListTile(
                        leading: medicamento.imageURL.isNotEmpty
                            ? ClipOval(
                                child: Image.file(
                                  File(medicamento.imageURL),
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(
                                    Icons.error,
                                    size: 50,
                                  ),
                                ),
                              )
                            : const Icon(Icons.medication),
                        title: Text(medicamento.medicationName),
                        subtitle: Text(
                          "${medicamento.action} às ${medicamento.addDate.hour.toString().padLeft(2, '0')}:${medicamento.addDate.minute.toString().padLeft(2, '0')}.",
                        ),
                        trailing: isSelectionMode
                            ? Checkbox(
                                value: isSelected,
                                onChanged: (value) {
                                  setState(() {
                                    isSelected
                                        ? selectedItems.remove(medicamento)
                                        : selectedItems.add(medicamento);
                                  });
                                },
                              )
                            : Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                    color: _getActionColor(medicamento.action ??
                                            'Indefinido') // Use null-aware operator
                                        .withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(14)),
                                child: Text(
                                  medicamento.action ??
                                      'Indefinido', // Provide a default value
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: _getActionColor(
                                          medicamento.action ??
                                              'Indefinido')), // Same here
                                ),
                              ),
                        onTap: () {
                          if (isSelectionMode) {
                            setState(() {
                              isSelected
                                  ? selectedItems.remove(medicamento)
                                  : selectedItems.add(medicamento);
                            });
                          } else {
                            // Define o medicamento selecionado no provider
                            context
                                .read<HistoryMedicationProvider>()
                                .selectMedication(medicamento);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MedicationHistoryScreen(),
                              ),
                            );
                          }
                        },
                        onLongPress: toggleSelectionMode,
                      );
                    },
                  ),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Color _getActionColor(String action) {
    switch (action) {
      case "Adicionado":
        return Colors.green;
      case "Editado":
        return Colors.orange;
      case "Removido":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
