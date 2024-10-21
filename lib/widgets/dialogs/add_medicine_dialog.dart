import 'package:flutter/material.dart';
import '../forms/add_medicine_form.dart';

class AddMedicineDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Adicionar Novo Remédio'),
      content: AddMedicineForm(),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            // @TODO: percist data
          },
          child: Text('Adicionar'),
        ),
      ],
    );
  }
}
