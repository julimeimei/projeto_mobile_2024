import 'package:flutter/material.dart';
import 'package:projeto_mobile/widgets/dialogs/add_medical_check_dialog.dart';
import 'package:sizer/sizer.dart';
import 'package:projeto_mobile/model/appointmentModel.dart';

class AppointmentScreen extends StatelessWidget {
  final List<AppointmentModel> appointments; // Lista de consultas
  final Function(AppointmentModel) onAppointmentAdded;

  const AppointmentScreen({
    super.key,
    required this.appointments,
    required this.onAppointmentAdded,
  });

  void _showAddMedicalCheckDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddMedicalCheckDialog(
          onAppointmentAdded: (appointment) {
            onAppointmentAdded(appointment);
          },
        );
      },
    );
  }

  void _showAppointmentDetails(BuildContext context, AppointmentModel appointment) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Detalhes da Consulta'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Médico: ${appointment.doctorName}'),
              Text('Local: ${appointment.location}'),
              Text('Data: ${appointment.date?.day}/${appointment.date?.month}/${appointment.date?.year}'),
              Text('Horário: ${appointment.time?.format(context)}'),
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              SizedBox(height: 10.h),
              SizedBox(width: 2.w),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => _showAddMedicalCheckDialog(context),
                child: Icon(
                  Icons.add_circle_outline_outlined,
                  color: Colors.blueAccent[400],
                  size: 25,
                ),
              ),
              SizedBox(width: 2.w),
              Text(
                'Adicionar nova consulta',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          SizedBox(height: 10), // Espaçamento entre o botão e a lista
          Expanded(
            child: ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final appointment = appointments[index];
                return ListTile(
                  title: Text(appointment.doctorName), // Nome do médico
                  subtitle: Text(
                    'Data: ${appointment.date?.day}/${appointment.date?.month}/${appointment.date?.year} - '
                        'Horário: ${appointment.time?.format(context)}',
                  ), // Data e horário
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () {
                    _showAppointmentDetails(context, appointment); // Mostra os detalhes
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
