import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:projeto_mobile/model/medicationModel.dart';

class MedicationProvider with ChangeNotifier {
  final List<MedicationModel> _medications = [];
  MedicationModel? _selectedMedication;

  List<MedicationModel> get medications => _medications;

  MedicationModel? get selectedMedication => _selectedMedication;

  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref('Users');

  // Seleciona o medicamento
  void selectMedication(MedicationModel medication) {
    _selectedMedication = medication;
    notifyListeners();
  }

  // Adiciona um medicamento ao Firebase no caminho "Users/user.id/Medications/medication.id"
  Future<void> addMedication(MedicationModel medication) async {
    try {
      // Obtém o ID do usuário autenticado
      String? userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId != null) {
        // Caminho para salvar o medicamento
        await _dbRef
            .child('$userId/Medications/${medication.id}')
            .set(medication.toMap());
        _medications.add(medication);
        notifyListeners();
      }
    } catch (error) {
      debugPrint('Erro ao adicionar medicamento: $error');
    }
  }

  

  Future<void> fetchMedications() async {
  try {
    _medications.clear();
    notifyListeners();
    // Obtém o ID do usuário autenticado
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      final snapshot = await _dbRef.child('$userId/Medications').get();

      if (snapshot.exists) {
        // Converte o snapshot para o tipo correto
        final medicationsMap = Map<String, dynamic>.from(snapshot.value as Map);

        _medications.clear();

        medicationsMap.forEach((key, value) {
          // Converte o valor para Map<String, dynamic> e cria um objeto MedicationModel
          final medicationData = Map<String, dynamic>.from(value as Map);
          _medications.add(MedicationModel.fromMap(medicationData));
        });

        notifyListeners();
      }
    }
  } catch (error) {
    debugPrint('Erro ao buscar medicamentos: $error');
  }
}


  // Edita um medicamento no Firebase
  Future<void> editMedication(MedicationModel updatedMedication) async {
    try {
      // Obtém o ID do usuário autenticado
      String? userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId != null) {
        await _dbRef
            .child('$userId/Medications/${updatedMedication.id}')
            .update(updatedMedication.toMap());
        int index =
            _medications.indexWhere((med) => med.id == updatedMedication.id);
        if (index != -1) {
          _medications[index] = updatedMedication;
          _selectedMedication = updatedMedication;
          notifyListeners();
        }
      }
    } catch (error) {
      debugPrint('Erro ao editar medicamento: $error');
    }
  }

  // Remove um medicamento do Firebase
  Future<void> removeMedication(MedicationModel medication) async {
    try {
      // Obtém o ID do usuário autenticado
      String? userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId != null) {
        await _dbRef.child('$userId/Medications/${medication.id}').remove();
        _medications.removeWhere((med) => med.id == medication.id);
        notifyListeners();
      }
    } catch (error) {
      debugPrint('Erro ao remover medicamento: $error');
    }
  }
}
