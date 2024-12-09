import 'package:flutter/material.dart';

class AppointmentModel {
  final String patientName;
  final String specialty;
  final String doctorName;
  final String location;
  final DateTime? date;
  final TimeOfDay? time;
  final String additionalInfo;

  AppointmentModel({
    required this.patientName,
    required this.specialty,
    required this.doctorName,
    required this.location,
    this.date,
    this.time,
    this.additionalInfo = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'patientName': patientName,
      'specialty': specialty,
      'doctorName': doctorName,
      'location': location,
      'date': date?.toIso8601String(),
      'time': time != null ? {'hour': time!.hour, 'minute': time!.minute} : null,
      'additionalInfo': additionalInfo,
    };
  }

  factory AppointmentModel.fromMap(Map<String, dynamic> map) {
    return AppointmentModel(
      patientName: map['patientName'] ?? '',
      specialty: map['specialty'] ?? '',
      doctorName: map['doctorName'] ?? '',
      location: map['location'] ?? '',
      date: map['date'] != null ? DateTime.parse(map['date']) : null,
      time: map['time'] != null
          ? TimeOfDay(hour: map['time']['hour'], minute: map['time']['minute'])
          : null,
      additionalInfo: map['additionalInfo'] ?? '',
    );
  }
}