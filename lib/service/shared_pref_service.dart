import 'package:gaa_adv/models/login_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService{
  static const String keyAccessToken = "access_token";
  static const String keyUserID = "user_id";
  static const String keyIsLoggedIn = "is_logged_in";
  static const String keyFormID ="appointment_id";
  static const String keyShiftStatus = "shift_status"; // Key for shift status


  Future<void> saveUserData(LoginResponse loginDataModel) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyAccessToken, loginDataModel.token!);
    await prefs.setString(keyUserID, loginDataModel.user!.id!.toString());
    await prefs.setBool(keyIsLoggedIn, true);
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyAccessToken);
  }
  Future<String?> getFormID() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyFormID);
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyUserID);
  }
  Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return null;
  }

  Future<bool> isLoggedIn() async {

    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyIsLoggedIn) ?? false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Add these methods for shift status
  Future<void> saveShiftStatus(String status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyShiftStatus, status);
  }

  Future<String> getShiftStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyShiftStatus) ?? ""; // Or some other default value that makes sense for your app
  }
}