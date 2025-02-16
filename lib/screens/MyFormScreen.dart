import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vas/controllers/DriversController.dart';
import 'package:vas/controllers/blocks_controller.dart';
import 'package:vas/controllers/districts_controller.dart';
import 'package:vas/controllers/doctors_controller.dart';

import '../controllers/trip_from_controller.dart';

class MyFormScreen extends StatelessWidget {
  final FormController controller = Get.put(FormController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Submit Form"), backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [

            _buildDropdownField("District", controller.selectedDistrict,
                controller.selectedDistrictId,
                controller.districts, "districtId", "districtName"),

            _buildDropdownField(
                "Block", controller.selectedBlock,controller.selectedBlockId, controller.blocks, "blockId",
                "blockName"),
            _buildTextField("Ambulance Number", controller.ambulanceController),
            _buildDropdownField(
                "Doctor", controller.selectedDoctor, controller.selectedDoctorId,controller.doctors,
                "doctor_ID", "doctor_Name"),
            _buildDropdownField(
                "Driver", controller.selectedDriver, controller.selectedDriverId,controller.drivers,
                "driver_ID", "driver_Name"),
            // _buildDropdownField("Doctor", controller.selectedDoctor, doctorController.doctors.values.toList().obs, "doctorId", "doctorName"),
            // _buildDropdownField("Driver", controller.selectedDriver, driverController.drivers.values.toList().obs, "driverId", "driverName"),
            _buildTextField("Base Odometer", controller.baseOdometerController),
            const SizedBox(height: 20),
            Obx(() =>
                ElevatedButton(
                  onPressed: controller.isLoading.value ? null : controller
                      .submitForm,
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      textStyle: const TextStyle(fontSize: 16)),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Submit"),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField(
      String title,
      RxString selectedValue, // Stores valueField (UI)
      RxString selectedKey,   // Stores keyField (Submission)
      List<dynamic> dataList,
      String keyField,
      String valueField) {
    return Obx(() => GestureDetector(
      onTap: () {
        _showSelectionDialog(title, selectedValue, selectedKey, dataList, keyField, valueField);
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
              selectedValue.value,
              style: TextStyle(color: selectedValue.value == title ? Colors.grey : Colors.black),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    ));
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
          height: 300, // ✅ Define height to avoid intrinsic dimensions issue
          width: double.maxFinite, // ✅ Ensures it takes full width
          child: SingleChildScrollView( // ✅ Wrap with SingleChildScrollView
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: dataList.map((item) {
                return ListTile(
                  title: Text(item[valueField] ?? "Unknown"),
                  onTap: () {
                    selectedValue.value = item[valueField]?.toString() ?? ""; // ✅ Display valueField
                    selectedKey.value = item[keyField]?.toString() ?? ""; // ✅ Store keyField
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


  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: TextInputType.number,
    );
  }
}