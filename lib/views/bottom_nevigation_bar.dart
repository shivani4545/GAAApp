

import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

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
            onItemTapped(index); // Home or other future tabs
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
