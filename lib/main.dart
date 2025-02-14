
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vas/screens/splash_screen.dart';
import 'package:vas/theme.dart';

import 'controllers/login_controller.dart';
import 'controllers/theme_controller.dart';
import 'screens/case_registration_new_screen.dart';
import 'screens/login_screen.dart';
import 'screens/manage_trip_screen.dart';
import 'screens/master_data_screen.dart';

void main() {
  // Set status bar color
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.blue, // Change status bar color
    statusBarIconBrightness: Brightness.light, // Change icon color (light or dark)
  ));
  // Get.put(LoginController());

  runApp(MyApp());
}


class MyApp extends StatelessWidget {

  // const MyApp({super.key});
  final ThemeController themeController = Get.put(ThemeController());

  // const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(() => GetMaterialApp(
      debugShowCheckedModeBanner: false,
      // title: 'Flutter Theme Demo',
      theme: AppThemes.light,
      darkTheme: AppThemes.dark,
      themeMode: themeController.theme,
      home:  SplashScreen(),
      routes: {
        '/manage_trip': (context) => ManageTripScreen(), // Define route
        '/case_registration_new': (context) => CaseRegistrationNewScreen(), // Define route
        '/master_data_screen': (context) =>  MasterDataScreen(), // Define route
      },
    ));
  }
  // @override
  // Widget build(BuildContext context) {
  //   return GetMaterialApp(
  //     debugShowCheckedModeBanner: false,
  //     theme: ThemeData(
  //       useMaterial3: true,
  //       colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
  //     ),
  //     home: LoginScreen(),
  //     routes: {
  //       '/manage_trip': (context) => ManageTripScreen(), // Define route
  //       '/case_registration_new': (context) => CaseRegistrationNewScreen(), // Define route
  //       '/master_data_screen': (context) => const MasterDataScreen(), // Define route
  //     },
  //   );
  // }
}
