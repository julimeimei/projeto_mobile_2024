import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RecentVisitCard extends StatelessWidget {
  final String name;
  final String experience;
  final double rating;
  final int reviews;
  final String specialty;
  final String imagePath;

  RecentVisitCard({
    required this.name,
    required this.experience,
    required this.rating,
    required this.reviews,
    required this.specialty,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      // Adjust width to fit the content without overflow
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Stack(
          children: [
            // Imagem de fundo no canto
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  bottomLeft: Radius.circular(15.0),
                ),
                child: Image.asset(
                  imagePath,
                  width: 100, // Ajuste a largura da imagem conforme necessário
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Conteúdo sobreposto
            Padding(
              padding: const EdgeInsets.only(
                  left: 120.0, top: 16.0, right: 16.0, bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      shadows: [
                        Shadow(
                          offset: Offset(1.0, 1.0),
                          blurRadius: 2.0,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    experience,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  Row(
                    children: [
                      ...List.generate(
                        5,
                            (index) => Icon(
                          index < rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 16,
                        ),
                      ),
                      SizedBox(width: 4),
                      Text(
                        '$rating ($reviews)',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    specialty,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blueAccent,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.phone, color: Colors.blueAccent),
                        onPressed: () {
                          // Adicione funcionalidade de chamada
                        },
                      ),
                      IconButton(
                        icon: FaIcon(FontAwesomeIcons.whatsapp, color: Colors.blueAccent),
                        onPressed: () {
                          // Adicione funcionalidade de mensagem via WhatsApp
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}