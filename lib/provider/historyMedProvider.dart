import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:projeto_mobile/model/medicationModel.dart';
import 'package:uuid/uuid.dart';

class HistoryMedicationProvider with ChangeNotifier {
  final List<MedicationModel> _historyMedication = [];
  MedicationModel? _selectedMedication;

  List<MedicationModel> get historyMedication => _historyMedication;

  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref('Users');

  // Seleciona o medicamento
  MedicationModel? get selectedMedication => _selectedMedication;

  void selectMedication(MedicationModel medication) {
    _selectedMedication = medication;
    notifyListeners();
  }

  // Adiciona um histórico ao Firebase
  Future<void> addHistoryMedication(
    MedicationModel medication, {
    String action = "Adicionado",
  }) async {
    try {
      // Obtém o ID do usuário autenticado
      String? userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId != null) {
        medication.action = action;
        medication.addDate = DateTime.now();
        medication.id = const Uuid().v4();

        // Caminho para salvar o histórico
        await _dbRef
            .child('$userId/History/${medication.id}')
            .set(medication.toMap());
        _historyMedication.add(medication);
        notifyListeners();
      }
    } catch (error) {
      debugPrint('Erro ao adicionar histórico de medicamento: $error');
    }
  }

  // Busca o histórico de medicamentos do Firebase
  Future<void> fetchHistoryMedications() async {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId == null) {
        debugPrint('Usuário não autenticado');
        _historyMedication.clear();
        notifyListeners();
        return;
      }

      final snapshot = await _dbRef.child('$userId/History').get();

      if (!snapshot.exists || snapshot.value == null) {
        debugPrint('Nenhum histórico encontrado ou dados nulos');
        _historyMedication.clear();
        notifyListeners();
        return;
      }

      // Garante que é um Map
      final Map<dynamic, dynamic> historyData =
          snapshot.value is Map ? snapshot.value as Map : {};

      _historyMedication.clear();

      historyData.forEach((key, value) {
        try {
          // Converte o value para Map<String, dynamic>
          if (value is Map) {
            final Map<String, dynamic> medicationMap =
                Map<String, dynamic>.from(value);

            final medication = MedicationModel.fromMap(medicationMap);

            _historyMedication.add(medication);
          }
        } catch (e) {
          debugPrint('Erro ao processar medicamento: $e');
        }
      });

      notifyListeners();
    } catch (error) {
      debugPrint('Erro ao buscar histórico de medicamentos: $error');
      _historyMedication.clear();
      notifyListeners();
    }
  }

  // Future<void> fetchHistoryMedications() async {
  //   try {
  //     // Obtém o ID do usuário autenticado
  //     String? userId = FirebaseAuth.instance.currentUser?.uid;

  //     if (userId != null) {
  //       final snapshot = await _dbRef.child('$userId/History').get();

  //       if (snapshot.exists) {
  //         final historyMap = Map<String, dynamic>.from(snapshot.value as Map);
  //         _historyMedication.clear();
  //         historyMap.forEach((key, value) {
  //           _historyMedication.add(MedicationModel.fromMap(value));
  //         });
  //         notifyListeners();
  //       }
  //     }
  //   } catch (error) {
  //     debugPrint('Erro ao buscar histórico de medicamentos: $error');
  //   }
  // }

  // Agrupa os medicamentos por data formatada
  Map<String, List<MedicationModel>> get medicationsPerDate {
    Map<String, List<MedicationModel>> groupedMedications = {};

    for (var medication in _historyMedication) {
      String formattedDate = formatDate(medication.addDate);
      if (!groupedMedications.containsKey(formattedDate)) {
        groupedMedications[formattedDate] = [];
      }
      groupedMedications[formattedDate]!.add(medication);
    }

    return groupedMedications;
  }

  // Formata a data
  String formatDate(DateTime data) {
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));

    if (data.year == today.year &&
        data.month == today.month &&
        data.day == today.day) {
      return "Hoje";
    } else if (data.year == yesterday.year &&
        data.month == yesterday.month &&
        data.day == yesterday.day) {
      return "Ontem";
    } else {
      return "${data.day}/${data.month}/${data.year}";
    }
  }
}
