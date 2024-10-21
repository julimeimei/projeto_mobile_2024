import 'package:flutter/material.dart';

class AddMedicineForm extends StatefulWidget {
  @override
  _AddMedicineFormState createState() => _AddMedicineFormState();
}

class _AddMedicineFormState extends State<AddMedicineForm> {
  final _formKey = GlobalKey<FormState>();
  String medicineName = '';
  String dosage = '';
  TimeOfDay? selectedTime;

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'Nome do Remédio'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira o nome do remédio';
              }
              return null;
            },
            onSaved: (value) {
              medicineName = value!;
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Dosagem'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira a dosagem';
              }
              return null;
            },
            onSaved: (value) {
              dosage = value!;
            },
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Text(selectedTime == null
                  ? 'Horário: não selecionado'
                  : 'Horário: ${selectedTime!.format(context)}'),
              IconButton(
                icon: Icon(Icons.access_time),
                onPressed: () => _selectTime(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
