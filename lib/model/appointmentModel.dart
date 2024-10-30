import 'package:flutter/material.dart';

class AppointmentModel {
  final String doctorName;
  final String location;
  final DateTime? date;
  final TimeOfDay? time;

  AppointmentModel({
    required this.doctorName,
    required this.location,
    this.date,
    this.time,
  });
}
