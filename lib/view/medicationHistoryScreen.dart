import 'package:flutter/material.dart';
import 'package:projeto_mobile/model/medicationModel.dart';
import 'dart:io';

import 'package:projeto_mobile/provider/historyMedProvider.dart';
import 'package:provider/provider.dart';

class MedicationHistoryScreen extends StatelessWidget {
  MedicationHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: const Text(
          'Detalhes do medicamento',
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
      ),
      backgroundColor: Color.fromARGB(255, 244, 244, 244),
      body: Consumer<HistoryMedicationProvider>(
        builder: (context, historyProvider, _) {
          final medication = historyProvider.selectedMedication;

          if (medication == null) {
            return Center(
              child: Text(
                "Medicamento não encontrado.",
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Center(
                    child: ClipOval(
                      child: medication.imageURL.isNotEmpty
                          ? Image.file(
                              File(medication.imageURL),
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                Icons.error,
                                size: 200,
                              ),
                            )
                          : Icon(
                              Icons.medication,
                              size: 100,
                              color: Colors.grey,
                            ),
                    ),
                  ),
                  SizedBox(height: 16),
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
                  // _buildDetailRow('Unidades do medicamento',
                  //     '${medication.medicationUnits} unidades'),
                  // _buildDetailRow('Data de vencimento', medication.dueDate),
                  _buildDetailRow(
                      'Dias de uso', medication.daysOfWeek.join(", ")),
                  _buildDetailRow(
                      'Horários de uso', medication.medicationTime.join(", ")),
                  _buildDetailRow('Informações adicionais',
                      medication.additionalInfo ?? "Nenhuma"),
                ],
              ),
            ),
          );
        },
      ),
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
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
