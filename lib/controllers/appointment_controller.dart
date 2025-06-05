
import 'package:gaa_adv/models/appointment_details.dart';
import 'package:gaa_adv/models/upcoming_appointments.dart';
import 'package:gaa_adv/service/appointment_service.dart';
import 'package:gaa_adv/views/inspection_forms/fe_form.dart';
import 'package:get/get.dart';

class AppointmentController extends GetxController {
  RxList<UpcomingAppointments> upcomingAppointments = <UpcomingAppointments>[].obs;
  RxList<UpcomingAppointments> completedAppointments = <UpcomingAppointments>[].obs;
  RxList<UpcomingAppointments> currentAppointments = <UpcomingAppointments>[].obs;
  AppointmentService appointmentService = AppointmentService();
  RxBool isLoading = false.obs;
  RxString errorMessage = "".obs;

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

  getCurrentAppointments() async {
    isLoading.value = true;
    errorMessage.value = "";
    update();
    try {
      final List<UpcomingAppointments> result = await appointmentService.getCurrentAppointments();
      currentAppointments.value = result;
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

  resumeInspection(String appID){
    getAppointmentDetails(appID);
    Get.to(()=>FieldEngineerFormOP(
        initialData: appointmentDetails.value,
        onFormSubmit: (da){}, onFormDataChange: (da){}));
  }

  RxInt selectedIndex =0.obs;

  updateSelection(int index){
      selectedIndex.value =index;
      update();
  }

}