import 'package:flutter/material.dart';
import 'package:gaa_adv/controllers/auth_controller.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize AuthController and call checkLogin
    Get.put(AuthController());
    Get.find<AuthController>().checkLogin();  // Call checkLogin after putting
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()), // Or your splash screen UI
    );
  }
}