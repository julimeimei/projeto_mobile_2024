import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto_mobile/model/medicationModel.dart';
import 'package:projeto_mobile/model/timePickerModel.dart';
import 'package:projeto_mobile/services/imageService.dart';
import 'package:projeto_mobile/view/mainScreen.dart';
import 'package:sizer/sizer.dart';

class EditMedicationScreen extends StatefulWidget {
  MedicationModel medicationToEdit;
  EditMedicationScreen({required this.medicationToEdit, super.key});

  @override
  State<EditMedicationScreen> createState() => _EditMedicationScreenState();
}

class _EditMedicationScreenState extends State<EditMedicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _hourController = TextEditingController();
  final TextEditingController _minuteController = TextEditingController();

  List<TimePickerModel> _timePickers = [];

  @override
  void initState() {
    super.initState();
    _timePickers.add(TimePickerModel());
    _usageRangeController.addListener(_updateTimePickerReadOnly);
    _usageTimesController.addListener(_updateTimePickerReadOnly);
    _image = File(widget.medicationToEdit.imageURL);
    _dateController =
        TextEditingController(text: widget.medicationToEdit.dueDate);
    _userNameController =
        TextEditingController(text: widget.medicationToEdit.userName);
    _medicationNameController =
        TextEditingController(text: widget.medicationToEdit.medicationName);
    _adminRouteController =
        TextEditingController(text: widget.medicationToEdit.adminRoute);
    _howToUseController =
        TextEditingController(text: widget.medicationToEdit.howToUse);
    _usageRangeController = TextEditingController(
        text: widget.medicationToEdit.usageRange.toString());
    _dosageController =
        TextEditingController(text: widget.medicationToEdit.dosage.toString());
    _medicationUnitsController = TextEditingController(
        text: widget.medicationToEdit.medicationUnits.toString());
    _additionalInfoController =
        TextEditingController(text: widget.medicationToEdit.additionalInfo);
  }

  @override
  void dispose() {
    _usageRangeController.dispose();
    // Dispose de todos os controladores de timePickers
    for (var picker in _timePickers) {
      picker.hourController.dispose();
      picker.minuteController.dispose();
    }
    _dateController.dispose();
    _hourController.dispose();
    _dosageController.dispose();
    _minuteController.dispose();
    _howToUseController.dispose();
    _userNameController.dispose();
    _adminRouteController.dispose();
    _usageTimesController.dispose();
    _additionalInfoController.dispose();
    _medicationNameController.dispose();
    _medicationUnitsController.dispose();
    super.dispose();
  }

  void _updateTimePickerReadOnly() {
    setState(() {
      // Apenas chama `setState` para garantir a atualização imediata da UI
    });
  }

  List<String> getMedicationTimes() {
    List<String> medicationTimes = [];
    for (int i = 0; i < _timePickers.length; i++) {
      medicationTimes.add(
          '${_timePickers[i].hourController.text}:${_timePickers[i].minuteController.text}');
    }
    return medicationTimes;
  }

  void _onUsageChanged(String value) {
    int? count = int.tryParse(value);
    if (count != null && count > 0) {
      setState(() {
        _updateTimePickers(count); // Atualiza a lista com o novo valor
      });
    } else {
      setState(() {
        _updateTimePickers(1); // Default para 1
      });
    }
  }

  void _updateTimePickers([int count = 1]) {
    // Garante que a lista tenha o tamanho correto
    if (_timePickers.length < count) {
      _timePickers.addAll(
        List.generate(count - _timePickers.length, (_) => TimePickerModel()),
      );
    } else if (_timePickers.length > count) {
      _timePickers.removeRange(count, _timePickers.length);
    }
  }

  String get formattedTime {
    final hour = _hourController.text.padLeft(2, '0');
    final minute = _minuteController.text.padLeft(2, '0');
    return "$hour:$minute";
  }

  void _validateAndSetHour(String value, int index) {
    final hour = int.tryParse(value);
    if (hour == null || hour < 0 || hour > 23) {
      _timePickers[index].hourController.text = '00'; // Valor padrão
    }
  }

  void _onHourInputChanged(String value, int index) {
    _validateAndSetHour(value, index);
    if (value.length > 2) {
      // Se o comprimento excede 2, substitua o último caractere
      _timePickers[index].hourController.text = value.substring(1);
      _timePickers[index].hourController.selection = TextSelection.fromPosition(
        TextPosition(offset: _timePickers[index].hourController.text.length),
      );
      _validateAndSetHour(value, index);
    }
  }

  void _validateAndSetMinute(String value, int index) {
    final minute = int.tryParse(value);
    if (minute == null || minute < 0 || minute > 59) {
      _timePickers[index].minuteController.text = '00'; // Valor padrão
    }
  }

  void _onMinuteInputChanged(String value, int index) {
    _validateAndSetMinute(value, index);
    if (value.length > 2) {
      // Se o comprimento excede 2, substitua o último caractere
      _timePickers[index].minuteController.text = value.substring(1);
      _timePickers[index].minuteController.selection =
          TextSelection.fromPosition(
        TextPosition(offset: _timePickers[index].minuteController.text.length),
      );
      _validateAndSetMinute(value, index);
    }
  }

  void _calculateMedicationHours(int interval, int doses, int firstHour) {
    for (int i = 1; i < _timePickers.length; i++) {
      int newHour = (firstHour + (interval * i)) % 24;
      if (i > 0) {
        _timePickers[i].hourController.text = newHour.toString();
      }
    }
  }

  void _calculateMedicationMinutes(int firstMinute) {
    for (int i = 1; i < _timePickers.length; i++) {
      _timePickers[i].minuteController.text = firstMinute.toString();
    }
  }

  DateTime? selectedDate;
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  late TextEditingController _dateController = TextEditingController();

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
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue, // Cor do cabeçalho
              onPrimary: Colors.white, // Cor do texto do cabeçalho
              onSurface: Colors.black, // Cor do texto e dos ícones
            ),
            dialogBackgroundColor: Colors.white, // Cor de fundo do calendário
          ),
          child: child!,
        );
      },
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
  late TextEditingController _userNameController = TextEditingController();
  late TextEditingController _medicationNameController =
      TextEditingController();
  String? adminRoute;
  String? howToUse;
  late TextEditingController _usageRangeController = TextEditingController();

  late TextEditingController _medicationUnitsController =
      TextEditingController();

  late TextEditingController _dosageController = TextEditingController();
  String? dueDate;
  List<String> selectedWeekDays = [];
  List<TimeOfDay> medicationTime = [];
  bool isActive = true;
  late TextEditingController _additionalInfoController =
      TextEditingController();

  late TextEditingController _usageTimesController = TextEditingController();
  late TextEditingController _howToUseController = TextEditingController();
  late TextEditingController _adminRouteController = TextEditingController();

  final List<String> adminRouteList = [
    'Oral',
    'Tópico',
    'Injetável',
    'Nasal',
    'Inalatório',
    'Ocular',
    'Otológico',
    'Retal'
  ];

  final List<String> oralList = ['Comprimido', 'Xarope', 'Gotas'];

  final List<String> topicoList = [
    'Pomada',
    'Creme',
  ];

  final List<String> injetavelList = [
    'Ampola intramuscular',
    'Ampola intravenosa',
    'Ampola subcutânea'
  ];

  final List<String> nasalList = [
    'Spray',
    'Gotas',
  ];

  final List<String> inalatorioList = ['Bombinha', 'Nebulização'];

  final List<String> ocularList = ['Colírio'];

  final List<String> otologicoList = ['Gotas'];

  final List<String> retalList = ['Supositório'];

  void selectAdminRoute(value) {
    setState(() {
      adminRoute = value;
      _howToUseController.clear();
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
        backgroundColor: Colors.blue[400],
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)),
        title: const Text(
          'Editando medicamento',
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
      ),
      backgroundColor: Color.fromARGB(255, 244, 244, 244),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 2.h,
            ),
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
            Form(
              key: _formKey,
              child: Column(children: [
                _buildTextField(
                    _userNameController,
                    'Nome',
                    'Para quem é esse medicamento?',
                    'Por favor, informe para quem é esse medicamento.'),
                _buildTextField(
                    _medicationNameController,
                    'Medicamento',
                    'Qual o nome do medicamento?',
                    'Por favor, informe o nome do medicamento.'),
                _buildDropdownList('Via de administração', adminRouteList,
                    isAdminRoute: true),
                _buildDropdownList(
                    'Como usar?',
                    adminRoute == 'Oral'
                        ? oralList
                        : adminRoute == 'Tópico'
                            ? topicoList
                            : adminRoute == 'Injetável'
                                ? injetavelList
                                : adminRoute == 'Nasal'
                                    ? nasalList
                                    : adminRoute == 'Inalatório'
                                        ? inalatorioList
                                        : adminRoute == 'Ocular'
                                            ? ocularList
                                            : adminRoute == 'Otológico'
                                                ? otologicoList
                                                : adminRoute == 'Retal'
                                                    ? retalList
                                                    : oralList,
                    isHowToUse: true),
                (howToUse != 'Pomada' && howToUse != 'Creme')
                    ? _buildTextField(
                        _dosageController,
                        'Dosagem',
                        howToUse == 'Comprimido'
                            ? 'Quantos comprimidos são usados em cada aplicação do medicamento?'
                            : (howToUse == 'Xarope' ||
                                    howToUse == 'Nebulização')
                                ? 'Quantos ml para cada aplicação do medicamento?'
                                : (howToUse == 'Ampola intramuscular' ||
                                        howToUse == 'Ampola intravenosa' ||
                                        howToUse == 'Ampola subcutânea')
                                    ? 'Quantas ampolas são usadas em cada aplicação do medicamento?'
                                    : howToUse == 'Spray'
                                        ? 'Quantas jatos são usados para cada aplicação do medicamento?'
                                        : howToUse == 'Bombinha'
                                            ? 'Quantos puffs são usados em cada aplicação?'
                                            : howToUse == 'Gotas'
                                                ? 'Quantas gotas são usadas em cada aplicação do medicamento?'
                                                : howToUse == 'Supositório'
                                                    ? 'Quantos supositórios são usados em cada aplicação?'
                                                    : 'Qual a dosagem do medicamento em cada aplicação?',
                        'Por favor, informe a dosagem do medicamento',
                        isNumber: true,
                      )
                    : const SizedBox.shrink(),
                _buildTextField(
                    _usageTimesController,
                    'Vezes ao dia',
                    'Quantas vezes ao dia você faz uso desse medicamento?',
                    'Por favor, informe quantas vezes ao dia você faz uso do medicamento.',
                    isNumber: true,
                    isUsageTimes: true),
                _buildTextField(
                  _usageRangeController,
                  'Intervalo de uso',
                  'De quantas em quantas horas você faz uso do medicamento?',
                  'Por favor, informe o intervado de uso.',
                  isNumber: true,
                ),
                _buildTextField(
                  _medicationUnitsController,
                  'Unidades do medicamento',
                  (howToUse == 'Xarope' ||
                          howToUse == 'Gotas' ||
                          howToUse == 'Nebulização')
                      ? 'Quantos ml do medicamento tem no frasco?'
                      : 'Quantas unidades do medicamento tem no momento',
                  'Por favor, insira algum número no campo.',
                  isNumber: true,
                ),
                _dataPicker(context),
                _weekDaysPicker(context),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.w),
                  child: Column(
                    children: _buildTimePickers(),
                  ),
                ),
                _buildTextField(
                    _additionalInfoController,
                    'Informações adicionais',
                    'Adicione informações adicionais que você achar necessárias.',
                    '',
                    isAdditionalInfo: true),
              ]),
            ),
            SizedBox(
              height: 6.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    label: const Text(
                      'Cancelar',
                      style: TextStyle(color: Colors.white),
                    ),
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size(40.w, 6.h),
                        backgroundColor: Colors.blue[400]),
                  ),
                  SizedBox(
                    width: 4.w,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      _validateAndSubmit();
                      if (selectedWeekDays.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Por favor, selecione os dias da semana.')),
                        );
                      } else {
                        if (_formKey.currentState!.validate() &&
                            adminRoute != null &&
                            howToUse != null) {
                          try {
                            MedicationModel medication = MedicationModel(
                                isActive: true,
                                imageURL: imageUrl!,
                                userName: _userNameController.text,
                                medicationName: _medicationNameController.text,
                                adminRoute: adminRoute!,
                                howToUse: howToUse!,
                                usageRange:
                                    int.tryParse(_usageRangeController.text)!,
                                dosage: int.tryParse(_dosageController.text)!,
                                usageTimes:
                                    int.tryParse(_usageTimesController.text)!,
                                medicationUnits: int.tryParse(
                                    _medicationUnitsController.text)!,
                                dueDate: _dateController.text,
                                daysOfWeek: selectedWeekDays,
                                medicationTime: getMedicationTimes(),
                                additionalInfo: _additionalInfoController.text);
                            _saveChanges(medication);
                          } catch (e) {
                            print("Error: $e");
                          }
                        }
                      }
                    },
                    label: const Text(
                      'Salvar',
                      style: TextStyle(color: Colors.white),
                    ),
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size(40.w, 6.h),
                        backgroundColor: Colors.blue[400]),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _saveChanges(MedicationModel medication) {
    setState(() {
      widget.medicationToEdit.daysOfWeek = medication.daysOfWeek;
      widget.medicationToEdit.medicationTime = medication.medicationTime;
      widget.medicationToEdit.imageURL = medication.imageURL;
      widget.medicationToEdit.medicationName = medication.medicationName;
      widget.medicationToEdit.adminRoute = medication.adminRoute;
      widget.medicationToEdit.howToUse = medication.howToUse;
      widget.medicationToEdit.usageRange = medication.usageRange;
      widget.medicationToEdit.dosage = medication.dosage;
      widget.medicationToEdit.usageTimes = medication.usageTimes;
      widget.medicationToEdit.medicationUnits = medication.medicationUnits;
      widget.medicationToEdit.dueDate = medication.dueDate;
      widget.medicationToEdit.additionalInfo = medication.additionalInfo;
    });
    Navigator.pop(context, widget.medicationToEdit);
  }

  Widget _buildTextField(TextEditingController controller, String labelText,
      String helpText, String errorMessage,
      {bool isNumber = false,
      bool isUsageTimes = false,
      bool isAdditionalInfo = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.w),
      child: Column(
        children: [
          TextFormField(
            cursorColor: Colors.black,
            onChanged: isUsageTimes ? _onUsageChanged : null,
            controller: controller,
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            decoration: InputDecoration(
              labelStyle: TextStyle(color: Colors.black),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue[600]!)),
              labelText: labelText,
              border: OutlineInputBorder(),
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if ((value == null || value.isEmpty) &&
                  isAdditionalInfo == false) {
                return errorMessage;
              }
              return null;
            },
          ),
          SizedBox(
            height: 1.h,
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  helpText,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  String? _adminRouteError;
  String? _howToUseError;
  Widget _buildDropdownList(String labelText, List<String> itemList,
      {bool isAdminRoute = false, bool isHowToUse = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.w),
      child: Column(
        children: [
          DropdownButtonFormField<String>(
            value: isAdminRoute ? adminRoute : howToUse,
            decoration: InputDecoration(
              labelStyle: TextStyle(color: Colors.black),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue[600]!)),
              labelText: labelText,
              border: OutlineInputBorder(),
              errorText: isAdminRoute ? _adminRouteError : _howToUseError,
            ),
            items: itemList.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                if (isAdminRoute) {
                  adminRoute = newValue;
                  _adminRouteError = null;
                } else if (isHowToUse) {
                  howToUse = newValue;
                  _howToUseError = null;
                }
              });
            },
          ),
          SizedBox(
            height: 1.h,
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                    style: TextStyle(fontWeight: FontWeight.bold),
                    isAdminRoute
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

  void _validateAndSubmit() {
    setState(() {
      if (adminRoute == null) {
        _adminRouteError = 'Por favor, selecione uma opção';
      }
      if (howToUse == null) {
        _howToUseError = 'Por favor, selecione uma opção';
      }
    });
  }

  Widget _dataPicker(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            controller: _dateController,
            decoration: InputDecoration(
              labelStyle: TextStyle(
                color: Colors.black,
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue[600]!)),
              labelText: 'Qual a data de vencimento?',
              hintText: 'Dia/Mês/Ano',
              suffixIcon: Icon(Icons.calendar_today),
              border: OutlineInputBorder(),
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira a data de vencimento';
              }
              return null;
            },
            readOnly: true,
            onTap: () => _selectDate(context),
          ),
        ],
      ),
    );
  }

  Widget _weekDaysPicker(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            elevation: 5,
            color: Colors.grey[350],
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.h),
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
                              ? Colors.blue[600]
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

  List<Widget> _buildTimePickers() {
    return _timePickers.map((model) {
      int index = _timePickers.indexOf(model);
      return Card(
        elevation: 5,
        color: Colors.grey[350],
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Qual o horário do remédio?",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 2.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Campo de texto para a hora
                  Column(
                    children: [
                      Text("Horas",
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[600])),
                      SizedBox(
                        width: 25.w,
                        child: TextField(
                          readOnly: (index != 0 ||
                              (index == 0 &&
                                  (_usageRangeController.text.isEmpty ||
                                      _usageTimesController.text.isEmpty))),
                          controller: model.hourController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.blue[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onChanged: (value) {
                            _onHourInputChanged(value, index);
                            _calculateMedicationHours(
                              int.tryParse(_usageRangeController.text)!,
                              int.tryParse(_usageTimesController.text)!,
                              int.tryParse(
                                  _timePickers[0].hourController.text)!,
                            );
                          },
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 6.w),
                  const Text(
                    ":",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 6.w),
                  // Campo de texto para o minuto
                  Column(
                    children: [
                      Text("Minutos",
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[600])),
                      SizedBox(
                        width: 25.w,
                        child: TextField(
                          readOnly: (index != 0 ||
                              (index == 0 &&
                                  (_usageRangeController.text.isEmpty ||
                                      _usageTimesController.text.isEmpty))),
                          controller: model.minuteController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.blue[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onChanged: (value) {
                            _onMinuteInputChanged(value, index);
                            _calculateMedicationMinutes(int.tryParse(
                                _timePickers[0].minuteController.text)!);
                          },
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }).toList();
  }
}
