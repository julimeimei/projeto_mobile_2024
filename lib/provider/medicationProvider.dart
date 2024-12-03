import 'package:flutter/material.dart';
import 'package:projeto_mobile/model/medicationModel.dart';

class MedicationProvider with ChangeNotifier {
  final List<MedicationModel> _medications = [];

  List<MedicationModel> get medications => _medications;

  void addMedication(MedicationModel medication){
    _medications.add(medication);
    notifyListeners();
  }
}