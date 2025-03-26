
import 'package:flutter/material.dart';
import 'package:gaa_adv/controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {  // Make it stateful
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();  // Find the controller

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Background Circles (unchanged)
          Positioned(
            top: -50,
            left: -60,
            child: CircleAvatar(
              radius: 100,
              backgroundColor: const Color(0xFFF9CB47).withOpacity(0.7),
            ),
          ),
          Positioned(
            top: -60,
            left: 20,
            child: CircleAvatar(
              radius: 90,
              backgroundColor: const Color(0xFFF9CB47).withOpacity(0.5),
            ),
          ),
          Positioned(
            bottom: -50,
            right: -60,
            child: CircleAvatar(
              radius: 100,
              backgroundColor: const Color(0xFFF9CB47).withOpacity(0.7),
            ),
          ),
          Positioned(
            bottom: -60,
            right: 20,
            child: CircleAvatar(
              radius: 90,
              backgroundColor: const Color(0xFFF9CB47).withOpacity(0.5),
            ),
          ),
          // Content
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 60.0),
              child: Obx(() => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 0.0, bottom: 10.0),
                    child: Center(
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 60,
                        height: 60,
                      ),
                    ),
                  ),
                  // Title and Subtitle
                  Text(
                    "Login To Continue",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),
                  Text(
                    "Enter your email",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email),
                      hintText: "Enter Email",
                      hintStyle: const TextStyle(fontSize: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Enter Password",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    controller: passwordController,
                    obscureText: !controller.passwordVisible.value,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock),
                      hintText: "Enter Password",
                      hintStyle: const TextStyle(fontSize: 14),
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.passwordVisible.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          controller.passwordVisible.value =
                          !controller.passwordVisible.value;
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        // Handle forgot password
                      },
                      child: Text(
                        "Forgot Password?",
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: controller.isLoginLoading.value
                        ? null  // Disable the button while loading
                        : () async {
                      if (emailController.text.isEmpty) {
                        Get.snackbar(
                            "Missing Details", "Please Enter Email",
                            duration: const Duration(seconds: 3));
                      } else if (passwordController.text.isEmpty) {
                        Get.snackbar(
                            "Missing Details", "Please Enter Password",
                            duration: const Duration(seconds: 3));
                      } else {
                        await controller.login(
                            emailController.text,
                            passwordController.text); // Await the login call
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      const Color(0xFFF9CB47).withOpacity(0.7),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: controller.isLoginLoading.value
                        ? const CircularProgressIndicator()
                        : const Text(
                      "Sign in",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              )),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}