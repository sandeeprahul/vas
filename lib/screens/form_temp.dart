import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vas/controllers/DriversController.dart';
import 'package:vas/controllers/blocks_controller.dart';
import 'package:vas/controllers/districts_controller.dart';
import 'package:vas/controllers/doctors_controller.dart';

import '../controllers/trip_from_controller.dart';

class MyFormScreenTEMPPP extends StatelessWidget {
  final FormController controller = Get.put(FormController());
  final DistrictsController districtController = Get.put(DistrictsController());
  final BlocksController blockController = Get.put(BlocksController());
  final DoctorsController doctorController = Get.put(DoctorsController());
  final DriversController driverController = Get.put(DriversController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Submit Form"), backgroundColor: Colors.blue),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text("Districts", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Obx(() => Expanded(
              child: ListView.builder(
                itemCount: districtController.districts.values.length,
                itemBuilder: (context, index) {
                  var district = districtController.districts.values.toList()[index];
                  return ListTile(
                    title: Text(district['districtName'] ?? "Unknown"),
                    subtitle: Text("ID: ${district['districtId']}"),
                  );
                },
              ),
            )),

            const SizedBox(height: 20),

            const Text("Doctors", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Obx(() => Expanded(
              child: ListView.builder(
                itemCount: doctorController.doctors['doctorData']?.length ?? 0,
                itemBuilder: (context, index) {
                  var doctor = doctorController.doctors['doctorData'][index];
                  return ListTile(
                    title: Text(doctor['doctor_Name'] ?? "Unknown"),
                    subtitle: Text("ID: ${doctor['doctor_ID']}"),
                  );
                },
              ),
            )),

            const SizedBox(height: 20),

            const Text("Drivers", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Obx(() => Expanded(
              child: ListView.builder(
                itemCount: driverController.drivers['driverData']?.length ?? 0,
                itemBuilder: (context, index) {
                  var driver = driverController.drivers['driverData'][index];
                  return ListTile(
                    title: Text(driver['driver_Name'] ?? "Unknown"),
                    subtitle: Text("ID: ${driver['driver_ID']}"),
                  );
                },
              ),
            )),
          ],
        ),
      ),
    );
  }
}
