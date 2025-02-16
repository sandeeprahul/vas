import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../shared_pref_helper.dart';

class FormController extends GetxController {
  // Loading state
  final RxBool isLoading = false.obs;

  // Selected values for dropdowns
  // final RxString selectedDistrict = 'Select District'.obs;
  // final RxString selectedDistrictId = ''.obs; // ✅ Stores districtId for submission

  final RxString selectedBlock = 'Select Block'.obs;
  final RxString selectedBlockId = ''.obs; // ✅ Stores districtId for submission

  final RxString selectedDoctor = 'Select Doctor'.obs;
  final RxString selectedDoctorId = ''.obs; // ✅ Stores districtId for submission

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
      doctors.value = (doctorData is List && doctorData.isNotEmpty && doctorData[0] is Map<String, dynamic>)
          ? doctorData[0]['doctorData'] ?? []
          : [];

      // Load drivers
      var driverData = await SharedPrefHelper.getApiData('/GetDrivers');
      drivers.value = (driverData is List && driverData.isNotEmpty && driverData[0] is Map<String, dynamic>)
          ? driverData[0]['driverData'] ?? []
          : [];

    } catch (e) {
      print("Error loading last synced data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Submits form data to the backend
  void submitForm() {
    final Map<String, dynamic> formData = {
      "depT_ID": 0,
      "user_ID": 0,
      "driver_ID": selectedDriver.value,
      "doctor_ID": selectedDoctor.value,
      "zone_ID": 0,
      "block_ID": selectedBlock.value,
      "location_ID": 0,
      "address": "string",
      "vehicle_ID": ambulanceController.text,
      "base_KM": baseOdometerController.text,
      "latitude": 0,
      "longitude": 0,
      "device_Regn_ID": "string",
      "imeI_Number": "string",
      "os_Version": "string"
    };

    print("Submitting Form Data: $formData");
    // TODO: Implement API POST request here
  }
}
