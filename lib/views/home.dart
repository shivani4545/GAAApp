import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // Add for date formatting

import '../controllers/appointment_controller.dart';
import '../controllers/attendace_controller.dart';
import '../controllers/auth_controller.dart';
import '../models/upcoming_appointments.dart';
import 'appointments/appointment_card.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Access controllers once
  final AuthController authController = Get.find<AuthController>();
  final AttendanceController attendanceController = Get.find<AttendanceController>();
  final AppointmentController appointmentController = Get.find<AppointmentController>();

  @override
  void initState() {
    super.initState();
    // Fetch initial data when the widget is first created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshData();
    });
  }

  Future<void> _refreshData() async {
    // Tell Future.wait to expect a list of futures that can resolve to anything.
    await Future.wait<dynamic>([ // or <Object?>
      appointmentController.getUpcomingAppointments(),
      attendanceController.checkShiftStatus(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use a background color for a more finished look
      backgroundColor: Colors.grey[50],
      body: RefreshIndicator(
        onRefresh: _refreshData,
        // Use CustomScrollView for a more dynamic and attractive layout
        child: CustomScrollView(
          slivers: [

            Obx(() => _buildShiftStatusCard(attendanceController)),
            _buildAppointmentsSectionHeader(),
            // Use Obx to only rebuild the appointments list when its data changes
            Obx(() {
              if (appointmentController.isLoading.value) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final appointments = appointmentController.currentAppointments.isNotEmpty
                  ? appointmentController.currentAppointments
                  : appointmentController.upcomingAppointments;

              final type = appointmentController.currentAppointments.isNotEmpty
                  ? "current"
                  : "upcoming";

              if (appointments.isEmpty) {
                return _buildEmptyState();
              }

              return _buildAppointmentsList(appointments, type, appointmentController);
            }),
          ],
        ),
      ),
    );
  }


  /// Builds the redesigned, visually appealing shift status card
  Widget _buildShiftStatusCard(AttendanceController controller) {
    final status = controller.attendanceStatusVal.value;
    String statusText;
    IconData statusIcon;
    Color statusColor;

    switch (status) {
      case 1:
        statusText = "Shift Active";
        statusIcon = Icons.play_circle_fill_rounded;
        statusColor = Colors.teal;
        break;
      case 2:
        statusText = "Shift Over";
        statusIcon = Icons.check_circle_rounded;
        statusColor = Colors.blueGrey;
        break;
      default:
        statusText = "Shift Inactive";
        statusIcon = Icons.pause_circle_filled_rounded;
        statusColor = Colors.orange;
    }

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 6.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          clipBehavior: Clip.antiAlias, // Ensures gradient respects border radius
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [statusColor.withOpacity(0.8), statusColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(statusIcon, color: Colors.white, size: 28),
                    const SizedBox(width: 12),
                    Text(
                      statusText,
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildTimeRow(
                  "Start Time:",
                  controller.startShiftTime.value,
                  Icons.timer_outlined,
                ),
                const SizedBox(height: 8),
                _buildTimeRow(
                  "End Time:",
                  controller.endShiftTime.value,
                  Icons.timer_off_outlined,
                ),
                if (status == 2) ...[
                  const SizedBox(height: 8),
                  _buildTimeRow(
                    "Duration:",
                    controller.totalDuration.value,
                    Icons.hourglass_bottom_rounded,
                  ),
                ],
                const SizedBox(height: 20),
                // Show only the relevant button
                if (controller.isStartShiftVisible.value || controller.isEndShiftVisible.value)
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (controller.isStartShiftVisible.value) {
                          controller.startShift();
                        } else if (controller.isEndShiftVisible.value) {
                          controller.endShift();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: statusColor,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        textStyle: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: (controller.startShiftLoading.value || controller.endShiftLoading.value)
                          ? SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(strokeWidth: 3, color: statusColor),
                      )
                          : Text(controller.isStartShiftVisible.value ? "Start Shift" : "End Shift"),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Helper to build a styled row for time information
  Widget _buildTimeRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 18),
        const SizedBox(width: 8),
        Text(
          "$label ",
          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
        ),
        Text(
          value.isNotEmpty ? value : "N/A",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  /// Builds the header for the appointments list
  Widget _buildAppointmentsSectionHeader() {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      sliver: SliverToBoxAdapter(
        child: Row(
          children: [
            const Icon(Icons.calendar_month_outlined, color: Colors.deepPurple),

            SizedBox(width: 20,),
            Text(
              "Active Appointments",
              style: GoogleFonts.openSans(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the scrollable list of appointments
  Widget _buildAppointmentsList(
      List<UpcomingAppointments> appointments, String type, AppointmentController controller) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          final appointment = appointments[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            // Assuming AppointmentCard is already designed. If not, it should
            // also be designed with elevation, rounded corners, and clear info.
            child: AppointmentCard(
              type: type,
              upcomingAppointments: appointment,
              onStartInspection: () {
                controller.resumeInspection(appointment.id.toString());
              },
            ),
          );
        },
        childCount: appointments.length,
      ),
    );
  }

  /// Builds a visually appealing widget for when there are no appointments
  Widget _buildEmptyState() {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.task_alt_rounded,
                size: 80,
                color: Colors.grey[300],
              ),
              const SizedBox(height: 16),
              Text(
                "All Clear!",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "You have no active appointments at the moment.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}