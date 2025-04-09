import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vas/controllers/user_controller.dart';
import 'package:vas/screens/login_screen.dart';
import 'package:vas/screens/master_data_screen.dart';
import 'package:vas/utils/showDialogNoContext.dart';
import '../screens/dashboard_page.dart';
import '../screens/home_screen.dart';
import 'package:http/http.dart' as http;

import '../services/api_service.dart';


class LoginController extends GetxController {

  final ApiService apiService = ApiService();

  // Controllers for username & password input fields
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final UserController userController = Get.put(UserController());

  var isLoading = false.obs; // Observable loading state
  @override
  void onClose() {
    // Dispose controllers when not needed
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    print("token");
    print(token);
    if (token != null) {
      // var time = DateTime.now();
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // await prefs.setString("loggedInTime", time.toString());
      // Get.offAllNamed("/home"); // Auto-login if token exists
      Get.offAll(HomeScreen()); // Auto-login if token exists

    } else {
      // Get.offAllNamed("/login");
      Get.offAll(const LoginScreen()); // Auto-login if token exists
    }
  }
  Future<void> logoutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear stored data
    Get.offAllNamed("/login");
  }

  Future<void> loginUserSandBox() async {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      showErrorDialog("Error", 'Username and password cannot be empty');
      return;
    }

    isLoading.value = true;

    await Future.delayed(const Duration(seconds: 2)); // Simulating API delay

    final response = {
      "clientId": "0",
      "employeeId": "462",
      "imeiNumber": "ABC123456789",
      "deviceRegnId": "XYZ987654321",
      "name": "Doctor",
      "roleId": "2",
      "deptId": "5",
      "zoneId": "3",
      "accountId": "99999",
      "result": "600",
      "message": "Login Successful",
      "timerLocationData": "30",
      "blockId": "10",
      "stopId": "15",
      "vehicleId": "VH123",
      "loadGeneralSettings": "true",
      "token": "mock_token_123456"
    };

    isLoading.value = false;

    if (response["result"] == "600") {
      var time = DateTime.now();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", response["token"]??'');
      await prefs.setString("employeeId", response["employeeId"]??'');
      await prefs.setString("userId", response["employeeId"]??'');
      await prefs.setString("name", response["name"]??'');
      await prefs.setString("roleId", response["roleId"]??'');
      await prefs.setString("deptId", response["deptId"]??'');
      await prefs.setString("zoneId", response["zoneId"]??'');
      await prefs.setString("accountId", response["accountId"]??'');
      await prefs.setString("clientId", response["clientId"]??'');
      await prefs.setString("blockId", response["blockId"]??'');
      await prefs.setString("stopId", response["stopId"]??'');
      await prefs.setString("loadGeneralSettings", response["loadGeneralSettings"]??'');
      await prefs.setString("vehicleId", response["vehicleId"]??'');
      await prefs.setString("timerLocationData", response["timerLocationData"]??'');
      await prefs.setString("imeiNumber", response["imeiNumber"]??'');
      await prefs.setString("deviceRegnId", response["deviceRegnId"]??'');
      await prefs.setString("loggedInTime", time.toString());
      userController.saveUserData(response);


      Get.offAll(const MasterDataScreen(fromLogin: true)); // Auto-login if token exists
    } else {
      showErrorDialog("Error", response["message"] ?? "Login failed");
    }
  }

  Future<void> loginUser() async {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar("Error", "Username and password cannot be empty");
      showErrorDialog("Error", 'Username and password cannot be empty'); // ✅ Use dialog instead of snackbar

      return;
    }

    isLoading.value = true;

    final data = {
      "userName": usernameController.text,
      "password": passwordController.text,
      "otp": "" // Keep empty for now
    };

    final response = await apiService.postRequest("/Login", data);

    isLoading.value = false;

    if (response != null && response["result"] == "600") {
      var time = DateTime.now();

      // Save login data to SharedPrefer
      // ences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", response["token"]??'');
      await prefs.setString("employeeId", response["employeeId"]??'');
      await prefs.setString("userId", response["employeeId"]??'');
      await prefs.setString("name", response["name"]??'');
      await prefs.setString("roleId", response["roleId"]??'');
      await prefs.setString("deptId", response["deptId"]??'');
      await prefs.setString("zoneId", response["zoneId"]??'');
      await prefs.setString("accountId", response["accountId"]??'');
      await prefs.setString("clientId", response["clientId"]??'');
      await prefs.setString("blockId", response["blockId"]??'');
      await prefs.setString("stopId", response["stopId"]??'');
      await prefs.setString("loadGeneralSettings", response["loadGeneralSettings"]??'');
      await prefs.setString("vehicleId", response["vehicleId"]??'');
      await prefs.setString("timerLocationData", response["timerLocationData"]??'');
      await prefs.setString("imeiNumber", response["imeiNumber"]??'');
      await prefs.setString("deviceRegnId", response["deviceRegnId"]??'');
      await prefs.setString("loggedInTime", time.toString());
      userController.saveUserData(response);

      // Get.snackbar("Success", "Login Successful");
      // Get.offAllNamed("/home"); // Navigate to home screen
      Get.offAll(const MasterDataScreen(fromLogin: true)); // Auto-login if token exists
      // Get.offAll(HomeScreen()); // Auto-login if token exists


    } else {
      showErrorDialog("Error", response?["message"] ?? "Login failed"); // ✅ Use dialog instead of snackbar
    }
  }
}
