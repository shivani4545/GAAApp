import 'package:flutter/material.dart';
import 'package:gaa_adv/models/upcoming_appointments.dart';
import 'package:gaa_adv/service/appointment_service.dart';
import 'package:get/get.dart';

class AppointmentController extends GetxController {
  RxList<UpcomingAppointments> upcomingAppointments = <UpcomingAppointments>[].obs;
  AppointmentService appointmentService = AppointmentService();
  RxBool isLoading = false.obs;
  RxString errorMessage = "".obs;
  @override
  void onInit() {
    super.onInit();
    getUpcomingAppointments();
  }

  Future<void> getUpcomingAppointments() async {
    isLoading.value = true;
    errorMessage.value = "";
    try {
      final List<UpcomingAppointments> result = await appointmentService.getUpcomingAppointments();
      upcomingAppointments.value = result;
    } catch (e) {
      errorMessage.value = "Failed to load appointments: ${e.toString()}";
    } finally {
      isLoading.value = false; // Stop loading
      update();
    }
  }

}