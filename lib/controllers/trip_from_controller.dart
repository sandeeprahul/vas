import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:vas/controllers/ambulance_controller.dart';
import 'package:vas/controllers/blocks_controller.dart';
import 'package:vas/controllers/districts_controller.dart';
import 'package:vas/controllers/location_type_controller.dart';
import 'package:vas/controllers/user_controller.dart';
import 'package:vas/utils/showDialogNoContext.dart';
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
    // showLoadingDialog();
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
        "doctor_ID": "23",
        // "doctor_ID": selectedDoctorId.value,
        "zone_ID": districtsController.selectedDistrictId.value,
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

      //Response
      //{result: 1, message: Trip created, trip_ID: 25021900001, start_Time: 2025-02-19 23:53:22}
      //sending payload
      // {depT_ID: 3, user_ID: 1888, driver_ID: 819, doctor_ID: 23,
      // zone_ID: 3, block_ID: 22, location_ID: 43190, address: ,
      // vehicle_ID: 3, base_KM: 2.0, latitude: 16.470866, longitude: 80.6065381,
      // device_Regn_ID: , imeI_Number: 0, os_Version: 13}

      print("Submitting Form Data: $formData");

      // Make API POST request
      final response = await apiService.postRequest("/StartTrip", formData);

      if (response != null) {
        isLoading.value = false;
        // hideLoadingDialog();

        print("Form submitted successfully: $response");
        // Form submitted successfully: {result: 0, message: Vehicle already on an emergency trip, trip_ID: 0, start_Time: null}
        // Handle success (e.g., show success message, navigate, etc.)

        if (response['result'] == "1") {
          clearAllFields();
          showErrorDialog('Alert', "${response["message"]}");
          Get.back(); // Closes the current page
        } else {
          showErrorDialog('Alert', "${response["message"]}");
          // clearAllFields();
        }
      } else {
        print("Failed to submit form:$response");
        // Handle failure (e.g., show error message)
        showErrorDialog('Failure', "Trip Start Failed");
      }
      // TODO: Implement API POST request here
    } catch (e) {
      // isLoading.value = false;
      print("Submitting Form Error: $e");
      showErrorDialog('Failure', "$e");
    } finally {
      isLoading.value = false;
      // hideLoadingDialog();
    }
  }

  void clearAllFields() {
    final locationTypeController = Get.find<LocationTypeController>();
    final locationSubTypeController = Get.find<LocationSubTypeController>();

    final ambulanceController = Get.find<AmbulanceController>();
    final blocksController = Get.find<BlocksController>();
    final districtsController = Get.find<DistrictsController>();
    selectedDriverId.value = "";
    selectedDriver.value = "Select Driver";
    selectedDoctorId.value = "";
    selectedDoctor.value = "Select Doctor";
    selectedBlockId.value = "";
    selectedBlock.value = "Select Block";
    baseOdometerController.text = "";
    locationSubTypeController.selectedLocationName.value = "Select Location";
    locationSubTypeController.selectedLocationId.value = "";
    locationTypeController.selectedLocationType.value = "Select LocationType";
    locationTypeController.selectedLocationTypeId.value = "";
    ambulanceController.selectedAmbulanceId.value = "";
    ambulanceController.selectedAmbulanceName.value = "Select Ambulance";
    blocksController.selectedBlockId.value = "";
    blocksController.selectedBlock.value = "Select Block";
    districtsController.selectedDistrictId.value = "";
    districtsController.selectedDistrict.value = "Select District";

    print("All fields have been cleared.");
  }
}
