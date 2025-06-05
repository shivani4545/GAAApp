import 'package:flutter/material.dart';
import 'package:gaa_adv/controllers/appointment_controller.dart';
import 'package:gaa_adv/views/appointments/appointment_card.dart';
import 'package:get/get.dart';
class UpcomingAppointments extends StatelessWidget {
  const UpcomingAppointments({super.key});

  @override
  Widget build(BuildContext context) {
    final appointmentController = Get.find<AppointmentController>();
    Get.put(AppointmentController().getUpcomingAppointments());
    return ListView.builder(
        itemCount: appointmentController.upcomingAppointments.length,
        itemBuilder: (context,index){
          var data = appointmentController.upcomingAppointments[index];
          return AppointmentCard(
              type: "upcoming",
              upcomingAppointments: data,
              onStartInspection: (){

              });
        });
  }

}
