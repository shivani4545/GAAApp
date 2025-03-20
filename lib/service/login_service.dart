import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/login_response_model.dart';
import '../utils/apis.dart';

class LoginService {

  Future<LoginResponse> login(String email, String password, String? deviceId) async {
    try {
      var url = Uri.parse(Apis.login);

      // Construct the request body as JSON
      var body = jsonEncode({
        'email': email,
        'password': password,
        if (deviceId != null) 'device_id': deviceId,
      });

      // Print the deviceId to the console for debugging
      print('Device ID in LoginService: $deviceId'); // Add this line

      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'}, // Set content type to JSON
        body: body,
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        LoginResponse loginResponse = LoginResponse.fromJson(data);
        return loginResponse;
      } else {
        var data = jsonDecode(response.body);
        return LoginResponse(message: data['message'], status: false);
      }
    } catch (e) {
      return LoginResponse(message: e.toString(), status: false);
    }
  }
}