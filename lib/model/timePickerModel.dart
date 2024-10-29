import 'package:flutter/material.dart';

class TimePickerModel {
  TextEditingController hourController;
  TextEditingController minuteController;

  TimePickerModel() 
      : hourController = TextEditingController(), 
        minuteController = TextEditingController();
}
