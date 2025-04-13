import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme.dart';
import '../widgets/trip_details_widget.dart';
import 'case_details_screen.dart';

class CaseRegistrationNewScreen extends StatefulWidget {
  const CaseRegistrationNewScreen({super.key});

  @override
  State<CaseRegistrationNewScreen> createState() =>
      _CaseRegistrationNewScreenState();
}

class _CaseRegistrationNewScreenState extends State<CaseRegistrationNewScreen> {
  final CaseRegistrationController controller =
      Get.put(CaseRegistrationController());
  final TripController tripController = Get.put(TripController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // tripController.fetchTripDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Case Registration New'),
        backgroundColor: AppThemes.dark.primaryColor,
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
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          final trip = tripController.tripDetails.value;
          if (trip == null) {
            return const Center(child: Text("No trip details available"));
          }/*
          if (tripController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }*/

          return Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    // _buildInputCard(icon: Icons.near_me, title: 'Name', value:"${trip.tripId}"),
                    _buildInputCard(
                        icon: Icons.near_me,
                        title: 'Trip ID',
                        value: "${trip.tripId}"),
                    _buildInputCard(
                        icon: Icons.emergency,
                        title: 'Ambulance No',
                        value: trip.vehicle),
                    _buildInputCard(
                        icon: Icons.near_me,
                        title: 'No Of Cases',
                        value: "${trip.noOfCases}"),
                    _buildInputCard(
                        icon: Icons.speed,
                        title: 'Odometer',
                        value: "${trip.startKm}"),
                    _buildInputCard(
                        icon: Icons.speed,
                        title: 'Seen Arrival Odometer',
                        value: "${trip.reachKm}"),
                    _buildInputCard(
                        icon: Icons.speed,
                        title: 'Seen Departure Odometer',
                        value: "${trip.reachKm}"),
                    _buildInputCard(
                        icon: Icons.vaccines,
                        title: 'Service Village',
                        value: trip.location),

                    // buildTextField("Name","${trip.tripId}", icon: Icons.near_me),
                    // buildTextField("Ambulance No", trip.vehicle, icon: Icons.emergency),
                    // buildTextField("No Of Cases", controller.noOfCases.value, icon: Icons.library_books_sharp),
                    // buildTextField("Start Odometer", "${trip.startKm}", icon: Icons.speed),
                    // buildTextField("Seen Arrival Odometer",
                    //     "${trip.reachKm}", icon: Icons.view_sidebar),
                    // buildTextField("Seen Departure Odometer",
                    //     "${trip.departKm}", icon: Icons.foggy),
                    // buildTextField(
                    //     "Service Village ", trip.location, icon: Icons.vaccines),

                    // buildTextField("Location Type",trip.address),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_validateFields()) {
                      Get.to(() => const CaseDetailsScreen());
                    } else {
                      Get.snackbar(
                          "Error", "Please fill all fields before continuing.",
                          backgroundColor: Colors.red, overlayBlur: 2);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppThemes.dark.primaryColor,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text("Continue"),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildTextFieldWithController(
      String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration:
          InputDecoration(labelText: label, border: const OutlineInputBorder()),
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildInputCard({
    required IconData icon,
    required String title,
    TextInputType keyboardType = TextInputType.text,
    required String value,
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
                color: AppThemes.dark.primaryColor.withOpacity(0.1),
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
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    value,
                    style: GoogleFonts.montserrat(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  // TextField(
                  //   enabled: false,
                  //   // controller: controller,
                  //   keyboardType: keyboardType,
                  //   decoration:  InputDecoration(
                  //     border: InputBorder.none,
                  //     isDense: true,
                  //     hintText: value,
                  //     contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  //   ),
                  //
                  //   style: GoogleFonts.montserrat(
                  //     fontSize: 15,
                  //     fontWeight: FontWeight.w500,
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(
    String label,
    String value, {
    required IconData icon,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppThemes.dark.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppThemes.dark.primaryColor),
            ),
            // Expanded(child: Text("$label:")),
            Expanded(
              flex: 3,
              child: Container(
                // padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  // border: Border.all(color: Colors.grey), // Grey border
                  borderRadius: BorderRadius.circular(8), // Rounded corners
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        value,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    // const Icon(Icons.arrow_drop_down), // Dropdown icon
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _validateFields() {
    return controller.name.isNotEmpty &&
        controller.tripId.isNotEmpty &&
        controller.district.isNotEmpty &&
        controller.ambulanceNo.isNotEmpty &&
        controller.noOfCases.isNotEmpty &&
        controller.startOdometer.isNotEmpty;
  }
}

class CaseRegistrationController extends GetxController {
  var name = "Paravet Two".obs;
  var tripId = "2016".obs;
  var district = "RAIPUR".obs;
  var block = "".obs;
  var ambulanceNo = "AARANG - CG02 AU1682".obs;
  var noOfCases = "0".obs;
  var startOdometer = "10.00 - 16/06/2024 10:15".obs;
  var seenArrivalOdometer = "11.00 - 16/06/2024 10:16".obs;
  var seenDepartureOdometer = "".obs;
  var locationType = "CHC".obs;
  var serviceVillage = "AKOLDIH ALIAS".obs;
  var ownerContact = "9893076001".obs;
  var ownerName = "Vivek".obs;
  var category = "OBC".obs;
}
