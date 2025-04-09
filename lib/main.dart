
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vas/screens/manage_trip_arrival_departure_close_screen.dart';
import 'package:vas/screens/manage_trip_screen.dart';
import 'package:vas/screens/form_temp.dart';
import 'package:vas/screens/home_screen.dart';
import 'package:vas/screens/splash_screen.dart';
import 'package:vas/theme.dart';

import 'controllers/login_controller.dart';
import 'controllers/theme_controller.dart';
import 'screens/case_registration_new_screen.dart';
import 'screens/login_screen.dart';
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
        // '/manage_trip': (context) => ManageTripScreen(), // Define route
        '/home': (context) => HomeScreen(), // Define route
        '/login': (context) => const LoginScreen(), // Define route
        '/manage_trip': (context) => const ManageTripScreen(), // Define route
        '/case_registration_new': (context) => const CaseRegistrationNewScreen(), // Define route
        '/master_data_screen': (context) =>  const MasterDataScreen(fromLogin: false,), // Define route
        '/manage_trip_arrival_departure_close_screen': (context) =>   const ManageTripArrivalDepartureCloseScreen(), // Define route
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
