import 'package:flutter/material.dart';
import 'package:projeto_mobile/model/appointmentModel.dart';
import 'package:projeto_mobile/view/appointment/widgets/dialogs/AppointmentDetailsDialog.dart';

class AppointmentList extends StatelessWidget {
  final List<AppointmentModel> appointments;
  final BuildContext parentContext;

  const AppointmentList({
    Key? key,
    required this.appointments,
    required this.parentContext,
  }) : super(key: key);

  void _showAppointmentDetails(BuildContext context, AppointmentModel appointment) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AppointmentDetailsDialog(appointment: appointment);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        return ListTile(
          title: Text(appointment.patientName),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Médico: ${appointment.doctorName}'),
              Text('Local: ${appointment.location}'),
              Text(
                'Data: ${appointment.date?.day}/${appointment.date?.month}/${appointment.date?.year} - '
                    'Horário: ${appointment.time?.format(context)}',
              ),
              if (appointment.additionalInfo.isNotEmpty)
                Text('${appointment.additionalInfo}'),
            ],
          ),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {
            _showAppointmentDetails(context, appointment);
          },
        );
      },
    );
  }
}
