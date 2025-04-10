import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FuelEntryController extends GetxController {
  // Text controllers
  final TextEditingController petroCardController = TextEditingController();
  final TextEditingController serviceTypeController = TextEditingController();
  final TextEditingController onDutyStaffController = TextEditingController();
  final TextEditingController lastDutyCloseKmController = TextEditingController();

  // Dropdown selections
  RxString selectedAmbulanceName = "Ambulance".obs;
  RxString selectedAmbulanceId = "".obs;
  RxList<dynamic> ambulanceList = <dynamic>[].obs;

  RxString selectedDistrict = "District".obs;
  RxString selectedDistrictId = "".obs;
  RxList<dynamic> districtsList = <dynamic>[].obs;

  RxString selectedBlock = "Block".obs;
  RxString selectedBlockId = "".obs;
  RxList<dynamic> blocksList = <dynamic>[].obs;

  RxString selectedLocationType = "Location".obs;
  RxString selectedLocationTypeId = "".obs;
  RxList<dynamic> locationTypes = <dynamic>[].obs;



  // You may want to clear/reset on new entry
  void resetFields() {
    selectedAmbulanceName.value = "Ambulance";
    selectedAmbulanceId.value = "";

    selectedDistrict.value = "District";
    selectedDistrictId.value = "";

    selectedBlock.value = "Block";
    selectedBlockId.value = "";

    selectedLocationType.value = "Location";
    selectedLocationTypeId.value = "";

    petroCardController.clear();
    serviceTypeController.clear();
    onDutyStaffController.clear();
    lastDutyCloseKmController.clear();
  }

  @override
  void onClose() {
    petroCardController.dispose();
    serviceTypeController.dispose();
    onDutyStaffController.dispose();
    lastDutyCloseKmController.dispose();
    super.onClose();
  }
}
