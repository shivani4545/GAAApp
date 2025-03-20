import 'dart:convert';

import 'package:gaa_adv/service/shared_pref_service.dart';
import 'package:http/http.dart' as http;
import '../models/attendance_status_response.dart';
import '../utils/apis.dart';

class AttendanceService {

  SharedPrefService sharedPrefService = SharedPrefService();

  Future<AttendanceStatusResponse> getAttendanceStatus() async {
    var token = await sharedPrefService.getAccessToken();
    var userId = await sharedPrefService.getUserId();
   // print("Token:$token");
    try {
      final uri = Uri.parse(Apis.attendance(userId.toString()));
      final header = {"Authorization": "Bearer $token"};
      final response = await http.get(uri, headers: header);

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        var attendanceStatusResponse = AttendanceStatusResponse.fromJson(
            responseData);
        return attendanceStatusResponse;
      } else {
        return AttendanceStatusResponse(status: 0);
      }
    } catch (e) {
      return AttendanceStatusResponse(status: 0);
    }
  }


  Future<bool> startShift() async {
    var token = await sharedPrefService.getAccessToken();
    try {
      final uri = Uri.parse(Apis.startShift);
      final response = await http.post(
          uri, headers: {"Authorization": "Bearer $token"});

      if (response.statusCode == 201 || response.statusCode == 200) {
        var responseData = json.decode(response.body);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> endShift() async {
    var token = await sharedPrefService.getAccessToken();

    try {
      final uri = Uri.parse(Apis.endShift);
      final response = await http.post(
          uri, headers: {"Authorization": "Bearer $token"});

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateLocation(String latitude, String longitude) async {
    var token = await sharedPrefService.getAccessToken();
    var userID = await sharedPrefService.getUserId();

    try {
      final uri = Uri.parse(Apis.updateLocation);
      final body = jsonEncode({"fe_id": userID, "latitude": latitude, "longitude": longitude});

      final header = {"Authorization": "Bearer $token", "Content-Type": "application/json"};
      final response = await http.post(uri, headers: header, body: body);
      print("Response Status Code1: ${response.statusCode}");
      print("Response Body1: ${response.body}");

      if (response.statusCode == 201) {
        try {
          // Attempt to decode the response as JSON
          final responseData = json.decode(response.body);
          // Process the JSON data (if it's valid)
         // print("JSON Response Data: $responseData");
          return true; // Or base success on the contents of responseData
        } catch (jsonError) {
          // Handle JSON decoding error (e.g., if the response is HTML)
          print("JSON Decoding Error: $jsonError");
         print("Response is likely not JSON. Handling as non-JSON.");
          // You might want to check the response body for a specific error message
          // or display a generic error message to the user.
          return false; // Indicate failure, as the location update likely failed
        }
      } else {
        print("Update Location Failed1: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error updating location: $e");
      return false;
    }
  }
}