import 'package:projeto_mobile/model/Workplace.model.dart';

class Doctor {
  final String id;
  final String name;
  final String specialty;
  final Workplace workplace;

  Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.workplace,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'specialty': specialty,
      'workplace': workplace.toMap(),
    };
  }

  factory Doctor.fromMap(Map<String, dynamic> map) {
    return Doctor(
      id: map['id'],
      name: map['name'],
      specialty: map['specialty'],
      workplace: Workplace.fromMap(map['workplace']),
    );
  }
}