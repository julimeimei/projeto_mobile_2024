import 'package:flutter/material.dart';
import 'package:projeto_mobile/appointmentScreen.dart';
import 'package:projeto_mobile/medicationScreen.dart';
import 'package:projeto_mobile/taskScreen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Remanegy (temporario)'),
            centerTitle: true,
            bottom: TabBar(
                indicatorColor: Colors.blueAccent[400],
                labelColor: Colors.blueAccent[400],
                unselectedLabelColor: Colors.black,
                tabs: [
                  Tab(
                    icon: Icon(
                      Icons.medication_outlined,
                    ),
                    text: "Remédios",
                  ),
                  Tab(
                    icon: Icon(
                      Icons.paste_outlined,
                    ),
                    text: "Consultas",
                  ),
                  Tab(
                    icon: Icon(
                      Icons.device_thermostat_outlined,
                    ),
                    text: "Tarefas",
                  )
                ]),
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Text('Remanegy'),
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
              ],
            ),
          ),
          body: const TabBarView(
            children: [MedicationScreen(), AppointmentScreen(), TaskScreen()],
          ),
        ));
  }
}
