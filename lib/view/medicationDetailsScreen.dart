import 'package:flutter/material.dart';
import 'package:projeto_mobile/model/medicationModel.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:projeto_mobile/view/editMedicationScreen.dart';
import 'package:sizer/sizer.dart';

class MedicationDetailsScreen extends StatefulWidget {
  MedicationModel medication;

  MedicationDetailsScreen({required this.medication, super.key});

  @override
  State<MedicationDetailsScreen> createState() =>
      _MedicationDetailsScreenState();
}

class _MedicationDetailsScreenState extends State<MedicationDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<String>(
              icon: Icon(Icons.more_vert),
              color: Color.fromARGB(255, 244, 244, 244),
              onSelected: (value) async {
                if (value == 'edit') {
                  final updatedMedication = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditMedicationScreen(
                          medicationToEdit: widget.medication),
                    ),
                  );

                  // Verifica se um medicamento atualizado foi retornado
                  if (updatedMedication != null) {
                    setState(() {
                      widget.medication = updatedMedication;
                    });
                  }
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem<String>(
                    value: 'edit',
                    child: Text('Editar'),
                  ),
                  // const PopupMenuItem<String>(
                  //   value: 'logout',
                  //   child: Text('Sair'),
                  // ),
                ];
              })
        ],
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
                    File(widget.medication.imageURL),
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 16),
              _buildDetailRow('Nome', widget.medication.userName),
              _buildDetailRow('Medicamento', widget.medication.medicationName),
              _buildDetailRow(
                  'Via de administração', widget.medication.adminRoute),
              _buildDetailRow('Como usar', widget.medication.howToUse),
              _buildDetailRow(
                  'Dosagem',  '${widget.medication.dosage} unidades'),
              _buildDetailRow(
                  'Vezes ao dia', '${widget.medication.usageTimes} vezes'),
              _buildDetailRow(
                  'Intervalo de uso', '${widget.medication.usageRange} horas'),
              _buildDetailRow('Unidades do medicamento',
                  '${widget.medication.medicationUnits} unidades'),
              _buildDetailRow('Data de vencimento', widget.medication.dueDate),
              _buildDetailRow(
                  'Dias de uso', widget.medication.daysOfWeek.join(", ")),
              _buildDetailRow('Horários de uso',
                  widget.medication.medicationTime.join(", ")),
              _buildDetailRow(
                  'Informações adicionais', widget.medication.additionalInfo!),
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
