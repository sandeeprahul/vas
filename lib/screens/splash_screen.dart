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

    /// Check login status after 3 seconds
     Future.delayed(const Duration(seconds: 3), () {
      loginController.checkLoginStatus();
    });

    return Scaffold(
      backgroundColor: Colors.white, // Change to match your theme
      body: Container(
        decoration:  BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppThemes.light.primaryColor,
              Colors.black,
              Colors.black,
              // Colors.blue,
              // Colors.white,
            ],
          ),
        ),
        child: const Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '1962',
                    style: TextStyle(fontSize: 44, fontWeight: FontWeight.w600,color: Colors.white),
                  ), Text(
                    'MVU APP',
                    style: TextStyle(fontSize: 42, fontWeight: FontWeight.w600,color: Colors.white),
                  ),
                  SizedBox(height: 12,),
                  Text(
                    'Powered By',
                    style: TextStyle(fontSize: 14,color: Colors.white),
                  ),
                  Text(
                    'BHSPL',
                    style: TextStyle(fontSize: 14,color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
