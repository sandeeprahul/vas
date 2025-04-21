import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vas/controllers/user_controller.dart';
import 'package:vas/screens/fuel_entry_screen.dart';
import 'package:vas/screens/vehicle_details_screen.dart';
import 'package:vas/widgets/animal_bg_widget.dart';

import '../controllers/ambulance_controller.dart';
import '../controllers/blocks_controller.dart';
import '../controllers/districts_controller.dart';
import '../controllers/fuel_entry_controller.dart';
import '../controllers/location_sub_type_controller.dart';
import '../controllers/location_type_controller.dart';
import '../controllers/trip_from_controller.dart';
import '../models/vehicle_details_model.dart';
import '../services/api_service.dart';
import '../theme.dart';

class GenerateFuelEntryTicket extends StatefulWidget {
  const GenerateFuelEntryTicket({super.key});

  @override
  State<GenerateFuelEntryTicket> createState() =>
      _GenerateFuelEntryTicketState();
}

class _GenerateFuelEntryTicketState extends State<GenerateFuelEntryTicket> {
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
  VehicleDetailsModel? vehicleData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ambulanceController.getAmbulances();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Generate Fuel Entry Ticket",
        ),
        backgroundColor: AppThemes.light.primaryColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
                AppThemes.light.primaryColor,
              AppThemes.light.primaryColor.withOpacity(0.55),
              AppThemes.light.primaryColor.withOpacity(0.6),
              Colors.white,
            ],
          ),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Stack(
          children: [
            AnimalBgWidget(),
            isLoading?const Center(child: CircularProgressIndicator(),):ListView(
              children: [
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
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color:  Colors.grey.shade200),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),

                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppThemes.light.primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(Icons.emergency, color: AppThemes.light.primaryColor),
                              ),
                              const SizedBox(width: 16),

                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      "Select Ambulance",
                                      style: TextStyle(
                                          color: ambulanceController
                                              .selectedAmbulanceName.value ==
                                              "Ambulance"
                                              ? Colors.grey
                                              : Colors.black),
                                    ),
                                    Text(
                                      ambulanceController.selectedAmbulanceName.value,
                                      style: TextStyle(
                                          color: ambulanceController
                                                      .selectedAmbulanceName.value ==
                                                  "Ambulance"
                                              ? Colors.grey
                                              : Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.arrow_drop_down),
                            ],
                          ),
                        ),
                      ),
                    )),

                if (vehicleData == null)
                  const SizedBox.shrink()
                else
                  VehicleDetailsScreen(
                    vehicleData: vehicleData!,
                  ),
                const SizedBox(
                  height: 28,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {

                    Get.to(FuelEntryScreen(vehicleData: vehicleData!,));
                    // Get.to(FuelEntryScreen(vehicleId: int.parse(ambulanceController.selectedAmbulanceId.value), tripId: int.parse(vehicleData!.schTripDetails.tripId), caseId: int.parse(vehicleData!.emgCaseDetails.caseNo), odometerBase: "${vehicleData!.odometerBase}"));
                  },
                  child: isLoading
                      ? const Center(child: Text('Loading...'))
                      : const Text(
                          "CONTINUE",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            letterSpacing: 1.2,
                          ),
                        ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  final ApiService apiService = ApiService();

  bool isLoading = false;



  final fuelEntryController = Get.put(FuelEntryController());

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

                            fuelEntryController.selectedDistrictId.value =
                                item[keyField]?.toString() ?? "";
                            fuelEntryController.selectedDistrict.value =
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

                            fuelEntryController.selectedLocationTypeId.value =
                                item[keyField]?.toString() ?? "";
                            fuelEntryController.selectedLocationType.value =
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

                            fuelEntryController.selectedAmbulanceId.value =
                                item[keyField]?.toString() ?? "";
                            fuelEntryController.selectedAmbulanceName.value =
                                item[valueField]?.toString() ?? "";
                            getOdometer("${item[keyField]}");

                            getFuelRecords(
                                ambulanceController.selectedAmbulanceId.value,
                                ambulanceController
                                    .selectedAmbulanceName.value);
                          } else if (title == "Block") {
                            fuelEntryController.selectedBlockId.value =
                                item[keyField]?.toString() ?? "";
                            fuelEntryController.selectedBlock.value =
                                item[valueField]?.toString() ?? "";

                            blocksController.selectedBlockId.value =
                                item[keyField]?.toString() ?? "" "";
                            blocksController.selectedBlock.value =
                                item[valueField]?.toString() ?? "";
                          }

                          /*else if(title == "Block"){}
                          else {

                            fuelEntryController.selectedLocationTypeId.value =
                                int.parse(item[valueField]) ??
                                    -1; // ✅ Display valueField
                            fuelEntryController.selectedLocationType.value = item[keyField]?.toString() ??
                                ""; // ✅ Store keyField
                          }*/

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

  Future<void> getOdometer(String ambulanceId) async {
    isLoading = true;
    UserController userController = Get.put(UserController());

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
        fuelEntryController.lastDutyCloseKmController.text = "$lastBaseKM";
        print("${fuelEntryController.lastDutyCloseKmController.value}");
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
      isLoading = false;
    }
  }

  Future<void> getFuelRecords(String ambulanceId, String vehicleNo) async {
    setState(() {
      isLoading = true;

    });
    UserController userController = Get.put(UserController());

    String userId = userController.userId.value;
    try {
      String formattedEndpoint = '/GetFuelRecord';
      var jsonData = {
        "user_ID": userId,
        "vehiclE_ID": ambulanceId,
        // "vehiclE_ID": ambulanceId,
        "vehiclE_NO": vehicleNo,
        "mobilE_NO": ""
      };

      var response = await apiService.postRequest(formattedEndpoint, jsonData);

      print(response);
      print(jsonData);
      if (response != null) {
        // var decodedResponse = json.decode(response);
        setState(() {
          vehicleData = VehicleDetailsModel.fromJson(response);
        });

// Navigate to the screen
//         Get.to(VehicleDetailsScreen(vehicleData: vehicleData));
      } else {
        print("Error: API returned null!");
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      controller.isLoading.value = false;
      setState(() {
        isLoading = false;

      });
    }
  }

  Widget _buildLabelField(String label) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
          // const Divider(),/
        ],
      ),
    );
  }
}
