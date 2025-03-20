import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gaa_adv/controllers/auth_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});
  logOut() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
    // ignore: deprecated_member_use
    sharedPreferences.commit();
    Get.offAll(() => const LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isTablet = size.width > 600;
    return Drawer(
      //backgroundColor: Colors.whiteColor,
      child: ListView(
        children: [
          DrawerHeader(
            child: SizedBox(
                child: Container(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Image.asset("assets/images/logo.png",
                              height:isTablet ? size.height * .05 : size.height * .08),
                          const SizedBox(width: 20),
                          Text(
                            "GAA",
                            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                )),
          ),
          ListTile(
            leading: const Icon(
              Icons.dashboard,
              color: Color(0xFFF9CB47),
            ),
            title: Text(
              'Dashboard',
              style: GoogleFonts.poppins(),
            ),
            onTap: () {
              Get.back();
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.speaker_notes_sharp,
              color: Color(0xFFF9CB47),
            ),
            title: Text(
              'Menu',
              style: GoogleFonts.poppins(),
            ),
            onTap: () {
              Get.toNamed('dashboard'); // Navigate to the '/dashboard' route.
            },
          ),
          ListTile(
            onTap: () {
              Get.defaultDialog(
                  title: "Log Out ?",
                  content: const Text("Are you sure,You want to log out ?"),
                  textConfirm: "YES",
                  textCancel: "NO",
                  buttonColor: const Color(0xFFF9CB47),
                  confirmTextColor: Colors.white,
                  onConfirm: () async {
                    await logOut();
                    Get.back();
                  },
                  onCancel: () {
                    Get.back();
                  });
            },
            leading: const Icon(
              Icons.logout,
             color: Color(0xFFF9CB47),
            ),
            title: Text(
              'Log Out',
              style: GoogleFonts.poppins(),
            ),
          )
        ],
      ),
    );
  }
}