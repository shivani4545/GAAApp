import 'package:flutter/material.dart';
import 'package:gaa_adv/models/upcoming_appointments.dart';
import 'package:gaa_adv/service/appointment_service.dart';
import 'package:get/get.dart';

class AppointmentController extends GetxController {
  RxList<UpcomingAppointments> upcomingAppointments = <UpcomingAppointments>[].obs;
  RxList<UpcomingAppointments> completedAppointments = <UpcomingAppointments>[].obs;
  AppointmentService appointmentService = AppointmentService();
  RxBool isLoading = false.obs;
  RxString errorMessage = "".obs;

  getUpcomingAppointments() async {
    isLoading.value = true;
    errorMessage.value = "";
    update();
    try {
      final List<UpcomingAppointments> result = await appointmentService.getUpcomingAppointmentsToday();
      upcomingAppointments.value = result;
      update();
    } catch (e) {
      errorMessage.value = "Failed to load appointments: ${e.toString()}";
    } finally {
      isLoading.value = false; // Stop loading
      update();
    }
  }

  getCompletedAppointments() async {
    isLoading.value = true;
    errorMessage.value = "";
    try {
      final List<UpcomingAppointments> result = await appointmentService.getUpcomingAppointmentsToday();
      completedAppointments.value = result;
    } catch (e) {
      errorMessage.value = "Failed to load appointments: ${e.toString()}";
    } finally {
      isLoading.value = false; // Stop loading
      update();
    }
  }

  RxInt selectedIndex =0.obs;

  updateSelection(int index){
      selectedIndex.value =index;
      update();
  }

}