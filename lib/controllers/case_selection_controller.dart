// lib/controllers/case_selection_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vas/controllers/user_controller.dart';
import 'package:vas/services/api_service.dart';

import '../models/case_model.dart';
import 'ambulance_controller.dart';

class CaseSelectionController extends GetxController {
  final selectedDoctor = ''.obs;
  final selectedDriver = ''.obs;
  final selectedVehicle = ''.obs;
  final selectedVehicleId = ''.obs;
  final cases = <CaseModel>[].obs;
  final selectedCase = Rxn<CaseModel>();
  RxBool isLoading = false.obs;
  final doctors = <String>[].obs;
  final drivers = <String>[].obs;
  final vehicles = <String>[].obs;
  final AmbulanceController ambulanceController =
      Get.put(AmbulanceController());

  ApiService apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    isLoading.value = true;
    try {
      // Fetch doctors

      await ambulanceController.getAmbulances();

      /*  final doctorsResponse = await apiService.getRequest("/GetDoctors");
      if (doctorsResponse != null) {
        doctors.value = List<String>.from(doctorsResponse['data'].map((doc) => doc['name'].toString()));
      }*/

      // Fetch drivers
      /*  final driversResponse = await apiService.getRequest("/GetDrivers");
      if (driversResponse != null) {
        drivers.value = List<String>.from(driversResponse['data'].map((driver) => driver['name'].toString()));
      }
*/
      // Fetch vehicles
      /*  final vehiclesResponse = await apiService.getRequest("/GetVehicles");
      if (vehiclesResponse != null) {
        vehicles.value = List<String>.from(vehiclesResponse['data'].map((vehicle) => "${vehicle['district']} - ${vehicle['number']}"));
      }*/
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load initial data',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchCases() async {
    if (selectedVehicle.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select a vehicle first',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    UserController userController = Get.put(UserController());

    try {
      // Replace with your actual API endpoint and parameters
      final response = await apiService.postRequest(
        '/GetEmergencyCase',
        {
          "vehicleId": selectedVehicleId.value,
          // "depT_ID": userController.deptId.value,
          "userId": userController.userId.value,
          "pageSize": 1,
          "pageNo": 0,
          // "imeI_Number": userController.imeiNumber.value,
          // "os_Version": "13",
          // "page_Size": 1,
          // "page_No": 1,
        },
      );
      print(response);
      print({
        "vehicleId": selectedVehicleId.value,
        // "depT_ID": userController.deptId.value,
        "userId": userController.userId.value,
        "pageSize": 0,
        "pageNo": 0,
      });

      if (response != null && response['data'] != null) {
        cases.value = List<CaseModel>.from(
          response['data'].map((x) => CaseModel.fromJson(x)),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch cases',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void refreshData() async {
    isLoading.value = true;
    try {
      // Clear selections
      selectedDoctor.value = '';
      selectedDriver.value = '';
      selectedVehicle.value = '';
      selectedCase.value = null;
      cases.clear();

      // Reload initial data
      await fetchInitialData();

      Get.snackbar(
        'Success',
        'Data refreshed successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to refresh data',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void onCaseSelected(CaseModel caseItem) {
    if (selectedCase.value?.caseNo == caseItem.caseNo) {
      selectedCase.value = null; // Deselect if already selected
    } else {
      selectedCase.value = caseItem; // Select new case
    }
  }

  void clearSelectedCase() {
    selectedCase.value = null;
  }

  void proceedWithCase(CaseModel caseItem) {
    // Implement your proceed logic here
    Get.snackbar(
      'Processing',
      'Proceeding with case ${caseItem.caseNo}',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  // For testing purposes, you can add some dummy data
  void addDummyData() {
    doctors.value = [
      'Dr. John Doe',
      'Dr. Jane Smith',
      'Dr. Mike Johnson',
    ];

    drivers.value = [
      'Mr.Ganga sagar ram',
      'Mr. James Wilson',
      'Mr. Robert Brown',
    ];

    vehicles.value = [
      'BUXAR - BR01GN8591',
      'PATNA - BR01AB1234',
      'GAYA - BR02CD5678',
    ];
  }

  void showVehicleSelectionDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 1,
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Text(
                    'Select Vehicle',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() => ListView.builder(
                    itemCount: ambulanceController.ambulanceList.length,
                    itemBuilder: (context, index) {
                      final vehicle = ambulanceController.ambulanceList[index];
                      return ListTile(
                        title: Text(vehicle['vehicle_Number'] ?? ''),
                        subtitle: Text(vehicle['vehicle_Name'] ?? ''),
                        onTap: () {
                          selectedVehicle.value =
                              vehicle['vehicle_Number'] ?? '';
                          selectedVehicleId.value =
                              vehicle['vehicle_ID']?.toString() ?? '';
                          Navigator.pop(context);
                          // Fetch cases when vehicle is selected
                          fetchCases();
                        },
                      );
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }
/* void onCaseSelected(CaseModel caseItem) {
    if (selectedCase.value?.caseNo == caseItem.caseNo) {
      selectedCase.value = null; // Deselect if already selected
    } else {
      selectedCase.value = caseItem; // Select new case
      // Scroll to show the details section
      // You might want to add scroll controller to handle this
    }
  }

  void clearSelectedCase() {
    selectedCase.value = null;
  }
*/
/* void proceedWithCase(CaseModel caseItem) {
    // Implement your proceed logic here
    Get.snackbar(
      'Processing',
      'Proceeding with case ${caseItem.caseNo}',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }*/
// In your CaseSelectionController class
/*  void refreshData() async {
    isLoading.value = true;
    try {
      // Clear selections
      selectedDoctor.value = '';
      selectedDriver.value = '';
      selectedVehicle.value = '';
      selectedCase.value = null;
      cases.clear();

      // Reload initial data
      // await fetchInitialData();

      Get.snackbar(
        'Success',
        'Data refreshed successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to refresh data',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }*/
// Other methods remain the same
// ...
}
