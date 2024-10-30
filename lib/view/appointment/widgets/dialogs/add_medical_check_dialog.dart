import 'package:flutter/material.dart';
import 'package:projeto_mobile/view/appointment/widgets/forms/add_medical_check_form.dart';
import 'package:projeto_mobile/model/appointmentModel.dart';

class AddMedicalCheckDialog extends StatelessWidget {
  final Function(AppointmentModel) onAppointmentAdded;

  const AddMedicalCheckDialog({super.key, required this.onAppointmentAdded});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Adicionar Nova Consulta',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: Colors.red), // Ícone "X" vermelho
            onPressed: () {
              Navigator.of(context).pop(); // Fecha o diálogo
            },
          ),
        ],
      ),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: EdgeInsets.all(16),
        child: AddMedicalCheckForm(
          onSubmit: (String patientName, String specialty, String doctorName, String location, DateTime date, TimeOfDay time, String additionalInfo) {
            final newAppointment = AppointmentModel(
              patientName: patientName,
              specialty: specialty,
              doctorName: doctorName,
              location: location,
              date: date,
              time: time,
              additionalInfo: additionalInfo,
            );

            onAppointmentAdded(newAppointment);
            Navigator.of(context).pop();
          },
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // Bordas arredondadas
      ),
    );
  }
}
