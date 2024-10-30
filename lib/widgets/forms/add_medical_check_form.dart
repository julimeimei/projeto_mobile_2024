import 'package:flutter/material.dart';

class AddMedicalCheckForm extends StatefulWidget {
  final Function(String doctorName, String location, DateTime date, TimeOfDay time) onSubmit;

  const AddMedicalCheckForm({super.key, required this.onSubmit});

  @override
  _AddMedicalCheckFormState createState() => _AddMedicalCheckFormState();
}

class _AddMedicalCheckFormState extends State<AddMedicalCheckForm> {
  final _formKey = GlobalKey<FormState>();
  String doctorName = '';
  String location = '';
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

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

  void _submitForm() {
    if (_formKey.currentState!.validate() && selectedDate != null && selectedTime != null) {
      _formKey.currentState!.save();
      try {
        widget.onSubmit(doctorName, location, selectedDate!, selectedTime!);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Consulta adicionada com sucesso!')),
        );
      } catch (e) {
        print('Erro ao adicionar consulta: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao adicionar consulta: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, preencha todos os campos.')),
      );
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
            decoration: InputDecoration(labelText: 'Nome do Médico'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira o nome do médico';
              }
              return null;
            },
            onSaved: (value) {
              doctorName = value!;
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Local da Consulta'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira o local da consulta';
              }
              return null;
            },
            onSaved: (value) {
              location = value!;
            },
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Text(selectedDate == null
                  ? 'Data: não selecionada'
                  : 'Data: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'),
              IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: () => _selectDate(context),
              ),
            ],
          ),
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
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submitForm, // Chama a função de submissão do formulário
            child: Text('Adicionar'),
          ),
        ],
      ),
    );
  }
}
