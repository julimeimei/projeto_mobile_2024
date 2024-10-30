import 'package:flutter/material.dart';
import 'package:projeto_mobile/model/medicationModel.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:projeto_mobile/view/editMedicationScreen.dart';
import 'package:sizer/sizer.dart';

class MedicationHistoryScreen extends StatefulWidget {
  MedicationModel medication;

  MedicationHistoryScreen({required this.medication, super.key});

  @override
  State<MedicationHistoryScreen> createState() =>
      _MedicationHistoryScreenState();
}

class _MedicationHistoryScreenState extends State<MedicationHistoryScreen> {
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Center(
                child: ClipOval(
                  child: Image.file(
                    File(widget.medication!.imageURL),
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 16),
              _buildDetailRow('Nome', widget.medication!.userName),
              _buildDetailRow('Medicamento', widget.medication!.medicationName),
              _buildDetailRow(
                  'Via de administração', widget.medication!.adminRoute),
              _buildDetailRow('Como usar', widget.medication!.howToUse),
              _buildDetailRow(
                  'Dosagem', '${widget.medication!.dosage} unidades'),
              _buildDetailRow(
                  'Vezes ao dia', '${widget.medication!.usageTimes} vezes'),
              _buildDetailRow(
                  'Intervalo de uso', '${widget.medication!.usageRange} horas'),
              _buildDetailRow('Unidades do medicamento',
                  '${widget.medication!.medicationUnits} unidades'),
              _buildDetailRow('Data de vencimento', widget.medication!.dueDate),
              _buildDetailRow(
                  'Dias de uso', widget.medication!.daysOfWeek.join(", ")),
              _buildDetailRow('Horários de uso',
                  widget.medication!.medicationTime.join(", ")),
              _buildDetailRow(
                  'Informações adicionais', widget.medication!.additionalInfo!),
            ],
          ),
        ),
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
