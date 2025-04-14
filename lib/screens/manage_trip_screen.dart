
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vas/controllers/ambulance_controller.dart';
import 'package:vas/controllers/blocks_controller.dart';
import 'package:vas/controllers/districts_controller.dart';
import 'package:vas/controllers/location_sub_type_controller.dart';
import 'package:vas/controllers/user_controller.dart';
import 'package:vas/widgets/trip_details_widget.dart';

import '../controllers/location_type_controller.dart';
import '../controllers/trip_from_controller.dart';
import '../services/api_service.dart';
import '../theme.dart';

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

  TripController tripController = Get.put(TripController());

  // Initialize your controller

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getTripDetails();
      locationTypeController.getLocationTypes();
      districtsController.loadLastSyncedData();
      ambulanceController.getAmbulances();
    });
    // controller.loadTripDetails('StartTrip');
  }

  void getTripDetails() {
    tripController.fetchTripDetails();
    if (tripController.tripDetails.value != null) {
      ///district
      districtsController.selectedDistrict.value =
          tripController.tripDetails.value!.district;
      districtsController.selectedDistrictId.value =
          "${tripController.tripDetails.value!.districtId}";

      ///block
      blocksController.selectedBlock.value =
          tripController.tripDetails.value!.block;
      blocksController.selectedBlockId.value =
          "${tripController.tripDetails.value!.blockId}";

      ///locationtype
      // locationTypeController.selectedLocationType.value =
      //     tripController.tripDetails.value!.lo;
      // districtsController.selectedDistrictId.value =
      //     "${tripController.tripDetails.value!.districtId}";

      ///location

      locationSubTypeController.selectedLocationName.value =
          tripController.tripDetails.value!.location;
      locationSubTypeController.selectedLocationId.value =
          "${tripController.tripDetails.value!.locationId}";

      ///ambulance
      ambulanceController.selectedAmbulanceName.value =
          tripController.tripDetails.value!.vehicle;
      ambulanceController.selectedAmbulanceId.value =
          "${tripController.tripDetails.value!.vehicleId}";

      ///baseodometer
      controller.baseOdometerController.text =
          "${tripController.tripDetails.value!.startKm} ${tripController.tripDetails.value!.startTime}";

      ///seenArrival
      controller.seenArrivalOdometerController.text =
          "${tripController.tripDetails.value!.reachKm} ${tripController.tripDetails.value!.reachTime}";

      ///departure
      controller.departureOdometerController.text =
          "${tripController.tripDetails.value!.departKm} ${tripController.tripDetails.value!.departureTime}";
      // districtsController.selectedDistrictId.value =
      //     "${tripController.tripDetails.value!.districtId}";

      ///doctor
      controller.selectedDoctor.value =
          tripController.tripDetails.value!.doctor;
      controller.selectedDoctorId.value =
          "${tripController.tripDetails.value!.doctorId}";

      ///driver
      controller.selectedDriver.value =
          tripController.tripDetails.value!.driver;
      controller.selectedDriverId.value =
          "${tripController.tripDetails.value!.driverId}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Trip",
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w600,
            )),
        elevation: 0,
        backgroundColor: AppThemes.light.primaryColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppThemes.light.primaryColor,
              AppThemes.light.primaryColor.withOpacity(0.8),
              AppThemes.light.primaryColor.withOpacity(0.6),
            ],
          ),
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(4, 24, 4, 12),
                      child: Text(
                        'Location Details',
                        style: GoogleFonts.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Obx(() {
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
                            "name"),
                      );
                    }),
                    const SizedBox(height: 12),
                    Obx(() {
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
                            "name"),
                      );
                    }),
                    const SizedBox(height: 12),
                    Obx(() {
                      return _buildSelectionCard(
                        icon: Icons.place,
                        title: "Location Type",
                        value:
                            locationTypeController.selectedLocationType.value,
                        onTap: () => _showSelectionDialog(
                            "LocationType",
                            locationTypeController.selectedLocationType,
                            locationTypeController.selectedLocationTypeId,
                            locationTypeController.locationTypes,
                            "stopType_ID",
                            "stopType_Name"),
                      );
                    }),
                    const SizedBox(height: 12),
                    Obx(() {
                      return _buildSelectionCard(
                        icon: Icons.pin_drop,
                        title: "Location",
                        value: locationSubTypeController
                            .selectedLocationName.value,
                        onTap: () => _showSelectionDialog(
                            "Location",
                            locationSubTypeController.selectedLocationName,
                            locationSubTypeController.selectedLocationId,
                            locationSubTypeController.location,
                            "stop_ID",
                            "stop_Name"),
                      );
                    }),
                    _buildSectionTitle("Vehicle Details"),
                    Obx(() {
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
                            "asseT_NO"),
                      );
                    }),
                    const SizedBox(height: 12),
                    Obx(() {
                      return _buildInputCard(
                        icon: Icons.speed,
                        title: controller.baseOdometerText.value,
                        controller: controller.baseOdometerController,
                        keyboardType: TextInputType.number,
                        edit: false,
                      );
                    }),

                    Obx(() {
                      ///seen arrival
                      if (tripController.tripDetails.value != null &&
                          tripController.tripDetails.value?.startTime != "") {
                        //||
                        // tripController.tripDetails.value?.startKm != 0
                        return _buildInputCard(
                            icon: Icons.speed,
                            title: "Seen Arrival Odometer",
                            controller:
                                controller.seenArrivalOdometerController,
                            keyboardType: TextInputType.number,
                            edit: tripController.tripDetails.value?.reachTime !=
                                    ""
                                ? false
                                : true);
                      } else {
                        return const SizedBox.shrink();
                      }
                    }),

                    ///departure

                    Obx(() {
                      if (tripController.tripDetails.value != null &&
                              tripController.tripDetails.value?.reachTime !=
                                  "" /* ||
                        tripController.tripDetails.value?.reachKm != 0*/
                          ) {
                        return _buildInputCard(
                            icon: Icons.speed,
                            title: "Departure Odometer",
                            controller: controller.departureOdometerController,
                            keyboardType: TextInputType.number,
                            edit: tripController
                                        .tripDetails.value?.departureTime !=
                                    ""
                                ? false
                                : true);
                      } else {
                        return const SizedBox
                            .shrink(); // Return an invisible widget instead of null
                      }
                    }),

                    ///back to base odometer
                    Obx(() {
                      if (tripController.tripDetails.value != null &&
                              tripController.tripDetails.value?.departureTime !=
                                  "" /*||
                          tripController.tripDetails.value?.departKm != 0*/
                          ) {
                        return _buildInputCard(
                            icon: Icons.speed,
                            title: "Back to Base Odometer",
                            controller: controller.backToBaseOdometerController,
                            keyboardType: TextInputType.number,
                            edit: true);
                      } else {
                        return const SizedBox.shrink();
                      }
                    }),

                    _buildSectionTitle("Staff Details"),
                    Obx(() {
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
                            "doctor_Name"),
                      );
                    }),
                    const SizedBox(height: 12),
                    Obx(() {
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
                            "driver_Name"),
                      );
                    }),
                    const SizedBox(height: 32),
                    Obx(() => Container(
                          width: double.infinity,
                          height: 54,
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          child: ElevatedButton(
                            onPressed: tripController.tripDetails.value == null
                                ? controller.submitForm
                                : tripController.tripDetails.value != null &&
                                        tripController
                                                .tripDetails.value!.startTime ==
                                            ""
                                    ? controller.submitForm
                                    : tripController.tripDetails.value !=
                                                null &&
                                            tripController.tripDetails.value!
                                                    .reachTime ==
                                                ""
                                        ? controller.submitFormSeen
                                        : tripController.tripDetails.value !=
                                                    null &&
                                                tripController.tripDetails
                                                        .value!.departureTime ==
                                                    ""
                                            ? controller.submitFormDeparture
                                            : controller.submitFormClose,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppThemes.light.primaryColor,
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
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  )
                                : tripController.tripDetails.value != null &&
                                        tripController
                                                .tripDetails.value!.startTime ==
                                            ""
                                    ? Text(
                                        "Submit Trip Details",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      )
                                    : tripController.tripDetails.value !=
                                                null &&
                                            tripController.tripDetails.value!
                                                    .reachTime ==
                                                ""
                                        ? Text(
                                            "Submit Seen Arrival",
                                            style: GoogleFonts.montserrat(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          )
                                        : tripController.tripDetails.value !=
                                                    null &&
                                                tripController.tripDetails
                                                        .value!.departureTime ==
                                                    ""
                                            ? Text(
                                                "Submit Departure",
                                                style: GoogleFonts.montserrat(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                              )
                                            : tripController.tripDetails
                                                            .value !=
                                                        null &&
                                                    tripController
                                                            .tripDetails
                                                            .value!
                                                            .departureTime !=
                                                        ""
                                                ? Text(
                                                    "Close Trip",
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                : Text(
                                                    "Submit Trip Details",
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
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
            Obx(() {
              return tripController.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : const SizedBox.shrink();
            }),
          ],
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
                                 color: Colors.white,

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
                  color: AppThemes.light.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppThemes.light.primaryColor),
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
    required bool edit,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: edit ? Colors.red : Colors.grey.shade200),
        // side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppThemes.light.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppThemes.light.primaryColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.montserrat(
                      fontSize: 15,
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

                            print(item[keyField]?.toString());
                            print(item[valueField]?.toString());

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


  final ApiService apiService = ApiService();

  bool isLoading = false;

  Future<void> getOdometer(String ambulanceId) async {
    controller.isLoading.value = true;

    String userId = userController.userId.value;
    try {
      String formattedEndpoint = '/GetLastOdometerReading/$ambulanceId/$userId';
      var response = await apiService.getRequestForMaster(formattedEndpoint);

      if (response != null) {

        var lastBaseKM = response['last_Base_KM'] ?? 0.00;

        // controller.baseOdometerController.text = "$lastBaseKM";
        controller.baseOdometerText.value = "$lastBaseKM";
        // 4. Use the parsed values (example):
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
