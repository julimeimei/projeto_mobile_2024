import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:projeto_mobile/provider/appointment/AppointmentProvider.dart';
import 'package:provider/provider.dart';
import 'package:projeto_mobile/model/appointmentModel.dart';
import 'package:fluttertoast/fluttertoast.dart'; // Importar o Fluttertoast

class AddMedicalCheckForm extends StatefulWidget {
  final String? initialDoctorName;
  final String? initialSpecialty;
  final String? initialLocation;

  const AddMedicalCheckForm({
    super.key,
    this.initialDoctorName,
    this.initialSpecialty,
    this.initialLocation,
  });

  @override
  _AddMedicalCheckFormState createState() => _AddMedicalCheckFormState();
}

class _AddMedicalCheckFormState extends State<AddMedicalCheckForm> {
  final _formKey = GlobalKey<FormState>();

  DateTime? date;
  TimeOfDay? time;

  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: date ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != date) {
      setState(() {
        date = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: time ?? TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != time) {
      setState(() {
        time = pickedTime;
      });
    }
  }

  Future<String> _fetchUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    final snapshot = await FirebaseDatabase.instance.ref('Users/${user?.uid}').get();
    if (snapshot.exists) {
      final data = snapshot.value as Map;
      return data['userName'] ?? '';
    }
    return '';
  }

  Future<void> _submitForm(BuildContext context) async {
    if (date != null && time != null) {
      final user = FirebaseAuth.instance.currentUser;
      final userName = await _fetchUserName();

      final appointment = AppointmentModel(
        patientName: userName,
        specialty: widget.initialSpecialty ?? '',
        doctorName: widget.initialDoctorName ?? '',
        location: widget.initialLocation ?? '',
        date: date!,
        time: time!,
        additionalInfo: '',
      );

      Provider.of<AppointmentProvider>(context, listen: false).addAppointment(appointment);

      // Exibe o toast para informar que a operação foi bem-sucedida
      Fluttertoast.showToast(
        msg: "Consulta adicionada com sucesso!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      Navigator.of(context).pop();
    } else {
      // Exibe um alerta se os campos obrigatórios não forem preenchidos
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, selecione a data e a hora!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            _buildDateTimeButton(
              label: 'Selecionar Data',
              selectedDate: date,
              onPressed: () => _selectDate(context),
              icon: Icons.calendar_today,
            ),
            _buildDateTimeButton(
              label: 'Selecionar Hora',
              selectedTime: time,
              onPressed: () => _selectTime(context),
              icon: Icons.access_time,
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: () => _submitForm(context),
                backgroundColor: Colors.blue[600],
                child: Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTimeButton({
    required String label,
    DateTime? selectedDate,
    TimeOfDay? selectedTime,
    required Function() onPressed,
    required IconData icon,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: TextButton(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.blue[600]),
            SizedBox(width: 8),
            Text(
              selectedDate != null
                  ? 'Data: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}' // Formato dia/mês/ano
                  : selectedTime != null
                  ? 'Hora: ${selectedTime.format(context)}'
                  : label,
              style: TextStyle(color: Colors.blue[600]),
            ),
          ],
        ),
      ),
    );
  }
}
