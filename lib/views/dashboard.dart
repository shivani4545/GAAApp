import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gaa_adv/controllers/appointment_controller.dart';
import 'package:gaa_adv/controllers/attendace_controller.dart';
import 'package:gaa_adv/controllers/auth_controller.dart';
import 'package:gaa_adv/views/appointments/appointment_card.dart';
import 'package:gaa_adv/views/appointments/view_all_appointments.dart';
import 'package:gaa_adv/views/home.dart';
import 'package:gaa_adv/views/upcoming_card.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import '../models/upcoming_appointments.dart';
import 'bottom_nevigation_bar.dart';
import 'drawer.dart';
import 'field_engineer_form.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int selectedIndex = 0;

  Map<String, dynamic> _prepareAppointmentData(
      UpcomingAppointments appointment) {
    return {
      'clientName': appointment.clientName1 ?? '',
      'propertyAddress':
      "${appointment.addressLine1 ?? ''}, ${appointment.addressLine2 ?? ''}",
      'inspectionDate': appointment.dateOfAvailability?.toIso8601String(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    final attendanceController = Get.find<AttendanceController>();
    final appointmentController = Get.find<AppointmentController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      appointmentController.getUpcomingAppointments();
      attendanceController.checkShiftStatus();
    });

    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: const Color(0xFFF9CB47).withOpacity(0.5),
        ),
        backgroundColor: const Color(0xFFF9CB47).withOpacity(0.7),
        title: Text(
          'Dashboard',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: [
          Home(),
          ViewAllAppointments(),
          Container()
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF9CB47).withOpacity(0.7),
        ),
        child: SalomonBottomBar(
          currentIndex: selectedIndex,
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          items: [
            SalomonBottomBarItem(
              icon: const Icon(Icons.home),
              title: const Text("Home"),
              selectedColor: const Color(0xff171433),
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.dashboard),
              title: const Text("Appointments"),
              selectedColor: const Color(0xff171433),
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.calendar_today),
              title: const Text("Profile"),
              selectedColor: const Color(0xff171433),
            ),
          ],
        ),
      ),
    );
  }
}