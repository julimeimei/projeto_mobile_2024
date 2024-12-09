import 'package:flutter/material.dart';
import 'package:projeto_mobile/model/Doctor.model.dart';
import 'package:projeto_mobile/view/appointment/widgets/forms/add_medical_check_form.dart';

class DoctorDetailScreen extends StatelessWidget {
  final Doctor doctor;

  DoctorDetailScreen({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(doctor.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage('assets/doctor_mock.png'),
            ),
            SizedBox(height: 16),
            Text(
              doctor.name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              doctor.specialty,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 16),
            Divider(),
            Text(
              'Local de Trabalho',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(doctor.workplace.name),
            Text(doctor.workplace.address),
            SizedBox(height: 16),
            Divider(),
            Text(
              'Contato',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text('Telefone: ${doctor.workplace.phoneNumber}'),
            Text('WhatsApp: ${doctor.workplace.whatsappNumber}'),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                _navigateToAppointmentForm(context, doctor);
              },
              child: Text('Agendar Consulta'),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToAppointmentForm(BuildContext context, Doctor doctor) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.9,
              maxHeight: MediaQuery.of(context).size.height * 0.9,
            ),
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Agendar Consulta',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: AddMedicalCheckForm(
                    initialDoctorName: doctor.name,
                    initialSpecialty: doctor.specialty,
                    initialLocation: doctor.workplace.name,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
