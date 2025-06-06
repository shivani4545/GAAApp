
import 'dart:developer';

import 'package:gaa_adv/models/appointment_details.dart';
import 'package:gaa_adv/models/upcoming_appointments.dart';
import 'package:gaa_adv/service/appointment_service.dart';
import 'package:gaa_adv/views/field_engineer_form.dart';
import 'package:gaa_adv/views/inspection_forms/fe_form.dart';
import 'package:get/get.dart';

import '../views/appointment_details_page.dart';

class AppointmentController extends GetxController {
  RxList<UpcomingAppointments> upcomingAppointments = <UpcomingAppointments>[].obs;
  RxList<UpcomingAppointments> completedAppointments = <UpcomingAppointments>[].obs;
  RxList<UpcomingAppointments> currentAppointments = <UpcomingAppointments>[].obs;
  AppointmentService appointmentService = AppointmentService();
  RxBool isLoading = false.obs;
  RxString errorMessage = "".obs;


  @override
  void onInit() {
    getCompletedAppointments();
    getCurrentAppointments();
    getUpcomingAppointments();
  }

  Rx<AppointmentDetails> appointmentDetails = AppointmentDetails().obs;

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

    try {
      final List<UpcomingAppointments> result = await appointmentService.getCompletedAppointments();
      completedAppointments.value = result;
    } catch (e) {
      errorMessage.value = "Failed to load appointments: ${e.toString()}";
    } finally {

    }

    update();
  }

  getCurrentAppointments() async {
    isLoading.value = true;
    errorMessage.value = "";
    update();
    try {
      final List<UpcomingAppointments> result = await appointmentService.getCurrentAppointments();
      currentAppointments.value = result;
      log("Current ${currentAppointments}");
      update();
    } catch (e) {
      errorMessage.value = "Failed to load appointments: ${e.toString()}";
    } finally {
      isLoading.value = false; // Stop loading
      update();
    }
  }

  getAppointmentDetails(String appID)async{
    appointmentDetails.value = await appointmentService.getAppointmentDetails(appID);
    update();
  }

  viewAppointmentDetailsPage(String appID)async{
    AppointmentDetails appDetails = await appointmentService.getAppointmentDetails(appID);
    Get.to(()=>AppointmentDetailsPage(details: appDetails,appID: appID,));

  }

  resumeInspection(String appID)async{
    appointmentDetails.value = await appointmentService.getAppointmentDetails(appID);
    update();
    log("appointment details ${appointmentDetails.value.personalInfo!.caseId}");
    getAppointmentDetails(appID);
    Get.to(()=>FieldEngineerForm(
      initialFormData:  appointmentDetails.value,
        appointmentId: int.parse(appID),
        onFormSubmit: (da){}, onFormDataChange: (da){}));
  }

  RxInt selectedIndex =0.obs;

  updateSelection(int index){
      selectedIndex.value =index;
      update();
  }

}