import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

    tripController.loadTripDetails('StartTrip');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Case Registration New'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          final trip = tripController.tripDetails.value;
          if (trip == null) {
            return const Center(child: Text("No trip details available"));
          }

          return Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    buildTextField("Name","${trip.tripId}"),
                    buildTextField("Trip ID", "${trip.tripId}"),
                    // buildTextField("Address", trip.address),
                    // buildTextField("Block", trip.locationName),
                    buildTextField("Ambulance No", trip.vehicle),
                    buildTextField("No Of Cases", controller.noOfCases.value),
                    buildTextField("Start Odometer", "${trip.startKm}"),
                    buildTextField("Seen Arrival Odometer",
                        "${trip.startKm}"),
                    buildTextField("Seen Departure Odometer",
                        controller.seenDepartureOdometer.value),
                    buildTextField(
                        "Service Village ", trip.location),

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
                          "Error", "Please fill all fields before continuing.",backgroundColor: Colors.red,overlayBlur: 2);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 32.0),
                    // textStyle: const TextStyle(
                    //     fontSize: 18, fontWeight: FontWeight.bold),
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

  Widget _buildTextFieldWithController(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration:
      InputDecoration(labelText: label, border: const OutlineInputBorder()),
      keyboardType: TextInputType.number,
    );
  }
  Widget buildTextField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(child: Text("$label:")),
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey), // Grey border
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
