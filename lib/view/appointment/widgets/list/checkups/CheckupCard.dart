import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Certifique-se de adicionar esta dependência ao seu pubspec.yaml

class CheckupCard extends StatelessWidget {
  final String date;
  final String specialty;
  final String doctor;
  final String address;
  final bool isVideo;
  final String doctorImage;

  CheckupCard({
    required this.date,
    required this.specialty,
    required this.doctor,
    required this.address,
    required this.isVideo,
    required this.doctorImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                date,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(doctorImage),
                  ),
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isVideo ? 'Consulta por Vídeo' : 'Consulta na Clínica',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        doctor,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        address,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                specialty,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.phone, color: Colors.green),
                    onPressed: () {
                      // Adicione funcionalidade de chamada
                    },
                  ),
                  SizedBox(width: 8),
                  IconButton(
                    icon: FaIcon(FontAwesomeIcons.whatsapp, color: Colors.green),
                    onPressed: () {
                      // Adicione funcionalidade de mensagem via WhatsApp
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
