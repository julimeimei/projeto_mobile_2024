import 'package:flutter/material.dart';
import 'package:projeto_mobile/model/appointmentModel.dart';

class AppointmentDetailsDialog extends StatelessWidget {
  final AppointmentModel appointment;

  const AppointmentDetailsDialog({Key? key, required this.appointment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Detalhes da Consulta'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Médico: ${appointment.doctorName}'),
          Text('Local: ${appointment.location}'),
          Text('Data: ${appointment.date?.day}/${appointment.date?.month}/${appointment.date?.year}'),
          Text('Horário: ${appointment.time?.format(context)}'),
          Text('Paciente: ${appointment.patientName}'),
          Text('Especialidade: ${appointment.specialty}'),
          if (appointment.additionalInfo.isNotEmpty)
            Text('Informações Adicionais: ${appointment.additionalInfo}'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Fecha o diálogo
          },
          child: Text('Fechar'),
        ),
      ],
    );
  }
}
