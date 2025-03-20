import 'package:gaa_adv/models/login_response_model.dart';
import 'package:gaa_adv/service/login_service.dart';
import 'package:gaa_adv/service/shared_pref_service.dart';
import 'package:gaa_adv/views/dashboard.dart';
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

  login(String userName, String password) async {
    isLoginLoading.value = true;
    update();
    try {
      loginResponse = await loginService.login(userName, password);
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
