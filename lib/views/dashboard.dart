import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gaa_adv/controllers/appointment_controller.dart';
import 'package:gaa_adv/controllers/attendace_controller.dart';
import 'package:gaa_adv/controllers/auth_controller.dart';
import 'package:gaa_adv/views/appointments/appointment_card.dart';
import 'package:gaa_adv/views/upcoming_card.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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

  void _onItemTapped(int index) {
    if (index == 0) {
    } else if (index == 1) {
      Get.offNamed('/menu');
    } else if (index == 2) {
      Get.offNamed('/profile');
    }
  }

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
      body: RefreshIndicator(
        onRefresh: () async {
          appointmentController.getUpcomingAppointments();
          attendanceController.checkShiftStatus();
          await Future.delayed(const Duration(seconds: 1));
        },
        child: Obx(() {
          return Column(
            children: [
              // Shift Status Card
              Padding(
                padding: const EdgeInsets.all(10),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                attendanceController.attendanceStatusVal.value == 0
                                    ? "Please start your shift"
                                    : attendanceController.attendanceStatusVal.value == 1
                                    ? "Your shift is started"
                                    : "Your shift is over",
                                style: GoogleFonts.poppins(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            ),
                            Text(
                              attendanceController.attendanceStatusVal.value == 2
                                  ? "Duration: ${attendanceController.totalDuration.value}"
                                  : "",
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5.0, right: 5),
                                child: ElevatedButton(
                                  onPressed: !attendanceController.isStartShiftVisible.value
                                      ? null
                                      : () {
                                    attendanceController.startShift();
                                  },
                                  child: attendanceController.startShiftLoading.value
                                      ? const CircularProgressIndicator()
                                      : const Text("Start Shift"),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5.0, right: 5),
                                child: ElevatedButton(
                                  onPressed: !attendanceController.isEndShiftVisible.value
                                      ? null
                                      : () {
                                    attendanceController.endShift();
                                  },
                                  child: attendanceController.endShiftLoading.value
                                      ? const CircularProgressIndicator()
                                      : const Text("End Shift"),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5.0, right: 5),
                                child: Text(attendanceController.startShiftTime.value),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5.0, right: 5),
                                child: Text(attendanceController.endShiftTime.value),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Appointments List
              Text(
                "Your Upcoming Appointments",
                style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              appointmentController.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : appointmentController.upcomingAppointments.isEmpty
                  ? const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("No upcoming appointments."),
              )
                  : Expanded(
                // Wrap ListView.builder with Expanded
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: appointmentController.upcomingAppointments.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: AppointmentCard(
                          upcomingAppointments: appointmentController.upcomingAppointments[index],
                          onStartInspection: (){
                            if (appointmentController.upcomingAppointments[index].id != null) {
                              Get.to(() => FieldEngineerForm(
                                appointmentData: _prepareAppointmentData(appointmentController.upcomingAppointments[index]),
                                appointmentId: appointmentController.upcomingAppointments[index].id!,
                                initialFormData: InspectionFormData(
                                  clientName: appointmentController.upcomingAppointments[index].clientName1,
                                  propertyAddress:
                                  "${appointmentController.upcomingAppointments[index].addressLine1 ?? ''}, ${appointmentController.upcomingAppointments[index].addressLine2 ?? ''}",
                                ),
                                onFormSubmit: (formData) {
                                  Get.back();
                                  Get.snackbar("Success", "Inspection Completed!");
                                },
                                onFormDataChange: (formData) {
                                  print("Form data changed: $formData");
                                },
                                MediaType: null,
                              ));
                            } else {
                              Get.snackbar("Error", "Appointment ID is missing.");
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        }),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}