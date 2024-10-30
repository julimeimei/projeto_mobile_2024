import 'package:flutter/material.dart';
import 'package:projeto_mobile/widgets/forms/add_medical_check_form.dart';
import 'package:projeto_mobile/model/appointmentModel.dart';

class AddMedicalCheckDialog extends StatelessWidget {
  final Function(AppointmentModel) onAppointmentAdded;

  const AddMedicalCheckDialog({super.key, required this.onAppointmentAdded});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Adicionar Nova Consulta'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        child: AddMedicalCheckForm(
            onSubmit: (String doctorName, String location, DateTime date, TimeOfDay time) {
                final newAppointment = AppointmentModel(
                  doctorName: doctorName,
                  location: location,
                  date: date,
                  time: time,
                );

                onAppointmentAdded(newAppointment);
                Navigator.of(context).pop();
            },
        ),
      ),
    );
  }
}
