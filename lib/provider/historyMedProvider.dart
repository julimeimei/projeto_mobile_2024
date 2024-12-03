import 'package:flutter/material.dart';
import 'package:projeto_mobile/model/medicationModel.dart';

class HistoryMedicationProvider with ChangeNotifier{
  final List<MedicationModel> _historyMedication = [];
  
  List<MedicationModel> get historyMedication => _historyMedication;

  void addHistoryMedication(MedicationModel medication){
    _historyMedication.add(medication);
    notifyListeners();
  }

  Map<String, List<MedicationModel>> get medicationsPerDate {
    Map<String, List<MedicationModel>> groupedMedications = {};

    for (var medication in _historyMedication) {
      String formatedDate = formatDate(medication.addDate);
      if (!groupedMedications.containsKey(formatedDate)) {
        groupedMedications[formatedDate] = [];
      }
      groupedMedications[formatedDate]!.add(medication);
    }

    return groupedMedications;
  }

  String formatDate(DateTime data) {
    final today = DateTime.now();
    final yesterday = today.subtract(Duration(days: 1));

    if (data.year == today.year && data.month == today.month && data.day == today.day) {
      return "Hoje";
    } else if (data.year == yesterday.year && data.month == yesterday.month && data.day == yesterday.day) {
      return "Ontem";
    } else {
      return "${data.day}/${data.month}/${data.year}";
    }
  }
}