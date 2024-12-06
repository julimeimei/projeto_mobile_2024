import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:projeto_mobile/firebase_options.dart';
import 'package:projeto_mobile/provider/historyMedProvider.dart';
import 'package:projeto_mobile/provider/medicationProvider.dart';
import 'package:projeto_mobile/view/authScreens/signInLogicScreen.dart';
import 'package:projeto_mobile/view/historyScreen.dart';
import 'package:projeto_mobile/view/mainScreen.dart';
import 'package:projeto_mobile/view/medicationDetailsScreen.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
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
          home: SignInLogicScreen(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
