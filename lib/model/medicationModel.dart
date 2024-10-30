// ignore_for_file: public_member_api_docs, sort_constructors_first
class MedicationModel {
  
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
  String dueDate;
  List<String>daysOfWeek;
  List<String> medicationTime;
  String? additionalInfo;
  MedicationModel({
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
  });

}
