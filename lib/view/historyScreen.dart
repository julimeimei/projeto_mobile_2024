import 'dart:io';

import 'package:flutter/material.dart';
import 'package:projeto_mobile/model/medicationModel.dart';
import 'package:projeto_mobile/provider/historyMedProvider.dart';
import 'package:projeto_mobile/view/mainScreen.dart';
import 'package:projeto_mobile/view/medicationDetailsScreen.dart';
import 'package:projeto_mobile/view/medicationHistoryScreen.dart';
import 'package:provider/provider.dart';

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
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Remanegy',
                style: TextStyle(fontSize: 30, color: Colors.black),
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

          if (medicationsPerDate.isEmpty) {
            return Center(child: Text("Nenhum medicamento adicionado ainda."));
          }

          return ListView(
            children: medicationsPerDate.keys.map((data) {
              final medications = medicationsPerDate[data]!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(data,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  ...medications.map((medication) {
                    return ListTile(
                      title: Text(medication.medicationName),
                      subtitle:
                          Text(historyProvider.formatDate(medication.addDate)),
                    );
                  }).toList(),
                ],
              );
            }).toList(),
          );
        },
      ),
      // ListView.builder(
      //   itemCount: widget.medicationHistory.length,
      //   itemBuilder: (context, index) {
      //     final medication = widget.medicationHistory[index];
      //     final isSelected = selectedItems.contains(medication);
      //     return ListTile(
      //       leading: medication.imageURL.isNotEmpty
      //           ? ClipOval(
      //               child: Image.file(
      //                 File(medication.imageURL),
      //                 width: 50,
      //                 height: 50,
      //                 fit: BoxFit.cover,
      //               ),
      //             )
      //           : const Icon(Icons.medication),
      //       title: Text(medication.medicationName),
      //       trailing: isSelectionMode
      //           ? Checkbox(
      //               value: isSelected,
      //               onChanged: (value) {
      //                 setState(() {
      //                   isSelected
      //                       ? selectedItems.remove(medication)
      //                       : selectedItems.add(medication);
      //                 });
      //               },
      //             )
      //           : null,
      //       onTap: () {
      //         if (isSelectionMode) {
      //           setState(() {
      //             isSelected
      //                 ? selectedItems.remove(medication)
      //                 : selectedItems.add(medication);
      //           });
      //         } else {
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //               builder: (context) => MedicationHistoryScreen(
      //                 medication: medication,
      //               ),
      //             ),
      //           );
      //         }
      //       },
      //       onLongPress: toggleSelectionMode,
      //     );
      //   },
      // ),
    );
  }
}
