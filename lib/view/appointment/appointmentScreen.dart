import 'package:flutter/material.dart';
import 'package:projeto_mobile/provider/appointment/AppointmentProvider.dart';
import 'package:projeto_mobile/view/appointment/widgets/list/HorizontalDoctorList.dart';
import 'package:projeto_mobile/view/appointment/widgets/list/checkups/CheckupList.dart';
import 'package:projeto_mobile/view/appointment/widgets/list/recentvisits/RecentVisitCard.dart';
import 'package:projeto_mobile/view/appointment/widgets/list/recentvisits/RecentVisitsList.dart';
import 'package:projeto_mobile/view/appointment/widgets/search/MeetADoctor.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:projeto_mobile/model/appointmentModel.dart';

class AppointmentScreen extends StatelessWidget {
  const AppointmentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            MeetADoctor(),
            RecentVisitsList(),
            SizedBox(height: 10),
            CheckupList(),
          ],
        ),
      ),
    );
  }
}
