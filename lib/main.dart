import 'package:flutter/material.dart';
import 'package:gaa_adv/controllers/appointment_controller.dart';
import 'package:gaa_adv/controllers/attendace_controller.dart';
import 'package:gaa_adv/controllers/auth_controller.dart';
import 'package:gaa_adv/views/appointments/view_all_appointments.dart';
import 'package:gaa_adv/views/camera.dart';
import 'package:gaa_adv/views/camera_screen.dart';
import 'package:gaa_adv/views/dashboard.dart';
import 'package:gaa_adv/views/profile_screen.dart';
import 'package:gaa_adv/views/splash_screen.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
void main()async {

  runApp(const MyApp());

  Get.put(AuthController());
  Get.put(AttendanceController());
  Get.put(AppointmentController());
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);// ✅ Initialize Firebase first

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GAA',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(), // Set the initial screen to SplashScreen
      getPages: [
        GetPage(name: '/dashboard', page: () => const Dashboard()),
        //GetPage(name: '/camera', page: () => const ImageUploadScreen()),
        GetPage(name: '/appointments', page: () => const ViewAllAppointments()),
       // GetPage(name: '/profile', page: () => const ImageUploadScreen()),

      ],
    );
  }
}