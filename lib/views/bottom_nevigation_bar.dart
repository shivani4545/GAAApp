// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
// import 'camera.dart';
// import 'camera_screen.dart';
// import 'dashboard.dart';// Import the CameraPage
//
// class CustomBottomNavigationBar extends StatelessWidget {
//   final int selectedIndex;
//   final Function(int) onItemTapped;
//
//   const CustomBottomNavigationBar({
//     Key? key,
//     required this.selectedIndex,
//     required this.onItemTapped,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: const Color(0xFFF9CB47).withOpacity(0.7),
//       ),
//       child: SalomonBottomBar(
//         currentIndex: selectedIndex,
//         onTap: (index) {
//           if (index == 1) { // Camera button
//             Get.to(() => const Dashboard()); // Use Get.to() to navigate
//           } else {
//             onItemTapped(index); // Handle other tabs
//           }
//         },
//         items: [
//           SalomonBottomBarItem(
//             icon: const Icon(Icons.home),
//             title: const Text("Home"),
//             selectedColor: const Color(0xff171433),
//           ),
//           SalomonBottomBarItem(
//             icon: const Icon(Icons.camera_alt),
//             title: const Text("Dashboard"),
//             selectedColor: const Color(0xff171433),
//           ),
//           // SalomonBottomBarItem(
//           //   icon: const Icon(Icons.person),
//           //   title: const Text("Profile"),
//           //   selectedColor: const Color(0xff171433),
//           // ),
//         ],
//       ),
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
// class CustomBottomNavigationBar extends StatelessWidget {
//   final int selectedIndex;
//   final Function(int) onItemTapped;
//
//   const CustomBottomNavigationBar({
//     Key? key,
//     required this.selectedIndex,
//     required this.onItemTapped,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: const Color(0xFFF9CB47).withOpacity(0.7),
//       ),
//       child: SalomonBottomBar(
//         currentIndex: selectedIndex,
//         onTap: (index) {
//           onItemTapped(index);
//         },
//         items: [
//           /// Home
//           SalomonBottomBarItem(
//             icon: const Icon(Icons.home),
//             title: const Text("Home"),
//             selectedColor: const Color(0xff171433),
//           ),
//
//           /// Dashboard
//           SalomonBottomBarItem(
//             icon: const Icon(Icons.dashboard),
//             title: const Text("Appointment"),
//             selectedColor: const Color(0xff171433),
//           ),
//
//           /// Menu
//           SalomonBottomBarItem(
//             icon: const Icon(Icons.menu),
//             title: const Text("Menu"),
//             selectedColor: const Color(0xff171433),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:gaa_adv/views/upcoming_card.dart';
import 'package:get/get.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'dashboard.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9CB47).withOpacity(0.7),
      ),
      child: SalomonBottomBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          if (index == 1) {
            // Dashboard
            Get.to(() => const Dashboard());
          } else if (index == 2) {
            // Upcoming Appointment
            Get.to(() => const UpcomingCard());
          } else {
            onItemTapped(index); // Home or other future tabs
          }
        },
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.home),
            title: const Text("Home"),
            selectedColor: const Color(0xff171433),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.dashboard),
            title: const Text("Dashboard"),
            selectedColor: const Color(0xff171433),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.calendar_today),
            title: const Text("Appointments"),
            selectedColor: const Color(0xff171433),
          ),
        ],
      ),
    );
  }
}
