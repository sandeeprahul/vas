import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vas/screens/home_screen.dart';

import '../controllers/DiseaseTypesController.dart';
import '../controllers/DriversController.dart';
import '../controllers/HospitalsController.dart';
import '../controllers/IncidentSubTypesController.dart';
import '../controllers/IncidentTypesController.dart';
import '../controllers/PatientTypesController.dart';
import '../controllers/PaymentMethodsController.dart';
import '../controllers/StandardRemarksController.dart';
import '../controllers/blocks_controller.dart';
import '../controllers/denial_types_controller.dart';
import '../controllers/districts_controller.dart';
import '../controllers/doctors_controller.dart';
import '../controllers/event_types_controller.dart';
import '../controllers/general_settings_controller.dart';
import '../controllers/location_controller.dart';
import '../controllers/user_controller.dart';
import '../shared_pref_helper.dart';
import '../theme.dart';

class MasterDataScreen extends StatefulWidget {
  final bool fromLogin;

  const MasterDataScreen({Key? key, required this.fromLogin}) : super(key: key);

  @override
  State<MasterDataScreen> createState() => _MasterDataScreenState();
}

class _MasterDataScreenState extends State<MasterDataScreen> {
  String userID = '0';

  final EventTypesController eventController = Get.put(EventTypesController());

  final DenialTypesController denialController =
      Get.put(DenialTypesController());

  final BlocksController blocksController = Get.put(BlocksController());

  final IncidentTypesController incidentTypesController =
      Get.put(IncidentTypesController());

  final IncidentSubTypesController incidentSubTypesController =
      Get.put(IncidentSubTypesController());

  final PatientTypesController patientTypesController =
      Get.put(PatientTypesController());

  final GeneralSettingsController generalSettingsController =
      Get.put(GeneralSettingsController());

  final PaymentMethodsController paymentMethodsController =
      Get.put(PaymentMethodsController());

  final DiseaseTypesController diseaseTypesController =
      Get.put(DiseaseTypesController());

  final StandardRemarksController standardRemarksController =
      Get.put(StandardRemarksController());

  final DriversController driversController = Get.put(DriversController());
  final DistrictsController districtsController =
      Get.put(DistrictsController());
  final DoctorsController doctorsController = Get.put(DoctorsController());

  final HospitalsController hospitalsController =
      Get.put(HospitalsController());

  final LocationsController locationsController =
      Get.put(LocationsController());

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.put(UserController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemes.light.primaryColor,
        title: const Text(
          'Master Data',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration:  BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
               AppThemes.light.primaryColor,
              Colors.black,
              Colors.black,
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [

                  buildSyncTile(
                    "Event Types",
                    eventController.lastSyncedTime,
                    eventController.syncEventTypes,
                    eventController.isLoading,
                  ),
                  buildSyncTile(
                      "Denial Types",
                      denialController.lastSyncedTime,
                          () => denialController
                          .syncDenialTypes(userController.userId.value),
                      denialController.isLoading),
                  buildSyncTile(
                      "Blocks",
                      blocksController.lastSyncedTime,
                          () => blocksController.syncBlocks(
                          userController.zoneId.value, userController.userId.value),
                      blocksController.isLoading),
                  buildSyncTile(
                      "Incident Types",
                      incidentTypesController.lastSyncedTime,
                      incidentTypesController.syncIncidentTypes,
                      incidentTypesController.isLoading),
                  buildSyncTile(
                      "Incident Subtypes",
                      incidentSubTypesController.lastSyncedTime,
                      incidentSubTypesController.syncIncidentSubTypes,
                      incidentSubTypesController.isLoading),
                  buildSyncTile(
                      "Patient Types",
                      patientTypesController.lastSyncedTime,
                      patientTypesController.syncPatientTypes,
                      patientTypesController.isLoading),
                  buildSyncTile(
                      "General Settings",
                      generalSettingsController.lastSyncedTime,
                      () => generalSettingsController
                          .syncGeneralSettings(userController.userId.value),
                      generalSettingsController.isLoading),
                  buildSyncTile(
                      "Districts",
                      districtsController.lastSyncedTime,
                      () => districtsController
                          .syncDistricts(userController.userId.value),
                      districtsController.isLoading),
                  buildSyncTile(
                      "Payment Methods",
                      paymentMethodsController.lastSyncedTime,
                      () => paymentMethodsController
                          .syncPaymentMethods(userController.userId.value),
                      paymentMethodsController.isLoading),
                  buildSyncTile(
                      "Disease Types",
                      diseaseTypesController.lastSyncedTime,
                      () => diseaseTypesController
                          .syncDiseaseTypes(userController.userId.value),
                      diseaseTypesController.isLoading),
                  buildSyncTile(
                      "Standard Remarks",
                      standardRemarksController.lastSyncedTime,
                      () => standardRemarksController
                          .syncStandardRemarks(userController.userId.value),
                      standardRemarksController.isLoading),
                  buildSyncTile(
                      "Doctors",
                      doctorsController.lastSyncedTime,
                      () => doctorsController.syncDoctors(
                          userController.userId.value,userController.zoneId.value, userController.blockId.value),
                      doctorsController.isLoading),
                  buildSyncTile(
                      "Drivers",
                      driversController.lastSyncedTime,
                      () => driversController.syncDrivers(
                          userController.userId.value, "ZONE_ID", "BLOCK_ID"),
                      driversController.isLoading),
                  buildSyncTile(
                      "Hospitals",
                      hospitalsController.lastSyncedTime,
                      () => hospitalsController.syncHospitals("DEPT_ID",
                          "ZONE_ID", userController.userId.value, 1, 1),
                      hospitalsController.isLoading),
                  buildSyncTile(
                      "Locations",
                      locationsController.lastSyncedTime,
                      () => locationsController.syncLocations(
                          "DEP_ID", "ZONE_ID", userController.userId.value, 1, 1),
                      locationsController.isLoading),
                ],
              ),
            ),
            widget.fromLogin
                ? Container(
                    margin: const EdgeInsets.all(16),
                    width: double.maxFinite,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.offAll(HomeScreen()); // Auto-login if token exists
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            // Add this
                            borderRadius: BorderRadius.circular(
                                28.0), // Adjust the radius as needed
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          textStyle: GoogleFonts.poppins(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      child: const Text("Go to Home"),
                    ),
                  )
                : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }

  Widget buildSyncTile(String title, RxString lastSyncedTime,
      VoidCallback syncFunction, RxBool isLoading) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppThemes.light.primaryColor.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: syncFunction,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Stack(
            children: [
              // Background Pattern
              Positioned(
                right: -20,
                top: -20,
                child: Icon(
                  Icons.sync,
                  size: 120,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
              // Content
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon and Title Row
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppThemes.light.primaryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child:  Icon(
                          Icons.sync,
                          color: AppThemes.light.primaryColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          title,
                          style:  TextStyle(
                            color: AppThemes.light.primaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Last Synced Time
                  Obx(() => Text(
                        "Last Synced: ${lastSyncedTime.value}",
                        style: TextStyle(
                          color: AppThemes.light.primaryColor.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      )),
                  const SizedBox(height: 16),
                  // Sync Button
                  Obx(() => Container(
                        width: double.infinity,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppThemes.light.primaryColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: isLoading.value
                            ? const Center(
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                ),
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.sync,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Synchronize',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

