import 'package:flutter/material.dart';
import 'package:projeto_mobile/model/medicationModel.dart';
import 'package:sizer/sizer.dart';

class MedicationScreen extends StatefulWidget {
  const MedicationScreen({super.key});

  @override
  State<MedicationScreen> createState() => _MedicationScreenState();
}

class _MedicationScreenState extends State<MedicationScreen> {
  List<MedicationModel> medications = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: medications.length,
                  itemBuilder: (context, index) {
                    final medication = medications[index];
                    return ListTile(
                      leading: Icon(Icons.medication),
                      title: Text(medication.medicationName!),
                      trailing: Switch(
                          value: medication.isActive,
                          onChanged: (value) {
                            setState(() {
                              medication.isActive = value;
                            });
                          }),
                    );
                  })),
          Row(
            children: [
              SizedBox(
                height: 10.h,
              ),
              SizedBox(
                width: 2.w,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {},
                  child: Icon(
                    color: Colors.blueAccent[400],
                    size: 25,
                    Icons.add_circle_outline_outlined,
                  )),
              SizedBox(
                width: 2.w,
              ),
              Text(
                'Adicionar novo medicamento',
                style: TextStyle(fontSize: 16),
              ),
            ],
          )
        ],
      ),
    );
  }
}
