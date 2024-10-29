import 'package:flutter/material.dart';
import 'package:projeto_mobile/view/addMedicationScreen.dart';
import 'package:projeto_mobile/view/mainScreen.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, screenType) {
        return const MaterialApp(
          home: MainScreen(),
        );
      },
    );
  }
}
