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
        child:  Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(36),

                        child: Image.asset('assets/logo_vas.jpeg',scale: 7,))/*const Icon(
                      Icons.emergency,
                      size: 80,
                      color: Colors.white,
                    ),*/
                  ),
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
                  const SizedBox(height: 8),

                  Text(
                    'Version:1.0',
                    style: TextStyle(fontSize: 12,color: Colors.white,fontWeight: FontWeight.w600),
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
