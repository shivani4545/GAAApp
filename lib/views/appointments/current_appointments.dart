import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gaa_adv/controllers/appointment_controller.dart';
import 'package:gaa_adv/views/appointments/appointment_card.dart';
import 'package:get/get.dart';


class CurrentAppointments extends StatelessWidget {
  const CurrentAppointments({super.key});

  @override
  Widget build(BuildContext context) {
    final appointmentController = Get.put(AppointmentController());

    return Obx(() => ListView.builder(
      itemCount: appointmentController.currentAppointments.length,
      itemBuilder: (context, index) {
        var data = appointmentController.currentAppointments[index];
        log("Data: $data");
        return AppointmentCard(
          type: "current",
          upcomingAppointments: data,
          onStartInspection: () {
            appointmentController.resumeInspection(appointmentController.currentAppointments[index].id.toString());
          },
        );
      },
    ));
  }
}

