import 'dart:convert';

import 'package:gaa_adv/models/upcoming_appointments.dart';
import 'package:gaa_adv/service/shared_pref_service.dart';

import '../utils/apis.dart';
import 'package:http/http.dart' as http;

class AppointmentService {
  SharedPrefService sharedPrefService = SharedPrefService();

  Future<List<UpcomingAppointments>> getUpcomingAppointments() async {
    var token = await sharedPrefService.getAccessToken();
    var userId = await sharedPrefService.getUserId();
    print("Token: $token");
    print("User ID: $userId");

    try {
      final uri = Uri.parse(Apis.upcomingAppointments(userId.toString()));
      print("API URL: $uri"); // Print the constructed URL

      final header = {"Authorization": "Bearer $token"};
      print("Headers: $header"); // Print the headers

      final response = await http.get(uri, headers: header);
      print("Response Status Code: ${response.statusCode}"); // Print status code
      print("Response Body: ${response.body}"); // Print the entire response body

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        print("Decoded Response Data: $responseData");
        List<UpcomingAppointments> attendanceStatusResponse =
        upcomingAppointmentsFromJson(response.body);
        print("Parsed Appointments Count: ${attendanceStatusResponse.length}");
        return attendanceStatusResponse;
      } else {
        print("API Error: Status code ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Exception during API call: $e");
      return [];
    }
  }
}