import 'package:flutter/material.dart';
import 'package:projeto_mobile/model/appointmentModel.dart';
import 'package:provider/provider.dart';
import 'package:projeto_mobile/provider/appointment/AppointmentProvider.dart';
import 'package:projeto_mobile/view/appointment/widgets/list/checkups/CheckupCard.dart';

class CheckupList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppointmentProvider>(
      builder: (context, appointmentProvider, child) {
        var appointments = List<AppointmentModel>.from(appointmentProvider.appointments);

        if (appointments.isEmpty) {
          return Center(
            child: Text('Nenhuma consulta encontrada'),
          );
        }

        // Ordena os agendamentos pela data
        appointments.sort((a, b) {
          if (a.date == null && b.date == null) return 0;
          if (a.date == null) return 1;
          if (b.date == null) return -1;
          return a.date!.compareTo(b.date!);
        });

        // Limita a exibição a 5 agendamentos
        final limitedAppointments = appointments.take(5).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Próximas Consultas',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Adicione funcionalidade para ver todos os check-ups
                    },
                    child: Text('Ver todos'),
                  ),
                ],
              ),
            ),
            Container(
              height: 250,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: limitedAppointments.length,
                itemBuilder: (context, index) {
                  final appointment = limitedAppointments[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CheckupCard(
                      date: '${appointment.date?.day}/${appointment.date?.month}/${appointment.date?.year} ${appointment.time?.format(context)}',
                      specialty: appointment.specialty,
                      doctor: appointment.doctorName,
                      address: appointment.location,
                      isVideo: false, // Defina conforme necessário
                      doctorImage: 'assets/doctor_mock.png', // Substitua conforme necessário
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
