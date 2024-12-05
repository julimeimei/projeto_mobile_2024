import 'package:flutter/material.dart';
import 'package:projeto_mobile/provider/historyMedProvider.dart';
import 'package:projeto_mobile/provider/medicationProvider.dart';
import 'package:projeto_mobile/view/historyScreen.dart';
import 'package:projeto_mobile/view/mainScreen.dart';
import 'package:projeto_mobile/view/medicationDetailsScreen.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => HistoryMedicationProvider()),
      ChangeNotifierProvider(create: (context) => MedicationProvider())
    ],
    child: MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          home: MainScreen(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
