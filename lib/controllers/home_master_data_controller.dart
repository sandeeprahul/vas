import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class HomeMasterDataController extends GetxController {
  final ApiService apiService = ApiService();

  RxBool isLoading = false.obs;
  RxDouble progress = 0.0.obs; // Progress tracker (0 to 1)
  RxMap<String, String> lastDownloadTime = <String, String>{}.obs; // Stores last downloaded time

  String? deptId, userId, zoneId, empId; // User details

  @override
  void onInit() {
    super.onInit();
    _loadUserData(); // Load user details from SharedPreferences
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = "0";
    // userId = prefs.getString("userId");
    deptId = "3";
    // deptId = prefs.getString("deptId");
    zoneId = "0";
    // zoneId = prefs.getString("zoneId");
    // empId = "0";
    empId = prefs.getString("employeeId");

    if (userId != null && deptId != null && zoneId != null && empId != null) {
      print('_loadUserData');
      print('has data');


      loadLastDownloadTimes(); // Load last download times from SharedPreferences
      fetchData(); // Fetch data only if not previously downloaded
    }else{
      print('no data');
    }
  }
  Future<void> loadApiHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, String>> history = [];

    for (String endpoint in apiEndpoints) {
      String? lastTime = prefs.getString("lastDownload_$endpoint");
      history.add({
        "endpoint": endpoint,
        "lastDownloaded": lastTime ?? "Never Downloaded"
      });
    }

    apiDownloadHistory.assignAll(history);
  }
  RxList<Map<String, String>> apiDownloadHistory = <Map<String, String>>[].obs;

  final List<String> apiEndpoints = [
    "/GetEventTypes",
    "/GetDenialTypes/userId",
    "/GetIncidentTypes",
    "/GetGeneralSettings/userId",
    "gethospitals/deptId/zoneId/emplId/10/1"
  ];
  Future<void> fetchData() async {
    isLoading.value = true;
    progress.value = 0.0;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = "0";
    // userId = prefs.getString("userId");
    deptId = "3";
    // deptId = prefs.getString("deptId");
    zoneId = "0";
    // zoneId = prefs.getString("zoneId");
    // empId = "0";
    empId = prefs.getString("employeeId");
    // String? userId = prefs.getString("employeeId");
    // String? deptId = prefs.getString("deptId");
    // String? zoneId = prefs.getString("zoneId");
    // String? empId = prefs.getString("empId");

    if (userId == null || deptId == null || zoneId == null || empId == null) {
      isLoading.value = false;
      return;
    }

    List<String> resolvedEndpoints = [
      "/GetEventTypes",
      "/GetDenialTypes/$userId",
      "/GetIncidentTypes",
      "/GetGeneralSettings/$userId",
      "gethospitals/$deptId/$zoneId/$empId/10/1"
    ];

    for (int i = 0; i < resolvedEndpoints.length; i++) {
      await apiService.getRequest(resolvedEndpoints[i]); // Call API

      // Store last download time
      String now = DateTime.now().toLocal().toString();
      await prefs.setString("lastDownload_${apiEndpoints[i]}", now);

      // Update progress
      progress.value = (i + 1) / totalApis;
    }

    await loadApiHistory(); // Load saved times
    isLoading.value = false;
  }
  final int totalApis = 5; // Total API requests

  Future<void> loadLastDownloadTimes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> apiEndpoints = [
      "/GetEventTypes",
      "/GetDenialTypes/$userId",
      "/GetIncidentTypes",
      "/GetGeneralSettings/$userId",
      "/gethospitals/$deptId/$zoneId/$empId/10/1",
    ];

    for (String endpoint in apiEndpoints) {
      lastDownloadTime[endpoint] = prefs.getString("lastDownload_$endpoint") ?? "Not downloaded";
    }
  }
}
