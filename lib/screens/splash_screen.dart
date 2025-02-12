import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Initialize LoginController only here
    final LoginController loginController = Get.put(LoginController());

    // Check login status after 2 seconds
    Future.delayed(Duration(seconds: 2), () {
      loginController.checkLoginStatus();
    });

    return Scaffold(
      backgroundColor: Colors.white, // Change to match your theme
      body: Center(
        child: Image.asset(
          'assets/vas_logo.png', // Make sure this image exists in assets
          width: 200,
          height: 200,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
