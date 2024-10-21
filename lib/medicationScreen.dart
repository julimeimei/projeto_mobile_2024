import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class MedicationScreen extends StatelessWidget {
  const MedicationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
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
                'Adicionar novo remédio',
                style: TextStyle(fontSize: 16),
              ),
            ],
          )
        ],
      ),
    );
  }
}
