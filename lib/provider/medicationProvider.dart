import 'package:flutter/material.dart';
import 'package:projeto_mobile/model/medicationModel.dart';

class MedicationProvider with ChangeNotifier {
  final List<MedicationModel> _medications = [];
  MedicationModel? _selectedMedication;

  List<MedicationModel> get medications => _medications;

  // Retorna medicamento selecionado
  MedicationModel? get selectedMedication => _selectedMedication;

  // Define o medicamento selecionado
  void selectMedication(MedicationModel medication) {
    _selectedMedication = medication;
    notifyListeners();
  }

  void addMedication(MedicationModel medication){
    _medications.add(medication);
    notifyListeners();
  }

  void editMedication(MedicationModel updatedMedication) {
    // Encontra o índice do medicamento existente
    int index = _medications.indexWhere((med) => med.id == updatedMedication.id);
    
    if (index != -1) {
      // Substitui o medicamento existente
      _medications[index] = updatedMedication;
      _selectedMedication = updatedMedication;
      notifyListeners();
    }
  }

  void removeMedication(MedicationModel medication) {
    _medications.removeWhere((med) => med.id == medication.id);
    notifyListeners();
  }

  // Método opcional para remover medicamento por ID
  void removeMedicationById(String id) {
    _medications.removeWhere((med) => med.id == id);
    notifyListeners();
  }
}