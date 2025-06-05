import 'package:flutter/material.dart';
import 'package:gaa_adv/controllers/appointment_controller.dart';
import 'package:gaa_adv/views/appointments/appointment_card.dart';
import 'package:get/get.dart';

class CompletedAppointments extends StatelessWidget {
  const CompletedAppointments({super.key});


  @override
  Widget build(BuildContext context) {
    final appointmentController = Get.find<AppointmentController>();
    appointmentController.getCompletedAppointments();
    return
        appointmentController.isLoading.value?Center(child: CircularProgressIndicator(),):
        ListView.builder(
        itemCount: appointmentController.completedAppointments.length,
        itemBuilder: (context,index){
          var data = appointmentController.completedAppointments[index];
          return AppointmentCard(
              type: "completed",
              upcomingAppointments: data, onStartInspection: (){});
        });
  }
}
