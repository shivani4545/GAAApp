import 'package:flutter/material.dart';
import 'package:gaa_adv/models/upcoming_appointments.dart';
import 'package:gaa_adv/service/appointment_service.dart';
import 'package:get/get.dart';

class AppointmentController extends GetxController {
  RxList<UpcomingAppointments> upcomingAppointments = <UpcomingAppointments>[].obs;
  AppointmentService appointmentService = AppointmentService();
  RxBool isLoading = false.obs; // Add loading state
  RxString errorMessage = "".obs; //For handling error messages

  @override
  void onInit() {
    super.onInit();
    getUpcomingAppointments(); // Load data when controller is initialized
  }

  Future<void> getUpcomingAppointments() async {
    isLoading.value = true; // Start loading
    errorMessage.value = ""; // Clear any previous error
    try {
      final List<UpcomingAppointments> result = await appointmentService.getUpcomingAppointments();
      upcomingAppointments.value = result;
     // print("Appointments loaded successfully. Count: ${upcomingAppointments.length}");
    } catch (e) {
      errorMessage.value = "Failed to load appointments: ${e.toString()}";
     // print("Error loading appointments: ${e.toString()}");
    } finally {
      isLoading.value = false; // Stop loading
      update(); // Important to rebuild Obx widgets
    }
  }

  // --- Method to filter out appointments with null IDs ---
  List<UpcomingAppointments> getAppointmentsWithNonNullIds() {
    return upcomingAppointments.where((appointment) => appointment.id != null).toList();
  }
}