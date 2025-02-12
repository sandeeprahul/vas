import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'case_details_screen.dart';

class CaseRegistrationNewScreen extends StatelessWidget {
  final CaseRegistrationController controller = Get.put(CaseRegistrationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Case Registration New'),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  buildTextField("Name", controller.name),
                  buildTextField("Trip ID", controller.tripId),
                  buildTextField("District", controller.district),
                  buildTextField("Block", controller.block),
                  buildTextField("Ambulance No", controller.ambulanceNo),
                  buildTextField("No Of Cases", controller.noOfCases),
                  buildTextField("Start Odometer", controller.startOdometer),
                  buildTextField("Seen Arrival Odometer", controller.seenArrivalOdometer),
                  buildTextField("Seen Departure Odometer", controller.seenDepartureOdometer),
                  buildTextField("Location Type", controller.locationType),
                  buildTextField("Service Village", controller.serviceVillage),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (_validateFields()) {
                  Get.to(() => CaseDetailsScreen());
                } else {
                  Get.snackbar("Error", "Please fill all fields before continuing.");
                }
              },
              child: Text("Continue"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 32.0),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String label, RxString value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        onChanged: (text) => value.value = text,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
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
