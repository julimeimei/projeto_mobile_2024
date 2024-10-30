import 'package:flutter/material.dart';
import 'package:projeto_mobile/model/medicationModel.dart';
import 'package:projeto_mobile/model/appointmentModel.dart';
import 'package:projeto_mobile/view/appointment/appointmentScreen.dart';
import 'package:projeto_mobile/view/historyScreen.dart';
import 'package:projeto_mobile/view/medicationScreen.dart';
import 'package:projeto_mobile/view/taskScreen.dart';

class MainScreen extends StatefulWidget {
  MedicationModel? medication;
  MainScreen({this.medication, super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<MedicationModel> medications = [];
  List<MedicationModel> medicationHistory = []; // Lista de histórico
  List<AppointmentModel> appointments = [];

  void addMedicationToHistory(MedicationModel medication) {
    setState(() {
      medicationHistory.add(medication); // Adiciona ao histórico
    });
  }

  void addAppointment(AppointmentModel appointment) {
    setState(() {
      appointments.add(appointment);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[400],
          title: const Text('Remanegy'),
          centerTitle: true,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.black,
            tabs: [
              Tab(
                icon: Icon(Icons.medication_outlined),
                text: "Medicamentos",
              ),
              Tab(
                icon: Icon(Icons.paste_outlined),
                text: "Consultas",
              ),
              Tab(
                icon: Icon(Icons.device_thermostat_outlined),
                text: "Tarefas",
              ),
            ],
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text(
                  'Remanegy',
                  style: TextStyle(fontSize: 30, color: Colors.black),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Tela inicial'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Configurações'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.history),
                title: const Text('Histórico'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HistoryScreen(medicationHistory: medicationHistory),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            MedicationScreen(
              medications: medications,
              onMedicationAdded: (medication) {
                setState(() {
                  medications.add(medication);
                });
                addMedicationToHistory(medication);
              },
            ),
            AppointmentScreen(
              appointments: appointments,
              onAppointmentAdded: addAppointment,
            ),
            TaskScreen(),
          ],
        ),
      ),
    );
  }
}
