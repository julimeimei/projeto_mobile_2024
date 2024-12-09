import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projeto_mobile/view/appointment/widgets/list/recentvisits/RecentVisitCard.dart';

class RecentVisitsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<RecentVisitCard> visits = [
      RecentVisitCard(
        name: 'Dr. Weber',
        experience: '5 anos de experiência',
        rating: 5.0,
        reviews: 3988,
        specialty: 'Neurologista',
        imagePath: 'assets/doctor_mock.png',
      ),
      RecentVisitCard(
        name: 'Dr. Smith',
        experience: '10 anos de experiência',
        rating: 4.8,
        reviews: 2500,
        specialty: 'Cardiologista',
        imagePath: 'assets/doctor_mock.png',
      ),
      // Adicione mais cartões de visita aqui
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Visitas Recentes',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Adicione funcionalidade para ver todas as visitas
                },
                child: Text('Ver todas'),
              ),
            ],
          ),
        ),
        Container(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: visits.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: visits[index],
              );
            },
          ),
        ),
      ],
    );
  }
}