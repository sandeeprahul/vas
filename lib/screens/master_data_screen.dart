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
    final UserController userController = Get.find<UserController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Master Data',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
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
                        textStyle: GoogleFonts.montserrat(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    child: const Text("Go to Home"),
                  ),
                )
              : const SizedBox.shrink()
        ],
      ),
    );
  }

  Widget buildSyncTile(String title, RxString lastSyncedTime,
      VoidCallback syncFunction, RxBool isLoading) {
    return Container(

        // height: 100,
        // width: 200,
        margin: const EdgeInsets.only(top: 16, left:12,right: 6),
        decoration:    BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.blue,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade300, blurRadius: 7, spreadRadius: 0.7)
            ]),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 12,top: 12),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.orange),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Icons.event,
                    color: Colors.white,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          maxLines: 2,
                          style:
                              const TextStyle(color: Colors.white, fontSize: 18,fontWeight: FontWeight.bold)),
                      Obx(() =>  Text(
                        maxLines: 2,
                            // "Last Synced: Never",
                            "Last Synced: ${lastSyncedTime.value}",
                            style: TextStyle(color: Colors.white),
                          )),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  // width: double.infinity,
                  child: ElevatedButton(
            
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                      onPressed: syncFunction,
                      child: const Text(
                        '    Synchronize    ',
                        style: TextStyle(color: Colors.black),
                      )),
                )
              ],
            ),
             Positioned(
               top: -30,
                 right: -36,
                 child: Icon((Icons.pages_rounded),size: 150,color: Colors.white.withOpacity(0.1),))
          ],
        ));
  }
}
/*
* ListTile(
                title: Text(title),
                subtitle: Obx(() => Text("Last Synced: ${lastSyncedTime.value}")),
                trailing: Obx(
                  () => isLoading.value
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                              strokeWidth: 2), // ✅ Loading Indicator
                        )
                      : IconButton(
                          icon: const Icon(Icons.sync, color: Colors.blue),
                          onPressed: syncFunction,
                        ),
                ),
              )*/

/*class MasterDataScreen extends StatefulWidget {
  const MasterDataScreen({super.key});

  @override
  _MasterDataScreenState createState() => _MasterDataScreenState();
}

class _MasterDataScreenState extends State<MasterDataScreen> {
  final EventTypesController eventController = Get.put(EventTypesController());
  final DenialTypesController denialController = Get.put(DenialTypesController());
  final BlocksController blocksController = Get.put(BlocksController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Master Data'),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(

          itemCount: 5,

            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
          return Container(
            // width: 200,
            // height: 200,

            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.teal.shade100,
                boxShadow: const [BoxShadow(color: Colors.black12)],
                borderRadius: BorderRadius.circular(28)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      boxShadow: const [BoxShadow(color: Colors.grey)],
                      borderRadius: BorderRadius.circular(28)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Get Event Types',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Last Downloaded: \n02:00 AM",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                InkWell(
                  // onPressed: () => _synchronize(dataType),
                  onTap: () {},
                  child: const Text(textAlign: TextAlign.center,'SYNCHRONIZE\nNOW'),
                ),
                // Text('SYNCHRONIZE'),
              ],
            ),
          );
        }),
      ),
    );
  }
}*/
