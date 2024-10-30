import 'package:flutter/material.dart';
import 'package:projeto_mobile/view/appointment/widgets/dialogs/add_medical_check_dialog.dart';
import 'package:projeto_mobile/view/appointment/widgets/tables/AppointmentTable.dart';
import 'package:sizer/sizer.dart';
import 'package:projeto_mobile/model/appointmentModel.dart';

class AppointmentScreen extends StatelessWidget {
  final List<AppointmentModel> appointments; // Lista de consultas
  final Function(AppointmentModel) onAppointmentAdded;

  const AppointmentScreen({
    Key? key,
    required this.appointments,
    required this.onAppointmentAdded,
  }) : super(key: key);

  void _showAddMedicalCheckDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddMedicalCheckDialog(
          onAppointmentAdded: (appointment) {
            onAppointmentAdded(appointment);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              SizedBox(height: 10.h),
              SizedBox(width: 2.w),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => _showAddMedicalCheckDialog(context),
                child: Icon(
                  Icons.add_circle_outline_outlined,
                  color: Colors.blueAccent[400],
                  size: 25,
                ),
              ),
              SizedBox(width: 2.w),
              Text(
                'Adicionar nova consulta',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          SizedBox(height: 10), // Espaçamento entre o botão e a lista
          Expanded(
            child: AppointmentTable(
              appointments: appointments,
              parentContext: context,
            ),
          ),
        ],
      ),
    );
  }
}
