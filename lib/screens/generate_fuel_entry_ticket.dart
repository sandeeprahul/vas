import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vas/controllers/user_controller.dart';

import '../controllers/ambulance_controller.dart';
import '../controllers/blocks_controller.dart';
import '../controllers/districts_controller.dart';
import '../controllers/fuel_entry_controller.dart';
import '../controllers/location_sub_type_controller.dart';
import '../controllers/location_type_controller.dart';
import '../controllers/trip_from_controller.dart';
import '../services/api_service.dart';

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
        title: const Text("Generate Fuel Entry Ticket"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
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

            _buildTextField(
                "Petro Card No:", fuelEntryController.petroCardController),
            const SizedBox(
              height: 8,
            ),

            _buildTextField(
                "Service Type:", fuelEntryController.serviceTypeController),
            const SizedBox(
              height: 8,
            ),

            Obx(() => GestureDetector(
                  onTap: () {
                    _showSelectionDialog(
                        "District",
                        fuelEntryController.selectedDistrict,
                        fuelEntryController.selectedDistrictId,
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
                          "District: ${districtsController.selectedDistrict.value}",
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
                fuelEntryController.selectedBlock,
                fuelEntryController.selectedBlockId,
                blocksController.blocksList,
                "blockId",
                "name"),
            //    blocksController.getBlocks(districtsController.selectedDistrictId.value,userController.userId.value);
            const SizedBox(
              height: 8,
            ),


            Obx(() => GestureDetector(
                  onTap: () {
                    _showSelectionDialog(
                        "LocationType",
                        fuelEntryController.selectedLocationType,
                        fuelEntryController.selectedLocationTypeId,
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
                          "LocationType: ${locationTypeController.selectedLocationType.value}",
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

            _buildTextField("On Duty Staff Name",
                fuelEntryController.onDutyStaffController),
            const SizedBox(
              height: 8,
            ),
            _buildTextField("Last Duty Close KM",
                fuelEntryController.lastDutyCloseKmController),

            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {},
              child: const Text(
                "CONTINUE",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  final ApiService apiService = ApiService();

  bool isLoading = false;

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
                  "$title: ${selectedValue.value}",
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

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration:
          InputDecoration(labelText: label, border: const OutlineInputBorder()),
      // keyboardType:label==?: TextInputType.number,
    );
  }

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
