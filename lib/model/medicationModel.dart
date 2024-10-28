// ignore_for_file: public_member_api_docs, sort_constructors_first
class MedicationModel {
  
  bool isActive;
  String? imageURL;
  String? userName;
  String? medicationName;
  String? adminRoute;
  String? howToUse;
  int? usageRange;
  int? medicationUnits;
  String? dueDate;
  List<String>? daysOfWeek;
  List<DateTime>? medicationTime;
  String additionalInfo = "";
  MedicationModel({
    required this.isActive,
    this.imageURL,
    this.userName,
    this.medicationName,
    this.adminRoute,
    this.howToUse,
    this.usageRange,
    this.medicationUnits,
    this.dueDate,
    this.daysOfWeek,
    this.medicationTime,
    required this.additionalInfo,
  });

}
