import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projeto_mobile/model/medicationModel.dart';
import 'package:projeto_mobile/model/userModel.dart';
import 'package:projeto_mobile/provider/medicationProvider.dart';
import 'package:projeto_mobile/services/authService.dart';
import 'package:projeto_mobile/services/profileService.dart';
import 'package:projeto_mobile/view/appointment/appointmentScreen.dart';
import 'package:projeto_mobile/view/authScreens/loginScreen.dart';
import 'package:projeto_mobile/view/historyScreen.dart';
import 'package:projeto_mobile/view/medicationScreen.dart';
import 'package:projeto_mobile/view/taskScreen.dart';
import 'package:projeto_mobile/view/user/EditUserScreen.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MainScreen extends StatefulWidget {
  MedicationModel? medication;
  MainScreen({this.medication, super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<MedicationModel> medications = [];
  List<MedicationModel> medicationHistory = [];

  void addMedicationToHistory(MedicationModel medication) {
    setState(() {
      medicationHistory.add(medication);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            FutureBuilder<UserModel>(
              future: ProfileService.fetchUserData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Center(
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return const Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Text(
                      'Erro',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                } else {
                  String userName = snapshot.data!.userName.toString();
                  return Row(
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis),
                      ),
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.arrow_drop_down,
                            size: 35, color: Colors.white),
                        onSelected: (value) {
                          if (value == 'logout') {
                            AuthServices.signOut();
                            for(var medication in context.read<MedicationProvider>().medications){
                              cancelMedicationAlarms(medication);
                            }
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()),
                                (route) => false);
                          }
                        },
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: 'logout',
                            child: Row(
                              children: [
                                Icon(Icons.exit_to_app, color: Colors.black),
                                SizedBox(width: 8),
                                Text('Sair'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }
              },
            ),
          ],
          backgroundColor: Colors.blue[400],
          // title: Image.asset(
          //   'images/remanegy-high-resolution-logo-transparent-black.png',
          //   height: 30,
          // ),
          title: Text(
            'Remanegy', 
            style: GoogleFonts.baumans(
              textStyle: const TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
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
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Image.asset(
                  'images/remanegy-high-resolution-logo-transparent.png',
                  height: 30,
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
                      builder: (context) =>
                          HistoryScreen(medicationHistory: medicationHistory),
                    ),
                  );
                },
              ),
              // Adicionar opção de editar usuário
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Editar Usuário'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditUserScreen(),
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
              // medications: medications,
              // onMedicationAdded: (medication) {
              //   setState(() {
              //     medications.add(medication);
              //   });
              //   addMedicationToHistory(medication);
              // },
            ),
            AppointmentScreen(),
            TaskScreen(),
          ],
        ),
      ),
    );
  }
}
