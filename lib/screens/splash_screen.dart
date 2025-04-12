import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import '../theme.dart';

///trip id new 25040500001
///
///

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize LoginController only here
    final LoginController loginController = Get.put(LoginController());

    // Check login status after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      loginController.checkLoginStatus();
    });

    return Scaffold(
      backgroundColor: Colors.white, // Change to match your theme
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue,
              Colors.white,
            ],
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('VAS',style: TextStyle(fontSize: 66,fontWeight: FontWeight.w600),),
              Text('Powered By',style: TextStyle(fontSize: 14),),
              Text('BHY',style: TextStyle(fontSize: 14),),
            ],
          ),
        ),
      ),
    );
  }
}


