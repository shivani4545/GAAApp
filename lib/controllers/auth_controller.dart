import 'dart:developer';
import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:gaa_adv/models/login_response_model.dart';
import 'package:gaa_adv/service/login_service.dart';
import 'package:gaa_adv/service/shared_pref_service.dart';
import 'package:gaa_adv/views/dashboard.dart' hide Dashboard;
import 'package:gaa_adv/views/login_screen.dart';
import 'package:gaa_adv/views/splash_screen.dart';
import 'package:get/get.dart';

import '../views/upcoming_appointments.dart';

class AuthController extends GetxController {

  LoginResponse loginResponse = LoginResponse();
  LoginService loginService = LoginService();
  SharedPrefService sharedPrefService = SharedPrefService();

  RxBool passwordVisible = false.obs;
  RxBool isLoginLoading = false.obs;

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

  Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) { // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if(Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return AndroidId().getId(); // unique ID on Android
    }
  }

  Future<String?> getfcmToken()async{
    String? token;
    try{
       token = await FirebaseMessaging.instance.getToken();
    }catch(e){
      log(e.toString());
    }
    return token;

  }


  login(String userName, String password) async {
    isLoginLoading.value = true;
    update();

    String? deviceID = await _getId();
    String? tokenID = await getfcmToken();print("Device $deviceID FCM $tokenID");
    try {
      loginResponse = await loginService.login(userName, password,deviceID,tokenID);
      if (loginResponse.status == true) {
        sharedPrefService.saveUserData(loginResponse);
        Get.off(() => Dashboard());
      } else {
        Get.snackbar(
            "Error", loginResponse.message!, duration: Duration(seconds: 3));
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(), duration: const Duration(seconds: 3));
    }

    isLoginLoading.value = false;
    update();
  }

  logout() {
    sharedPrefService.logout();
    Get.off(() => LoginScreen());
  }

}
