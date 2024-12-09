import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:projeto_mobile/model/Doctor.model.dart';
import 'package:projeto_mobile/model/Workplace.model.dart';

class DoctorProvider with ChangeNotifier {
  final List<Doctor> _doctors = [];
  Doctor? _selectedDoctor;

  List<Doctor> get doctors => _doctors;

  Doctor? get selectedDoctor => _selectedDoctor;

  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref('Doctors');

  DoctorProvider() {
    fetchDoctorsMock();
  }

  void selectDoctor(Doctor doctor) {
    _selectedDoctor = doctor;
    notifyListeners();
  }

  Future<void> addDoctor(Doctor doctor) async {
    try {
      await _dbRef.set(doctor.toMap());
      _doctors.add(doctor);
      notifyListeners();
    } catch (error) {
      debugPrint('Erro ao adicionar médico: $error');
    }
  }

  Future<void> fetchDoctors() async {
    try {
      final snapshot = await _dbRef.get();
      print(snapshot.value);
      if (!snapshot.exists || snapshot.value == null) {
        print('Nenhum médico encontrado ou dados nulos');
        _doctors.clear();
        notifyListeners();
        return;
      }
      print('Médicos encontrados: ${snapshot.value}');

      _doctors.clear();

      if (snapshot.value is List) {
        print('Lista de médicos');
        final List<dynamic> doctorsList = snapshot.value as List<dynamic>;

        int index = 0;
        for (var doctorData in doctorsList) {
          if (index == 0) {
            index++;
            continue; // Pula o primeiro elemento
          }
          if (doctorData != null && doctorData is Map) {
            try {
              final doctor = Doctor.fromMap(Map<String, dynamic>.from(doctorData));
              _doctors.add(doctor);
            } catch (e) {
              debugPrint('Erro ao processar médico: $e');
            }
          }
          index++;
        }
      } else if (snapshot.value is Map) {
        final Map<dynamic, dynamic> doctorsMap = snapshot.value as Map<dynamic, dynamic>;

        doctorsMap.forEach((key, value) {
          if (value != null && value is Map) {
            try {
              final Map<String, dynamic> doctorData = Map<String, dynamic>.from(value as Map);
              final doctor = Doctor.fromMap(doctorData);
              _doctors.add(doctor);
            } catch (e) {
              debugPrint('Erro ao processar médico: $e');
            }
          }
        });
      }

      print('Médicos carregados: $_doctors');
      notifyListeners();
    } catch (error) {
      debugPrint('Erro ao buscar médicos: $error');
      _doctors.clear();
      notifyListeners();
    }
  }

  Future<void> editDoctor(Doctor updatedDoctor) async {
    try {
      await _dbRef.child(updatedDoctor.id).update(updatedDoctor.toMap());
      int index = _doctors.indexWhere((doc) => doc.id == updatedDoctor.id);
      if (index != -1) {
        _doctors[index] = updatedDoctor;
        _selectedDoctor = updatedDoctor;
        notifyListeners();
      }
    } catch (error) {
      debugPrint('Erro ao editar médico: $error');
    }
  }

  Future<void> removeDoctor(String id) async {
    try {
      await _dbRef.child(id).remove();
      _doctors.removeWhere((doc) => doc.id == id);
      notifyListeners();
    } catch (error) {
      debugPrint('Erro ao remover médico: $error');
    }
  }


  Future<void> fetchDoctorsMock() async {
    _doctors.clear(); // Limpa a lista antes de adicionar os mockados

    final mockData = [
      Doctor(
        id: '1',
        name: 'Dr. Ana Silva',
        specialty: 'Cardiologia',
        workplace: Workplace(
          id: '1',
          name: 'Clínica do Coração',
          address: 'Rua das Flores, 123',
          phoneNumber: '11 98765-4321',
          whatsappNumber: '11 98765-4321',
        ),
      ),
      Doctor(
        id: '2',
        name: 'Dr. João Souza',
        specialty: 'Dermatologia',
        workplace: Workplace(
          id: '2',
          name: 'Clínica da Pele',
          address: 'Av. Central, 456',
          phoneNumber: '21 91234-5678',
          whatsappNumber: '21 91234-5678',
        ),
      ),
      Doctor(
        id: '3',
        name: 'Dr. Maria Oliveira',
        specialty: 'Neurologia',
        workplace: Workplace(
          id: '3',
          name: 'Instituto Neurológico',
          address: 'Rua das Árvores, 789',
          phoneNumber: '31 93456-7890',
          whatsappNumber: '31 93456-7890',
        ),
      ),
      Doctor(
        id: '4',
        name: 'Dr. Pedro Lima',
        specialty: 'Ortopedia',
        workplace: Workplace(
          id: '4',
          name: 'Centro Ortopédico',
          address: 'Av. Saúde, 101',
          phoneNumber: '41 94321-5678',
          whatsappNumber: '41 94321-5678',
        ),
      ),
      Doctor(
        id: '5',
        name: 'Dr. Carla Nunes',
        specialty: 'Pediatria',
        workplace: Workplace(
          id: '5',
          name: 'Clínica Infantil',
          address: 'Praça Alegria, 202',
          phoneNumber: '51 98765-4321',
          whatsappNumber: '51 98765-4321',
        ),
      ),
      Doctor(
        id: '6',
        name: 'Dr. Lucas Almeida',
        specialty: 'Gastroenterologia',
        workplace: Workplace(
          id: '6',
          name: 'Centro de Gastro',
          address: 'Rua das Palmeiras, 303',
          phoneNumber: '61 91234-5678',
          whatsappNumber: '61 91234-5678',
        ),
      ),
      Doctor(
        id: '7',
        name: 'Dr. Fernanda Costa',
        specialty: 'Ginecologia',
        workplace: Workplace(
          id: '7',
          name: 'Clínica da Mulher',
          address: 'Av. Feminina, 404',
          phoneNumber: '71 93456-7890',
          whatsappNumber: '71 93456-7890',
        ),
      ),
      Doctor(
        id: '8',
        name: 'Dr. Rafael Barbosa',
        specialty: 'Psiquiatria',
        workplace: Workplace(
          id: '8',
          name: 'Instituto Mental',
          address: 'Rua Tranquila, 505',
          phoneNumber: '81 94321-5678',
          whatsappNumber: '81 94321-5678',
        ),
      ),
      Doctor(
        id: '9',
        name: 'Dr. Gabriela Rocha',
        specialty: 'Oftalmologia',
        workplace: Workplace(
          id: '9',
          name: 'Clínica dos Olhos',
          address: 'Av. Visão, 606',
          phoneNumber: '91 98765-4321',
          whatsappNumber: '91 98765-4321',
        ),
      ),
      Doctor(
        id: '10',
        name: 'Dr. Thiago Fernandes',
        specialty: 'Urologia',
        workplace: Workplace(
          id: '10',
          name: 'Centro Urológico',
          address: 'Rua Saúde Masculina, 707',
          phoneNumber: '51 91234-5678',
          whatsappNumber: '51 91234-5678',
        ),
      ),
    ];

    _doctors.addAll(mockData);
    notifyListeners();
  }

}
