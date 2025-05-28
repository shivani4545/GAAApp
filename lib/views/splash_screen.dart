import 'package:flutter/material.dart';
import 'package:gaa_adv/controllers/auth_controller.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AuthController());
    Get.find<AuthController>().checkLogin();
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}