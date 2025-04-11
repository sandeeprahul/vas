import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vas/controllers/ambulance_controller.dart';
import 'package:vas/controllers/blocks_controller.dart';
import 'package:vas/controllers/districts_controller.dart';
import 'package:vas/controllers/location_sub_type_controller.dart';
import 'package:vas/controllers/user_controller.dart';

import '../controllers/location_type_controller.dart';
import '../controllers/trip_from_controller.dart';
import '../services/api_service.dart';
import '../theme.dart';
import '../utils/DotPatternPainter.dart';

class ManageTripScreen extends StatefulWidget {
  const ManageTripScreen({super.key});

  @override
  State<ManageTripScreen> createState() => _ManageTripScreenState();
}

class _ManageTripScreenState extends State<ManageTripScreen> {
  final FormController controller = Get.put(FormController());

  final LocationTypeController locationTypeController =
      Get.put(LocationTypeController());
  final DistrictsController districtsController =
      Get.put(DistrictsController());
  final BlocksController blocksController = Get.put(BlocksController());

  final UserController userController = Get.put(UserController());
  final LocationSubTypeController locationSubTypeController =
      Get.put(LocationSubTypeController());
  final AmbulanceController ambulanceController =
      Get.put(AmbulanceController());

  // Initialize your controller

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    locationTypeController.getLocationTypes();
    districtsController.loadLastSyncedData();
    ambulanceController.getAmbulances();
    controller.loadTripDetails('StartTrip');
    print("controller.loadTripDetails(");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Trip", style: GoogleFonts.montserrat(
          fontWeight: FontWeight.w600,
        )),
        elevation: 0,
        backgroundColor:  AppThemes.dark.primaryColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppThemes.dark.primaryColor.withOpacity(0.05),
              Colors.white,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle("Location Details"),
                Obx(
                   () {
                    return _buildSelectionCard(
                      icon: Icons.location_on,
                      title: "District",
                      value: districtsController.selectedDistrict.value,
                      onTap: () => _showSelectionDialog(
                          "District",
                          districtsController.selectedDistrict,
                          districtsController.selectedDistrictId,
                          districtsController.districtsList,
                          "id",
                          "name"
                      ),
                    );
                  }
                ),
                const SizedBox(height: 12),
                Obx(
                   () {
                    return _buildSelectionCard(
                      icon: Icons.map,
                      title: "Block",
                      value: blocksController.selectedBlock.value,
                      onTap: () => _showSelectionDialog(
                          "Block",
                          blocksController.selectedBlock,
                          blocksController.selectedBlockId,
                          blocksController.blocksList,
                          "blockId",
                          "name"
                      ),
                    );
                  }
                ),
                const SizedBox(height: 12),
                Obx(
                   () {
                    return _buildSelectionCard(
                      icon: Icons.place,
                      title: "Location Type",
                      value: locationTypeController.selectedLocationType.value,
                      onTap: () => _showSelectionDialog(
                          "LocationType",
                          locationTypeController.selectedLocationType,
                          locationTypeController.selectedLocationTypeId,
                          locationTypeController.locationTypes,
                          "stopType_ID",
                          "stopType_Name"
                      ),
                    );
                  }
                ),
                const SizedBox(height: 12),
                Obx(
                   () {
                    return _buildSelectionCard(
                      icon: Icons.pin_drop,
                      title: "Location",
                      value: locationSubTypeController.selectedLocationName.value,
                      onTap: () => _showSelectionDialog(
                          "Location",
                          locationSubTypeController.selectedLocationName,
                          locationSubTypeController.selectedLocationId,
                          locationSubTypeController.location,
                          "stop_ID",
                          "stop_Name"
                      ),
                    );
                  }
                ),

                _buildSectionTitle("Vehicle Details"),
                Obx(
                   () {
                    return _buildSelectionCard(
                      icon: Icons.local_hospital,
                      title: "Ambulance",
                      value: ambulanceController.selectedAmbulanceName.value,
                      onTap: () => _showSelectionDialog(
                          "Ambulance",
                          ambulanceController.selectedAmbulanceName,
                          ambulanceController.selectedAmbulanceId,
                          ambulanceController.ambulanceList,
                          "id",
                          "asseT_NO"
                      ),
                    );
                  }
                ),
                const SizedBox(height: 12),
                _buildInputCard(
                  icon: Icons.speed,
                  title: "Base Odometer",
                  controller: controller.baseOdometerController,
                  keyboardType: TextInputType.number,
                ),

                _buildSectionTitle("Staff Details"),
                Obx(
                   () {
                    return _buildSelectionCard(
                      icon: Icons.medical_services,
                      title: "Doctor",
                      value: controller.selectedDoctor.value,
                      onTap: () => _showSelectionDialog(
                          "Doctor",
                          controller.selectedDoctor,
                          controller.selectedDoctorId,
                          controller.doctors,
                          "doctor_ID",
                          "doctor_Name"
                      ),
                    );
                  }
                ),
                const SizedBox(height: 12),
                Obx(
                   () {
                    return _buildSelectionCard(
                      icon: Icons.drive_eta,
                      title: "Driver",
                      value: controller.selectedDriver.value,
                      onTap: () => _showSelectionDialog(
                          "Driver",
                          controller.selectedDriver,
                          controller.selectedDriverId,
                          controller.drivers,
                          "driver_ID",
                          "driver_Name"
                      ),
                    );
                  }
                ),

                const SizedBox(height: 32),
                Obx(() => Container(
                  width: double.infinity,
                  height: 54,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value ? null : controller.submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:  AppThemes.dark.primaryColor,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: controller.isLoading.value
                        ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                        : Text(
                      "Submit Trip Details",
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 24, 4, 12),
      child: Text(
        title,
        style: GoogleFonts.montserrat(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color:  AppThemes.dark.primaryColor,
        ),
      ),
    );
  }

  Widget _buildSelectionCard({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color:  AppThemes.dark.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color:  AppThemes.dark.primaryColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: GoogleFonts.montserrat(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputCard({
    required IconData icon,
    required String title,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color:  AppThemes.dark.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppThemes.dark.primaryColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  TextField(
                    controller: controller,
                    keyboardType: keyboardType,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                    ),
                    style: GoogleFonts.montserrat(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget builddd(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage trip"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            /*    _buildDropdownField(
                "District",
                districtsController.selectedDistrict,
                districtsController.selectedDistrictId,
                districtsController.districtsList,
                "id",
                "name"),*/

            Obx(() => GestureDetector(
                  onTap: () {
                    _showSelectionDialog(
                        "District",
                        districtsController.selectedDistrict,
                        districtsController.selectedDistrictId,
                        districtsController.districtsList,
                        "id",
                        "name");
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          districtsController.selectedDistrict.value,
                          style: TextStyle(
                              color:
                                  districtsController.selectedDistrict.value ==
                                          "District"
                                      ? Colors.grey
                                      : Colors.black),
                        ),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                )),


            const SizedBox(
              height: 8,
            ),
            _buildDropdownField(
                "Block",
                blocksController.selectedBlock,
                blocksController.selectedBlockId,
                blocksController.blocksList,
                "blockId",
                "name"),
            //    blocksController.getBlocks(districtsController.selectedDistrictId.value,userController.userId.value);
            const SizedBox(
              height: 8,
            ),

            const SizedBox(
              height: 8,
            ),

            Obx(() => GestureDetector(
                  onTap: () {
                    _showSelectionDialog(
                        "LocationType",
                        locationTypeController.selectedLocationType,
                        locationTypeController.selectedLocationTypeId,
                        locationTypeController.locationTypes,
                        "stopType_ID",
                        "stopType_Name");
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          locationTypeController.selectedLocationType.value,
                          style: TextStyle(
                              color: locationTypeController
                                          .selectedLocationType.value ==
                                      "Location"
                                  ? Colors.grey
                                  : Colors.black),
                        ),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                )),

            const SizedBox(
              height: 8,
            ),

            _buildDropdownField(
                "Location",
                locationSubTypeController.selectedLocationName,
                locationSubTypeController.selectedLocationId,
                locationSubTypeController.location,
                "stop_ID",
                "stop_Name"),

            const SizedBox(
              height: 8,
            ),

            /*_buildTextField(
                "Enter Ambulance Number", controller.ambulanceController),*/ /*
            const SizedBox(
              height: 8,
            ),*/
            Obx(() => GestureDetector(
                  onTap: () {
                    _showSelectionDialog(
                        "Ambulance",
                        ambulanceController.selectedAmbulanceName,
                        ambulanceController.selectedAmbulanceId,
                        ambulanceController.ambulanceList,
                        "id",
                        "asseT_NO");
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          ambulanceController.selectedAmbulanceName.value,
                          style: TextStyle(
                              color: ambulanceController
                                          .selectedAmbulanceName.value ==
                                      "Ambulance"
                                  ? Colors.grey
                                  : Colors.black),
                        ),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                )),

            const SizedBox(
              height: 8,
            ),

            _buildDropdownField(
                "Doctor",
                controller.selectedDoctor,
                controller.selectedDoctorId,
                controller.doctors,
                "doctor_ID",
                "doctor_Name"),
            const SizedBox(
              height: 8,
            ),

            _buildDropdownField(
                "Driver",
                controller.selectedDriver,
                controller.selectedDriverId,
                controller.drivers,
                "driver_ID",
                "driver_Name"),
            const SizedBox(
              height: 8,
            ),

            // _buildDropdownField("Doctor", controller.selectedDoctor, doctorController.doctors.values.toList().obs, "doctorId", "doctorName"),
            // _buildDropdownField("Driver", controller.selectedDriver, driverController.drivers.values.toList().obs, "driverId", "driverName"),
            _buildTextField("Base Odometer", controller.baseOdometerController),
            const SizedBox(height: 20),
            const Spacer(),
            Obx(() => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.submitForm,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          // Add this
                          borderRadius: BorderRadius.circular(
                              28.0), // Adjust the radius as needed
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        textStyle: GoogleFonts.montserrat(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Submit"),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField(
      String title,
      RxString selectedValue, // Stores valueField (UI)
      RxString selectedKey, // Stores keyField (Submission)
      List<dynamic> dataList,
      String keyField,
      String valueField) {
    return Obx(() => GestureDetector(
          onTap: () {
            _showSelectionDialog(title, selectedValue, selectedKey, dataList,
                keyField, valueField);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedValue.value,
                  style: TextStyle(
                      color: selectedValue.value == title
                          ? Colors.grey
                          : Colors.black),
                ),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ));
  }

  void _showSelectionDialog(
      String title,
      RxString selectedValue,
      RxString selectedKey, // ✅ Stores keyField (Submission)
      List<dynamic> dataList,
      String keyField,
      String valueField) {
    Get.dialog(
      AlertDialog(
        title: Text("Select $title"),
        content: dataList.isNotEmpty
            ? SizedBox(
                height:
                    300, // ✅ Define height to avoid intrinsic dimensions issue
                width: double.maxFinite, // ✅ Ensures it takes full width
                child: SingleChildScrollView(
                  // ✅ Wrap with SingleChildScrollView
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: dataList.map((item) {
                      return ListTile(
                        title: Text(item[valueField] ?? "Unknown"),
                        onTap: () {
                          if (title == "District") {
                            districtsController.selectedDistrictId.value =
                                item[keyField]?.toString() ?? "";
                            districtsController.selectedDistrict.value =
                                item[valueField]?.toString() ?? "";
                            blocksController.blocksList.clear();
                            blocksController.selectedBlock.value =
                                "Select Block";
                            blocksController.getBlocks(
                                userController.userId.value,
                                "${item[keyField]}");
                          } else if (title == "LocationType") {
                            locationTypeController.selectedLocationTypeId
                                .value = item[keyField]?.toString() ?? "";
                            locationTypeController.selectedLocationType.value =
                                item[valueField]?.toString() ?? "";
                            locationSubTypeController.location.clear();
                            locationSubTypeController
                                .selectedLocationName.value = "Select Block";

                            locationSubTypeController.getLocations(
                                userController.zoneId.value,
                                userController.blockId.value,
                                userController.userId.value,
                                "${item[keyField]}");
                          } else if (title == "Ambulance") {
                            ambulanceController.selectedAmbulanceId.value =
                                item[keyField]?.toString() ?? "";
                            ambulanceController.selectedAmbulanceName.value =
                                item[valueField]?.toString() ?? "";

                            getOdometer("${item[keyField]}");
                          } else {
                            selectedValue.value =
                                item[valueField]?.toString() ??
                                    ""; // ✅ Display valueField
                            selectedKey.value = item[keyField]?.toString() ??
                                ""; // ✅ Store keyField
                          }

                          Get.back();
                        },
                      );
                    }).toList(),
                  ),
                ),
              )
            : const Center(child: Text("No data available")),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration:
          InputDecoration(labelText: label, border: const OutlineInputBorder()),
      keyboardType: TextInputType.number,
    );
  }

  final ApiService apiService = ApiService();

  bool isLoading = false;

  Future<void> getOdometer(String ambulanceId) async {
    controller.isLoading.value = true;

    String userId = userController.userId.value;
    try {
      String formattedEndpoint = '/GetLastOdometerReading/$ambulanceId/$userId';
      var response = await apiService.getRequestForMaster(formattedEndpoint);

      if (response != null) {
        // var decodedResponse = json.decode(response);
        String errorCode =
            response['error_Code'] ?? ""; // Use null-safe operator
        String errorMessage = response['error_Message'] ?? "";
        var lastBaseKM = response['last_Base_KM'] ?? 0.00;

        controller.baseOdometerController.text = "$lastBaseKM";
        // 4. Use the parsed values (example):
        print("Error Code: $errorCode");
        print("Error Message: $errorMessage");
        print("Last Base KM: $lastBaseKM");
      } else {
        print("Error: API returned null!");
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      controller.isLoading.value = false;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
