// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:uuid/uuid.dart';

class MedicationModel {
  String id;
  bool isActive;
  String imageURL;
  String userName;
  String medicationName;
  String adminRoute;
  String howToUse;
  int usageRange;
  int dosage;
  int usageTimes;
  //int medicationUnits;
  DateTime addDate = DateTime.now();
  String? action;
  //String dueDate;
  List<String> daysOfWeek;
  List<String> medicationTime;
  String? additionalInfo;
  MedicationModel({
    String? id,
    //String? action,
    required this.action,
    DateTime? addDate,
    required this.isActive,
    required this.imageURL,
    required this.userName,
    required this.medicationName,
    required this.adminRoute,
    required this.howToUse,
    required this.usageRange,
    required this.dosage,
    required this.usageTimes,
    //required this.medicationUnits,
    //required this.dueDate,
    required this.daysOfWeek,
    required this.medicationTime,
    required this.additionalInfo,
  }): id = id ?? const Uuid().v4(), addDate = addDate ?? DateTime.now();

  MedicationModel copyWith({
    String? id,
    bool? isActive,
    String? imageURL,
    String? userName,
    String? medicationName,
    String? adminRoute,
    String? howToUse,
    int? usageRange,
    int? dosage,
    int? usageTimes,
    int? medicationUnits,
    String? action,
    String? dueDate,
    List<String>? daysOfWeek,
    List<String>? medicationTime,
    String? additionalInfo,
  }) {
    return MedicationModel(
      id: id ?? this.id,
      isActive: isActive ?? this.isActive,
      imageURL: imageURL ?? this.imageURL,
      userName: userName ?? this.userName,
      medicationName: medicationName ?? this.medicationName,
      adminRoute: adminRoute ?? this.adminRoute,
      howToUse: howToUse ?? this.howToUse,
      usageRange: usageRange ?? this.usageRange,
      dosage: dosage ?? this.dosage,
      usageTimes: usageTimes ?? this.usageTimes,
      //medicationUnits: medicationUnits ?? this.medicationUnits,
      action: action ?? this.action,
      //dueDate: dueDate ?? this.dueDate,
      daysOfWeek: daysOfWeek ?? this.daysOfWeek,
      medicationTime: medicationTime ?? this.medicationTime,
      additionalInfo: additionalInfo ?? this.additionalInfo,
    );
  }

  // Método de cópia
  MedicationModel copy() {
    return MedicationModel(
      id: id,
      isActive: isActive,
      userName: userName,
      medicationName: medicationName,
      adminRoute: adminRoute,
      howToUse: howToUse,
      dosage: dosage,
      usageTimes: usageTimes,
      usageRange: usageRange,
      //medicationUnits: medicationUnits,
      //dueDate: dueDate,
      daysOfWeek: List.from(daysOfWeek), // Cria uma nova lista
      medicationTime: List.from(medicationTime), // Cria uma nova lista
      additionalInfo: additionalInfo,
      imageURL: imageURL,
      action: action,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'isActive': isActive,
      'imageURL': imageURL,
      'userName': userName,
      'medicationName': medicationName,
      'adminRoute': adminRoute,
      'howToUse': howToUse,
      'usageRange': usageRange,
      'dosage': dosage,
      'usageTimes': usageTimes,
      //'medicationUnits': medicationUnits,
      'action': action,
      //'dueDate': dueDate,
      'daysOfWeek': daysOfWeek,
      'medicationTime': medicationTime,
      'additionalInfo': additionalInfo,
      'addDate': addDate.toIso8601String(),
    };
  }

  factory MedicationModel.fromMap(Map<String, dynamic> map) {
  return MedicationModel(
    id: map['id']?.toString() ?? const Uuid().v4(),
    isActive: map['isActive'] as bool? ?? false,
    imageURL: map['imageURL']?.toString() ?? '',
    userName: map['userName']?.toString() ?? '',
    medicationName: map['medicationName']?.toString() ?? '',
    adminRoute: map['adminRoute']?.toString() ?? '',
    howToUse: map['howToUse']?.toString() ?? '',
    usageRange: (map['usageRange'] as num?)?.toInt() ?? 0,
    dosage: (map['dosage'] as num?)?.toInt() ?? 0,
    usageTimes: (map['usageTimes'] as num?)?.toInt() ?? 0,
    //medicationUnits: (map['medicationUnits'] as num?)?.toInt() ?? 0,
    action: map['action']?.toString() ?? 'Indefinido', // Adicionado com valor padrão
    //dueDate: map['dueDate']?.toString() ?? '',
    daysOfWeek: map['daysOfWeek'] != null 
        ? List<String>.from(map['daysOfWeek'])
        : [],
    medicationTime: map['medicationTime'] != null 
        ? List<String>.from(map['medicationTime'])
        : [],
    additionalInfo: map['additionalInfo']?.toString(),
    addDate: map['addDate'] != null 
        ? DateTime.tryParse(map['addDate'].toString()) ?? DateTime.now()
        : DateTime.now(),
  );
}

  String toJson() => json.encode(toMap());

  factory MedicationModel.fromJson(String source) => MedicationModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
