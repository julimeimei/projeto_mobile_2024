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
}
