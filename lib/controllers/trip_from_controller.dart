import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:vas/controllers/ambulance_controller.dart';
import 'package:vas/controllers/blocks_controller.dart';
import 'package:vas/controllers/districts_controller.dart';
import 'package:vas/controllers/location_type_controller.dart';
import 'package:vas/controllers/user_controller.dart';
import '../services/api_service.dart';
import '../shared_pref_helper.dart';
import '../utils/showLoadingDialog.dart';
import 'location_sub_type_controller.dart';

class FormController extends GetxController {
  // Loading state
  final RxBool isLoading = false.obs;
  final ApiService apiService = ApiService();

  // Selected values for dropdowns
  // final RxString selectedDistrict = 'Select District'.obs;
  // final RxString selectedDistrictId = ''.obs; // ✅ Stores districtId for submission

  final RxString selectedBlock = 'Select Block'.obs;
  final RxString selectedBlockId = ''.obs; // ✅ Stores districtId for submission

  final RxString selectedDoctor = 'Select Doctor'.obs;
  final RxString selectedDoctorId =
      ''.obs; // ✅ Stores districtId for submission

  final RxString selectedDriver = 'Select Driver'.obs;
  final RxString selectedDriverId = ''.obs;

  // Input controllers
  final TextEditingController ambulanceController = TextEditingController();
  TextEditingController baseOdometerController = TextEditingController();

  // Data lists
  final RxList<dynamic> districts = <dynamic>[].obs;
  final RxList<dynamic> blocks = <dynamic>[].obs;
  final RxList<dynamic> doctors = <dynamic>[].obs;
  final RxList<dynamic> drivers = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadLastSyncedData();
  }

  /// Loads last synced API data from SharedPreferences
  Future<void> loadLastSyncedData() async {
    isLoading.value = true;
    try {
      // Load districts
      // var districtData = await SharedPrefHelper.getApiData('/GetDistricts');
      // districts.value = (districtData is List) ? districtData : [];

      // Load blocks
      var blockData = await SharedPrefHelper.getApiData('/GetBlocks');
      blocks.value = (blockData is List) ? blockData : [];

      // Load doctors
      var doctorData = await SharedPrefHelper.getApiData('/GetDoctors');
      doctors.value = (doctorData is List &&
              doctorData.isNotEmpty &&
              doctorData[0] is Map<String, dynamic>)
          ? doctorData[0]['doctorData'] ?? []
          : [];

      // Load drivers
      var driverData = await SharedPrefHelper.getApiData('/GetDrivers');
      drivers.value = (driverData is List &&
              driverData.isNotEmpty &&
              driverData[0] is Map<String, dynamic>)
          ? driverData[0]['driverData'] ?? []
          : [];
    } catch (e) {
      print("Error loading last synced data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Submits form data to the backend
  Future<void> submitForm() async {
    isLoading.value = true;
    showLoadingDialog();
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      UserController userController = Get.put(UserController());
      LocationSubTypeController locationSubTypeController =
          Get.put(LocationSubTypeController());
      LocationTypeController locationTypeController =
          Get.put(LocationTypeController());
      AmbulanceController ambulanceController = Get.put(AmbulanceController());
      BlocksController blocksController = Get.put(BlocksController());
      DistrictsController districtsController = Get.put(DistrictsController());
      final Map<String, dynamic> formData = {
        "depT_ID": userController.deptId.value,
        "user_ID": userController.userId.value,
        "driver_ID": selectedDriverId.value,
        "doctor_ID": selectedDoctorId.value,
        "zone_ID":districtsController.selectedDistrictId.value ,
        "block_ID": blocksController.selectedBlockId.value,
        "location_ID": locationSubTypeController.selectedLocationId.value,
        "address": "",
        "vehicle_ID": ambulanceController.selectedAmbulanceId.value,
        // "base_KM": "",
        "base_KM": baseOdometerController.value.text,
        "latitude": position.latitude,
        "longitude": position.longitude,
        "device_Regn_ID": userController.deviceRegnId.value,
        "imeI_Number": userController.imeiNumber.value,
        "os_Version": "13"
      };

      print("Submitting Form Data: $formData");

      // Make API POST request
      final response = await apiService.postRequest("/StartTrip", formData);

      if (response != null) {
        print("Form submitted successfully: $response");
        // Handle success (e.g., show success message, navigate, etc.)
      } else {
        print("Failed to submit form:$response");
        // Handle failure (e.g., show error message)
      }

      // TODO: Implement API POST request here
    } catch (e) {
      // isLoading.value = false;
      print("Submitting Form Error: $e");

    } finally {
      isLoading.value = false;
      hideLoadingDialog();

    }
  }

}
