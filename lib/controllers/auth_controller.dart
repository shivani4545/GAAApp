import 'dart:io';

import 'package:gaa_adv/models/login_response_model.dart';
import 'package:gaa_adv/service/login_service.dart';
import 'package:gaa_adv/service/shared_pref_service.dart';
import 'package:gaa_adv/views/dashboard.dart';
import 'package:gaa_adv/views/login_screen.dart';
import 'package:gaa_adv/views/splash_screen.dart';
import 'package:get/get.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// Conditional import for web support
import 'package:flutter/foundation.dart' show kIsWeb;

import '../views/upcoming_appointments.dart';

class AuthController extends GetxController {
  LoginResponse loginResponse = LoginResponse();
  LoginService loginService = LoginService();
  SharedPrefService sharedPrefService = SharedPrefService();

  RxBool passwordVisible = false.obs;
  RxBool isLoginLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkLogin();
    initializeFCM();
  }

  checkLogin() async {
    bool isLogin = await sharedPrefService.isLoggedIn();
    if (isLogin) {
      Future.delayed(const Duration(seconds: 3));
      Get.off(() => const Dashboard());
    } else {
      Future.delayed(const Duration(seconds: 3));
      Get.off(() => const LoginScreen());
    }
  }

  login(String email, String password) async {
    isLoginLoading.value = true;
    update();

    String? deviceId;
    try {
      deviceId = await _getDeviceId();
      if (deviceId == null) {
        Get.snackbar("Error", "Failed to get device ID.",
            duration: const Duration(seconds: 3));
        isLoginLoading.value = false;
        update();
        return;
      }

      loginResponse = await loginService.login(email, password, deviceId);

      if (loginResponse.status == true) {
        sharedPrefService.saveUserData(loginResponse);
        Get.off(() => Dashboard());
      } else {
        Get.snackbar("Error", loginResponse.message!,
            duration: const Duration(seconds: 3));
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          duration: const Duration(seconds: 3));
    } finally {
      isLoginLoading.value = false;
      update();
    }
  }

  logout() {
    sharedPrefService.logout();
    Get.off(() => LoginScreen());
  }

  Future<String?> _getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    try {
      if (Platform.isIOS) {
        IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
        return iosDeviceInfo.identifierForVendor;
      } else if (Platform.isAndroid) {
        AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
        return androidDeviceInfo.id;
      } else {
        return null;
      }
    } catch (e) {
      print("Error getting device ID: $e");
      return null;
    }
  }

  // --- FCM Token Handling ---

  Future<void> initializeFCM() async {
    // Ensure Firebase is initialized
    try {
      await Firebase.initializeApp();
    } catch (e) {
      print("Error initializing Firebase: $e");
      return;
    }

    String? fcmToken = await getFcmToken();
    if (fcmToken != null) {
      await storeFcmToken(fcmToken);
      await sendFcmTokenToBackend(fcmToken);
    }
  }

  Future<String?> getFcmToken() async {
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;

      // Request permission (iOS/Web)
      if (kIsWeb || Platform.isIOS) {
        NotificationSettings settings = await messaging.requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
        );

        print('User granted notifications permission: ${settings.authorizationStatus}');
      }

      String? token = await messaging.getToken();

      print('FCM Token: $token');

      return token;
    } catch (e) {
      print('Error getting FCM token: $e');
      return null;
    }
  }

  Future<void> storeFcmToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('fcm_token', token);
  }

  Future<void> sendFcmTokenToBackend(String token) async {
    // Replace with your backend API endpoint
    final url = Uri.parse('YOUR_BACKEND_URL/update-fcm-token');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: {'fcm_token': token},
      );

      if (response.statusCode == 200) {
        print('FCM token sent to backend successfully');
      } else {
        print('Failed to send FCM token to backend: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Error sending FCM token to backend: $e');
    }
  }
}