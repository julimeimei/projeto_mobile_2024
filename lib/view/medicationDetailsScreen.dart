import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:projeto_mobile/model/medicationModel.dart';
import 'package:projeto_mobile/provider/medicationProvider.dart';
import 'dart:io';
import 'package:projeto_mobile/view/editMedicationScreen.dart';

class MedicationDetailsScreen extends StatelessWidget {
  const MedicationDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MedicationProvider>(
      builder: (context, medicationProvider, child) {
        // Obtem o medicamento pelo ID
        var medication = medicationProvider.selectedMedication!;

        return Scaffold(
          appBar: AppBar(
            actions: [
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                color: const Color.fromARGB(255, 244, 244, 244),
                onSelected: (value) async {
                  if (value == 'edit') {
                    final updatedMedication = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditMedicationScreen(),
                      ),
                    );

                    // Verifica se um medicamento atualizado foi retornado
                    if (updatedMedication != null) {
                      //medicationProvider.editMedication(updatedMedication);
                      context.read<MedicationProvider>().editMedication(updatedMedication);
                    }
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    const PopupMenuItem<String>(
                      value: 'edit',
                      child: Text('Editar'),
                    ),
                  ];
                },
              )
            ],
            backgroundColor: Colors.blue[400],
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
            ),
            title: const Text(
              'Detalhes do medicamento',
              style: TextStyle(fontSize: 20),
            ),
            centerTitle: true,
          ),
          backgroundColor: const Color.fromARGB(255, 244, 244, 244),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Center(
                    child: ClipOval(
                      child: Image.file(
                        File(medication.imageURL),
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDetailRow('Nome', medication.userName),
                  _buildDetailRow('Medicamento', medication.medicationName),
                  _buildDetailRow(
                      'Via de administração', medication.adminRoute),
                  _buildDetailRow('Como usar', medication.howToUse),
                  _buildDetailRow('Dosagem', '${medication.dosage} unidades'),
                  _buildDetailRow(
                      'Vezes ao dia', '${medication.usageTimes} vezes'),
                  _buildDetailRow(
                      'Intervalo de uso', '${medication.usageRange} horas'),
                  _buildDetailRow('Unidades do medicamento',
                      '${medication.medicationUnits} unidades'),
                  _buildDetailRow('Data de vencimento', medication.dueDate),
                  _buildDetailRow(
                      'Dias de uso', medication.daysOfWeek.join(", ")),
                  _buildDetailRow(
                      'Horários de uso', medication.medicationTime.join(", ")),
                  _buildDetailRow('Informações adicionais',
                      medication.additionalInfo ?? '-'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
