import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto_mobile/services/imageService.dart';
import 'package:sizer/sizer.dart';

class AddMedicationScreen extends StatefulWidget {
  const AddMedicationScreen({super.key});

  @override
  State<AddMedicationScreen> createState() => _AddMedicationScreenState();
}

class _AddMedicationScreenState extends State<AddMedicationScreen> {
  DateTime? selectedDate;
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  final TextEditingController _dateController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      helpText: 'Qual a data de vencimento?',
      cancelText: 'Cancelar',
      confirmText: 'OK',
      fieldHintText: 'Dia/Mês/Ano',
      fieldLabelText: 'Data',
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        _dateController.text = dateFormat.format(selectedDate!);
        dueDate = dateFormat.format(selectedDate!);
      });
    }
  }

  List<bool> selectedDays = List.filled(7, false);

  final List<String> weekDays = ['D', 'S', 'T', 'Q', 'Q', 'S', 'S'];
  final List<String> fullWeekDays = [
    'Domingo',
    'Segunda',
    'Terça',
    'Quarta',
    'Quinta',
    'Sexta',
    'Sábado'
  ];

  String getSelectedDaysText() {
    return selectedWeekDays.length == 7
        ? 'Todos os dias'
        : selectedWeekDays.isEmpty
            ? 'Selecione os dias'
            : 'A cada ${selectedWeekDays.join(', ')}';
  }

  void _toggleDay(int index) {
    setState(() {
      selectedDays[index] = !selectedDays[index];
      String dayName = fullWeekDays[index].substring(0, 3); // Nome abreviado

      if (selectedDays[index]) {
        selectedWeekDays.add(dayName); // Adiciona o dia selecionado
      } else {
        selectedWeekDays.remove(dayName); // Remove o dia desmarcado
      }
    });
  }

  File? _image;
  String? imageUrl;
  final _userNameController = TextEditingController();
  final _medicationNameController = TextEditingController();
  String? adminRoute;
  String? howToUse;
  final _usageRangeController = TextEditingController();
  final _medicationUnitsController = TextEditingController();
  String? dueDate;
  List<String> selectedWeekDays = [];
  List<TimeOfDay> medicationTime = [];
  bool isActive = true;
  String additionalInfo = '';

  final List<String> adminRouteList = [
    'Oral = Comprimido, xarope, gotas',
    'Tópico = Pomada, creme',
    'Injetável = Ampola intramuscular, Ampola intravenosa, Ampola subcutânea',
    'Nasal = Spray, gotas',
    'Inalatório = Bombinha, nebulização',
    'Ocular = Colírio',
    'Otológico = Gotas',
    'Retal = Supositório'
  ];

  final List<String> howToUseList = [
    'Comprimidos',
    'Ml (mililitros)',
    'Ampolas'
  ];

  void selectAdminRoute(value) {
    setState(() {
      adminRoute = value;
    });
  }

  void selectHowToUse(value) {
    setState(() {
      howToUse = value;
    });
  }

  Future<void> _selectImage() async {
    imageUrl = await ImageService.pickImageAndSaveLocally();
    if (imageUrl != null) {
      setState(() {
        _image = File(imageUrl!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 244, 244, 244),
        leading: Icon(Icons.arrow_back),
        title: const Text(
          'Adicionando novo medicamento',
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
      ),
      backgroundColor: Color.fromARGB(255, 244, 244, 244),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 100,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: _image != null ? FileImage(_image!) : null,
                    child: _image == null
                        ? Icon(Icons.person, size: 50, color: Colors.grey[400])
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _selectImage,
                      child: CircleAvatar(
                        radius: 3.h,
                        backgroundColor: Colors.white,
                        child: const Icon(Icons.add, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 4.h,
            ),
            _buildTextField(_userNameController, 'Nome', isUserName: true),
            _buildTextField(_medicationNameController, 'Medicamento',
                isMedicationName: true),
            _buildDropdownList('Via de administração', adminRouteList,
                isAdminRoute: true),
            _buildDropdownList('Como usar?', howToUseList, isHowToUse: true),
            _buildTextField(_usageRangeController, 'Intervalo de uso',
                isNumber: true, isUsageRange: true),
            _buildTextField(
                _medicationUnitsController, 'Unidades do medicamento',
                isNumber: true, isMedicationUnits: true),
            _dataPicker(context),
            _weekDaysPicker(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText,
      {bool isNumber = false,
      bool isUserName = false,
      bool isMedicationName = false,
      bool isUsageRange = false,
      bool isMedicationUnits = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.h),
      child: Column(
        children: [
          TextField(
            controller: controller,
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            decoration: InputDecoration(
              labelText: labelText,
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(
            height: 1.h,
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  isUserName
                      ? 'Para quem é esse medicamento?'
                      : isMedicationName
                          ? 'Qual o nome do medicamento?'
                          : isUsageRange
                              ? 'Quantas vezes no dia você faz o uso desse medicamento?'
                              : isMedicationUnits
                                  ? 'Quantas unidades do medicamento tem no momento?'
                                  : '',
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildDropdownList(String labelText, List<String> itemList,
      {bool isAdminRoute = false, bool isHowToUse = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.h),
      child: Column(
        children: [
          DropdownMenu<String>(
            width: double.infinity,
            label: Text(labelText),
            initialSelection: "Selecione um item da lista",
            onSelected: (String? value) {
              isAdminRoute
                  ? selectAdminRoute(value)
                  : isHowToUse
                      ? selectHowToUse(value)
                      : {};
            },
            dropdownMenuEntries:
                itemList.map<DropdownMenuEntry<String>>((String value) {
              return DropdownMenuEntry<String>(value: value, label: value);
            }).toList(),
          ),
          SizedBox(
            height: 1.h,
          ),
          Row(
            children: [
              Expanded(
                child: Text(isAdminRoute
                    ? 'Qual a via de administração do medicamento?'
                    : isHowToUse
                        ? 'Qual a forma de usar o medicamento?'
                        : ''),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _dataPicker(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            controller: _dateController,
            decoration: const InputDecoration(
              labelText: 'Qual a data de vencimento?',
              hintText: 'Dia/Mês/Ano',
              suffixIcon: Icon(Icons.calendar_today),
              border: OutlineInputBorder(),
            ),
            readOnly: true,
            onTap: () => _selectDate(context),
          ),
        ],
      ),
    );
  }

  Widget _weekDaysPicker(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            elevation: 20,
            color: Colors.grey[400],
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  Text('Quais são os dias de se usar o medicamento?'),
                  SizedBox(
                    height: 2.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          getSelectedDaysText(),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Icon(Icons.calendar_month),
                    ],
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(7, (index) {
                      return GestureDetector(
                        onTap: () => _toggleDay(index),
                        child: CircleAvatar(
                          backgroundColor: selectedDays[index]
                              ? Colors.purple
                              : Colors.grey[200],
                          child: Text(
                            weekDays[index],
                            style: TextStyle(
                              color: selectedDays[index]
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
