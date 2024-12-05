// ignore_for_file: public_member_api_docs, sort_constructors_first
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
  int medicationUnits;
  DateTime addDate = DateTime.now();
  String? action;
  String dueDate;
  List<String> daysOfWeek;
  List<String> medicationTime;
  String? additionalInfo;
  MedicationModel({
    String? id,
    String? action,
    required this.isActive,
    required this.imageURL,
    required this.userName,
    required this.medicationName,
    required this.adminRoute,
    required this.howToUse,
    required this.usageRange,
    required this.dosage,
    required this.usageTimes,
    required this.medicationUnits,
    required this.dueDate,
    required this.daysOfWeek,
    required this.medicationTime,
    required this.additionalInfo,
  }): id = id ?? const Uuid().v4();

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
      medicationUnits: medicationUnits ?? this.medicationUnits,
      action: action ?? this.action,
      dueDate: dueDate ?? this.dueDate,
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
      medicationUnits: medicationUnits,
      dueDate: dueDate,
      daysOfWeek: List.from(daysOfWeek), // Cria uma nova lista
      medicationTime: List.from(medicationTime), // Cria uma nova lista
      additionalInfo: additionalInfo,
      imageURL: imageURL,
      action: action,
    );
  }
}
