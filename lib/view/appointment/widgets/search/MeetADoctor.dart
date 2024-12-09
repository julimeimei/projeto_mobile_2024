import 'package:flutter/material.dart';
import 'package:projeto_mobile/view/appointment/DockerDetailScreen.dart';
import 'package:provider/provider.dart';
import 'package:projeto_mobile/provider/appointment/Doctor.provider.dart';
import 'package:projeto_mobile/model/Doctor.model.dart';

class MeetADoctor extends StatefulWidget {
  @override
  _MeetADoctorState createState() => _MeetADoctorState();
}

class _MeetADoctorState extends State<MeetADoctor> {
  String query = '';
  List<Doctor> searchResults = [];

  void searchDoctor(String query) {
    final doctorProvider = Provider.of<DoctorProvider>(context, listen: false);
    final doctors = doctorProvider.doctors;
    final results = doctors.where((doctor) {
      final nameLower = doctor.name.toLowerCase();
      final specialtyLower = doctor.specialty.toLowerCase();
      final queryLower = query.toLowerCase();

      return nameLower.contains(queryLower) || specialtyLower.contains(queryLower);
    }).toList();

    setState(() {
      this.query = query;
      searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Encontre um Médico',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              TextField(
                onChanged: searchDoctor,
                decoration: InputDecoration(
                  hintText: 'Pesquisar Médico',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
        if (query.isNotEmpty)
          Positioned(
            left: 16,
            right: 16,
            top: 112,
            bottom: 0,
            child: Container(
              color: Colors.white, // cor de fundo para diferenciar
              child: searchResults.isNotEmpty
                  ? ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final doctor = searchResults[index];
                  return ListTile(
                    title: Text(doctor.name),
                    subtitle: Text(doctor.specialty),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DoctorDetailScreen(doctor: doctor),
                        ),
                      );
                    },
                  );
                },
              )
                  : Center(
                child: Text(
                  'Nenhum médico encontrado',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
