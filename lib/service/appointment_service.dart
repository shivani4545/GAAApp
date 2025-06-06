import 'dart:convert';
import 'dart:developer';

import 'package:gaa_adv/models/appointment_details.dart';
import 'package:gaa_adv/models/upcoming_appointments.dart';
import 'package:gaa_adv/service/shared_pref_service.dart';

import '../utils/apis.dart';
import 'package:http/http.dart' as http;

class AppointmentService {
  SharedPrefService sharedPrefService = SharedPrefService();

  Future<List<UpcomingAppointments>> getUpcomingAppointmentsToday() async {
    var token = await sharedPrefService.getAccessToken();
    var userId = await sharedPrefService.getUserId();
    print(token);

    try {
      final uri = Uri.parse(Apis.upcomingAppointmentsToday(userId.toString()));

      final header = {"Authorization": "Bearer $token"};

      final response = await http.get(uri, headers: header);

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        List<UpcomingAppointments> attendanceStatusResponse =
        upcomingAppointmentsFromJson(response.body);
        return attendanceStatusResponse;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<UpcomingAppointments>> getCurrentAppointments() async {
    var token = await sharedPrefService.getAccessToken();
    var userId = await sharedPrefService.getUserId();
    print(token);

    try {
      final uri = Uri.parse(Apis.currentAppointments);

      final header = {"Authorization": "Bearer $token"};

      final response = await http.get(uri, headers: header);

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        List<UpcomingAppointments> attendanceStatusResponse =
        upcomingAppointmentsFromJson(response.body);
        return attendanceStatusResponse;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<UpcomingAppointments>> getCompletedAppointments() async {
    var token = await sharedPrefService.getAccessToken();
    var userId = await sharedPrefService.getUserId();
    print(token);

    try {
      final uri = Uri.parse(Apis.completedAppointment);

      final header = {"Authorization": "Bearer $token"};

      final response = await http.get(uri, headers: header);

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        List<UpcomingAppointments> attendanceStatusResponse =
        upcomingAppointmentsFromJson(response.body);
        return attendanceStatusResponse;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<AppointmentDetails> getAppointmentDetails(String appId) async {
    var token = await sharedPrefService.getAccessToken();
    var userId = await sharedPrefService.getUserId();

    try {
      final uri = Uri.parse(Apis.getAppointmentDetail(appId));

      final header = {"Authorization": "Bearer $token"};

      final response = await http.get(uri, headers: header);
      log("Appointment Details : ${response.body}");

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        AppointmentDetails attendanceStatusResponse =
        appointmentDetailsFromJson(response.body);
        return attendanceStatusResponse;
      } else {
        return AppointmentDetails();
      }
    } catch (e) {
      return AppointmentDetails();
    }
  }

}