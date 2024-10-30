import 'package:flutter/material.dart';

class AddMedicalCheckForm extends StatefulWidget {
  final Function(String, String, String, String, DateTime, TimeOfDay, String) onSubmit;

  const AddMedicalCheckForm({super.key, required this.onSubmit});

  @override
  _AddMedicalCheckFormState createState() => _AddMedicalCheckFormState();
}

class _AddMedicalCheckFormState extends State<AddMedicalCheckForm> {
  final _formKey = GlobalKey<FormState>();

  String patientName = '';
  String specialty = '';
  String doctorName = '';
  String location = '';
  DateTime? date;
  TimeOfDay? time;
  String additionalInfo = '';

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
            _buildTextField(
              label: 'Para quem é a consulta',
              onChanged: (value) => patientName = value,
            ),
            _buildTextField(
              label: 'Especialidade do Médico',
              onChanged: (value) => specialty = value,
            ),
            _buildTextField(
              label: 'Nome do Médico',
              onChanged: (value) => doctorName = value,
            ),
            _buildTextField(
              label: 'Local',
              onChanged: (value) => location = value,
            ),
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
            _buildTextField(
              label: 'Informações Adicionais',
              onChanged: (value) => additionalInfo = value,
              isOptional: true,
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: () {
                  if (_formKey.currentState!.validate() && date != null && time != null) {
                    widget.onSubmit(
                      patientName,
                      specialty,
                      doctorName,
                      location,
                      date!,
                      time!,
                      additionalInfo,
                    );
                  }
                },
                backgroundColor: Colors.blue[600],
                child: Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required Function(String) onChanged,
    bool isOptional = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          labelStyle: TextStyle(color: Colors.black),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue[600]!),
          ),
        ),
        onChanged: onChanged,
        validator: (value) => isOptional || value!.isNotEmpty ? null : 'Campo obrigatório',
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
