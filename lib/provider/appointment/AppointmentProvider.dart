import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:projeto_mobile/model/appointmentModel.dart';

class AppointmentProvider with ChangeNotifier {
  final List<AppointmentModel> _appointments = [];
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref('Users');

  List<AppointmentModel> get appointments => List.unmodifiable(_appointments);

  AppointmentProvider() {
    fetchAppointments();
  }

  Future<void> addAppointment(AppointmentModel appointment) async {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        final newRef = _dbRef.child('$userId/Appointments').push();
        await newRef.set(appointment.toMap());
        _appointments.add(appointment);
        notifyListeners();
      } else {
        debugPrint('Usuário não autenticado');
      }
    } catch (error) {
      debugPrint('Erro ao adicionar agendamento: $error');
    }
  }

  Future<void> fetchAppointments() async {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        final snapshot = await _dbRef.child('$userId/Appointments').get();
        if (!snapshot.exists || snapshot.value == null) {
          debugPrint('Nenhum agendamento encontrado ou dados nulos');
          _appointments.clear();
          notifyListeners();
          return;
        }

        _appointments.clear();

        if (snapshot.value is Map) {
          final Map<dynamic, dynamic> appointmentsMap = snapshot.value as Map<dynamic, dynamic>;

          appointmentsMap.forEach((key, value) {
            if (value != null && value is Map) {
              try {
                final appointmentData = Map<String, dynamic>.from(value);
                final appointment = AppointmentModel.fromMap(appointmentData);
                _appointments.add(appointment);
              } catch (e) {
                debugPrint('Erro ao processar agendamento: $e');
              }
            }
          });
        }

        notifyListeners();
      } else {
        debugPrint('Usuário não autenticado');
      }
    } catch (error) {
      debugPrint('Erro ao buscar agendamentos: $error');
      _appointments.clear();
      notifyListeners();
    }
  }
}
