import 'dart:convert';


import '../models/login_response_model.dart';
import '../utils/apis.dart';
import 'package:http/http.dart' as http;
class LoginService{

  Future<LoginResponse> login(String email, String password) async {
    try {
      var url = Uri.parse(Apis.login);
      var body = {
        'email': email,
        'password': password,
      };
      var response = await http.post(url, body: body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        LoginResponse loginResponse = LoginResponse.fromJson(data);
        return loginResponse;
      } else {
        var data = jsonDecode(response.body);
        return LoginResponse(message: data['message'],status: false);
      }
    } catch (e) {
      return LoginResponse(message: e.toString(),status: false);

    }
  }

}