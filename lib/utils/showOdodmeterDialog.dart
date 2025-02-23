import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vas/widgets/trip_details_widget.dart';

import '../controllers/OdometerController.dart';
import '../controllers/trip_from_controller.dart';

Future<String?> showOdometerDialog(BuildContext context) async {
  final OdometerController odometerController = Get.put(OdometerController());
  final FormController formController = Get.put(FormController());
  TextEditingController textController = TextEditingController();
  final TripController tripController = Get.find<TripController>();

  return await Get.dialog(
    AlertDialog(
      title: const Text("Enter Odometer Reading"),
      content: TextField(
        controller: textController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(hintText: "Enter Odometer Value"),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back(result: null); // Close without saving
          },
          child: const Text(
            "Cancel",
            style: TextStyle(color: Colors.red),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Get.back(result: null);
            String enteredValue = textController.text.trim();

            if (enteredValue.isNotEmpty) {
              // odometerController.updateOdometer();

              if (tripController.tripStatus.value == 1) {
                formController.submitFormSeen(enteredValue);
              } else if (tripController.tripStatus.value == 2) {
                formController.submitFormDeparture(enteredValue);
              } else if (tripController.tripStatus.value == 3) {
                formController.submitFormClose(enteredValue);
              }
              print(enteredValue);
            }

            // Get.back(result: null); // Return value
            print(enteredValue);
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: Text("Submit"),
          ),
        ),
      ],
    ),
  );
}
