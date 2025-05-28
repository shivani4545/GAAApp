// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:gaa_adv/controllers/appointment_controller.dart';
// import 'package:gaa_adv/controllers/attendace_controller.dart';
// import 'package:gaa_adv/controllers/auth_controller.dart';
// import 'package:gaa_adv/views/upcoming_card.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'bottom_nevigation_bar.dart';
// import 'drawer.dart';
// class Dashboard extends StatefulWidget {
//   const Dashboard({Key? key}) : super(key: key);
//
//   @override
//   State<Dashboard> createState() => _DashboardState();
// }
//
// class _DashboardState extends State<Dashboard> {
//   int selectedIndex = 0; // Initially select Dashboard
//
//   void _onItemTapped(int index) {
//     // Navigate based on the selected index.  Modify as needed.
//     if (index == 0) {
//       // Stay on Dashboard (already here)
//     } else if (index == 1) {
//       Get.offNamed('/Dashboard'); // Navigate to menu. Use offNamed to replace route
//     } else if (index == 2) {
//       Get.offNamed('/profile'); // Navigate to profile. Use offNamed to replace route
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<AuthController>();
//     final attendanceController = Get.find<AttendanceController>();
//     final appointmentController = Get.find<AppointmentController>();
//
//     // Fetch data when the widget is built
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       appointmentController.getUpcomingAppointments();
//       attendanceController.checkShiftStatus();
//     });
//
//     return Scaffold(
//       drawer: const MyDrawer(),
//       appBar: AppBar(
//         systemOverlayStyle: SystemUiOverlayStyle(
//           statusBarColor: const Color(0xFFF9CB47).withOpacity(0.5),
//         ),
//         backgroundColor: const Color(0xFFF9CB47).withOpacity(0.7),
//         title: Text(
//           'Dashboard',
//           style: GoogleFonts.poppins(
//             color: Colors.black,
//             fontSize: 20,
//           ),
//         ),
//       ),
//       body: RefreshIndicator(
//         onRefresh: () async {
//           appointmentController.getUpcomingAppointments();
//           attendanceController.checkShiftStatus();
//           await Future.delayed(const Duration(seconds: 1));
//         },
//         child: Obx(() {
//           return Column(
//             children: [
//               // Shift Status Card
//               Padding(
//                 padding: const EdgeInsets.all(10),
//                 child: Card(
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Expanded(
//                               child: Text(
//                                 attendanceController.attendanceStatusVal.value == 0
//                                     ? "Please start your shift"
//                                     : attendanceController.attendanceStatusVal.value == 1
//                                     ? "Your shift is started"
//                                     : "Your shift is over",
//                                 style: GoogleFonts.poppins(
//                                     fontSize: 16, fontWeight: FontWeight.w500),
//                               ),
//                             ),
//                             Text(
//                               attendanceController.attendanceStatusVal.value == 2
//                                   ? "Duration: ${attendanceController.totalDuration.value}"
//                                   : "",
//                             ),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             Expanded(
//                               child: Padding(
//                                 padding: const EdgeInsets.only(left: 5.0, right: 5),
//                                 child: ElevatedButton(
//                                   onPressed: !attendanceController.isStartShiftVisible.value
//                                       ? null
//                                       : () {
//                                     attendanceController.startShift();
//                                   },
//                                   child: attendanceController.startShiftLoading.value
//                                       ? const CircularProgressIndicator()
//                                       : const Text("Start Shift"),
//                                 ),
//                               ),
//                             ),
//                             Expanded(
//                               child: Padding(
//                                 padding: const EdgeInsets.only(left: 5.0, right: 5),
//                                 child: ElevatedButton(
//                                   onPressed: !attendanceController.isEndShiftVisible.value
//                                       ? null
//                                       : () {
//                                     attendanceController.endShift();
//                                   },
//                                   child: attendanceController.endShiftLoading.value
//                                       ? const CircularProgressIndicator()
//                                       : const Text("End Shift"),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             Expanded(
//                               child: Padding(
//                                 padding: const EdgeInsets.only(left: 5.0, right: 5),
//                                 child: Text(attendanceController.startShiftTime.value),
//                               ),
//                             ),
//                             Expanded(
//                               child: Padding(
//                                 padding: const EdgeInsets.only(left: 5.0, right: 5),
//                                 child: Text(attendanceController.endShiftTime.value),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               // Appointments List
//               Text(
//                 "Your Upcoming Appointments",
//                 style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.w600),
//               ),
//               appointmentController.isLoading.value
//                   ? const Center(child: CircularProgressIndicator())
//                   : appointmentController.upcomingAppointments.isEmpty
//                   ? const Padding(
//                 padding: EdgeInsets.all(16.0),
//                 child: Text("No upcoming appointments."),
//               )
//                   : Expanded(
//                 // Wrap ListView.builder with Expanded
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: ListView.builder(
//                     physics: const AlwaysScrollableScrollPhysics(),
//                     itemCount: appointmentController.upcomingAppointments.length,
//                     itemBuilder: (context, index) {
//                       return Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 4.0),
//                         child: UpcomingCard(
//                           upcomingAppointment:
//                           appointmentController.upcomingAppointments[index],
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           );
//         }),
//       ),
//       bottomNavigationBar: CustomBottomNavigationBar(
//         selectedIndex: selectedIndex,
//         onItemTapped: _onItemTapped,
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gaa_adv/controllers/appointment_controller.dart';
import 'package:gaa_adv/controllers/attendace_controller.dart';
import 'package:gaa_adv/controllers/auth_controller.dart'; // Keep if MyDrawer or other parts need it via Get.find in build
// import 'package:gaa_adv/views/upcoming_card.dart'; // Uncomment if/when the ListView is used
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'bottom_nevigation_bar.dart'; // Assuming this is correctly implemented
import 'drawer.dart'; // Assuming this is correctly implemented
import 'package:gaa_adv/views/upcoming_card.dart'; // Make sure this path is correct if you uncomment the ListView

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int selectedIndex = 0;
  String selectedFilter = 'This Month';

  // Declare controllers as instance variables
  late final AppointmentController appointmentController;
  late final AttendanceController attendanceController;
  // AuthController can be found directly in build if only used there, or initialized here if needed more broadly in state.
  // late final AuthController authController;


  @override
  void initState() {
    super.initState();
    // Initialize controllers
    appointmentController = Get.find<AppointmentController>();
    attendanceController = Get.find<AttendanceController>();
    // authController = Get.find<AuthController>(); // If needed in other state methods

    // Fetch initial data
    _fetchData();
  }

  void _fetchData() {
    appointmentController.getUpcomingAppointments();
    attendanceController.checkShiftStatus();
  }

  void _onItemTapped(int index) {
    if (selectedIndex == index) return; // Avoid redundant navigation if already on the page

    setState(() {
      selectedIndex = index; // Update selectedIndex for the BottomNavigationBar
    });

    if (index == 0) {
      // Already on Dashboard, or if you want to ensure it reloads/resets:
      // Get.offNamed('/Dashboard'); // Though usually not needed if already here
    } else if (index == 1) {
      // Assuming index 1 is for a different screen, e.g., a "Menu" or "AppointmentsList" screen
      // Replace '/menu_screen_route' with the actual route name
      // Get.offNamed('/menu_screen_route');
      // If it's truly meant to be '/Dashboard' again, the current code is fine but might be confusing UX.
      // For now, I'll keep your original logic:
      Get.offNamed('/Dashboard'); // Original: Navigates to Dashboard (perhaps for a specific section or reset)
    } else if (index == 2) {
      Get.offNamed('/camera');
    }
    // Add more cases if your bottom navigation has more items
  }

  // Moved _buildStatisticCard inside the State class
  Widget _buildStatisticCard(String value, String label) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 3,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.poppins(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final controller = Get.find<AuthController>(); // Still finding here is fine if MyDrawer or AppBar actions use it.
    // If not used directly in this build method's UI, could be removed from here.

    // Data fetching is now in initState and onRefresh
    // WidgetsBinding.instance.addPostFrameCallback((_) { // REMOVE THIS
    //   appointmentController.getUpcomingAppointments();
    //   attendanceController.checkShiftStatus();
    // });

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
          _fetchData(); // Call the new method
          // The delay is optional, usually for UX to show the indicator for a moment
          await Future.delayed(const Duration(seconds: 1));
        },
        child: Obx(() {
          return Column( // This is the Main Column
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
                                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
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
                                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
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
              // Upcoming Appointment & Statistics Section
              Expanded( // Wrap this section in Expanded to allow inner GridView to expand
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0), // Adjusted padding
                  child: Column( // This is the Inner Column for this section
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Appointment Statistics',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                            ),
                          ),
                          DropdownButton<String>(
                            value: selectedFilter,
                            items: <String>['This Month', 'This Week', 'Today']
                                .map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  selectedFilter = newValue;
                                  // TODO: Add logic to refetch/filter statistics based on newValue
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Statistics Cards
                      Expanded( // This Expanded will now work correctly
                        child: GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 2.5, // Adjust if necessary based on available height
                          children: [
                            _buildStatisticCard('152', 'Completed'), // Replace with actual data
                            _buildStatisticCard('50', 'Cancelled'),   // Replace with actual data
                            _buildStatisticCard('80%', 'Accuracy'),  // Replace with actual data
                            _buildStatisticCard('0', 'Other'),        // Replace with actual data
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // --- Commented out Appointments List ---
              // If you uncomment this, ensure it's also wrapped in Expanded if it's meant
              // to share space with the section above. If it's meant to make the whole
              // page scroll longer, then the GridView above should not be Expanded,
              // or it should have a fixed height (e.g. using SizedBox or Container).
              // For now, assuming the GridView section takes the remaining space.

              // Text(
              //   "Your Upcoming Appointments",
              //   style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.w600),
              // ),
              // appointmentController.isLoading.value
              //     ? const Center(child: CircularProgressIndicator())
              //     : appointmentController.upcomingAppointments.isEmpty
              //     ? const Padding(
              //   padding: EdgeInsets.all(16.0),
              //   child: Text("No upcoming appointments."),
              // )
              //     : Expanded( // If uncommented, this Expanded shares space with the one above
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: ListView.builder(
              //       physics: const AlwaysScrollableScrollPhysics(),
              //       itemCount: appointmentController.upcomingAppointments.length,
              //       itemBuilder: (context, index) {
              //         return Padding(
              //           padding: const EdgeInsets.symmetric(vertical: 4.0),
              //           child: UpcomingCard( // Make sure UpcomingCard widget is defined and imported
              //             upcomingAppointment:
              //             appointmentController.upcomingAppointments[index],
              //           ),
              //         );
              //       },
              //     ),
              //   ),
              // ),
              // --- End of commented out Appointments List ---
            ],
          ); // End of Main Column
        }), // End of Obx
      ), // End of RefreshIndicator
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    ); // End of Scaffold
  }
}