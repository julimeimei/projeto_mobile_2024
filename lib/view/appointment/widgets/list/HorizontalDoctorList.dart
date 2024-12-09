import 'package:flutter/material.dart';
import 'package:projeto_mobile/view/appointment/DockerDetailScreen.dart';
import 'package:provider/provider.dart';
import 'package:projeto_mobile/provider/appointment/Doctor.provider.dart';
import 'package:projeto_mobile/model/Doctor.model.dart';

class HorizontalDoctorList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final doctorProvider = Provider.of<DoctorProvider>(context);
    final doctors = doctorProvider.doctors;

    return Container(
      height: 150, // Ajuste a altura conforme necessário
      child: doctors.isNotEmpty
          ? ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          final doctor = doctors[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DoctorDetailScreen(doctor: doctor),
                ),
              );
            },
            child: Container(
              width: 120, // Ajuste a largura conforme necessário
              margin: EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/images/doctor.png'), // Substitua pelo caminho real da imagem do médico
                  ),
                  SizedBox(height: 8),
                  Text(
                    doctor.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    doctor.specialty,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      )
          : Center(
        child: Text(
          'Nenhum médico encontrado',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }
}
