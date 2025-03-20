import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'bottom_nevigation_bar.dart';
import 'drawer.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int selectedIndex = 2; // Select Profile item

  void _onItemTapped(int index) {
    if (index == 0) {
      Get.offNamed('/dashboard'); // Navigate to dashboard
    } else if (index == 1) {
      Get.offNamed('/menu'); // Navigate to menu
    } else if (index == 2) {
      // Stay on Profile (already here)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: const Color(0xFFF9CB47).withOpacity(0.5),
        ),
        backgroundColor: const Color(0xFFF9CB47).withOpacity(0.7),
        title: const Text('Profile'),
      ),
      body: const Center(
        //child: Text('Profile Content'),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}