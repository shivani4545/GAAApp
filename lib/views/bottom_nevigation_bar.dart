import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'camera.dart';
import 'camera_screen.dart';// Import the CameraPage

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
          if (index == 1) { // Camera button
            Get.to(() => ImageUploadScreen()); // Use Get.to() to navigate
          } else {
            onItemTapped(index); // Handle other tabs
          }
        },
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.home),
            title: const Text("Home"),
            selectedColor: const Color(0xff171433),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.camera_alt),
            title: const Text("Camera"),
            selectedColor: const Color(0xff171433),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.person),
            title: const Text("Profile"),
            selectedColor: const Color(0xff171433),
          ),
        ],
      ),
    );
  }
}