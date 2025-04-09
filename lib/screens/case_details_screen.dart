import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/blocks_controller.dart';
import '../controllers/districts_controller.dart';
import '../controllers/location_sub_type_controller.dart';
import '../controllers/location_type_controller.dart';
import '../controllers/user_controller.dart';
import '../widgets/trip_details_widget.dart';
import 'cattle_registration_screen.dart';

class CaseDetailsScreen extends StatefulWidget {
  const CaseDetailsScreen({super.key});

  @override
  _CaseDetailsScreenState createState() => _CaseDetailsScreenState();
}

class _CaseDetailsScreenState extends State<CaseDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ambulanceNoController = TextEditingController();
  final _ownerContactNoController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _districtController = TextEditingController();
  final _blockController = TextEditingController();
  final _villageController = TextEditingController();
  String _category = 'OBC'; // Default category

  final List<String> _categories = ['OBC', 'SC', 'ST', 'General'];

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Process the form data
      final formData = {
        'Ambulance No': _ambulanceNoController.text,
        'Owner\'s Contact No': _ownerContactNoController.text,
        'Owner\'s Name': _ownerNameController.text,
        'District': _districtController.text,
        'Block': _blockController.text,
        'Village': _villageController.text,
        'Category': _category,
      };
      print('Form Data: $formData');
      // Navigate to the next screen (Cattle Registration)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CattleRegistrationScreen(),
        ),
      );
    }
  }

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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Obx(() {
                final trip = tripController.tripDetails.value;
                if (trip == null) {
                  return const Center(child: Text("No trip details available"));
                }
              return   Row(
                  children: [
                    const Expanded(child: Text('Ambulance No:')),
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
                                trip.vehicle,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                            // const Icon(Icons.arrow_drop_down), // Dropdown icon
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ownerContactNoController,
                maxLength: 10,
                decoration: const InputDecoration(
                  labelText: 'Owner\'s Contact No',
                  hintText: 'Enter Owner\'s Contact Number',
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the contact number';
                  }
                  if (value.length != 10) {
                    return 'Contact number must be 10 digits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ownerNameController,
                decoration: const InputDecoration(
                  labelText: 'Owner\'s Name',
                  hintText: 'Enter Owner\'s Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the owner\'s name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Obx(() => GestureDetector(
                onTap: () {
                  _showSelectionDialog(
                      "District",
                      districtsController.selectedDistrict,
                      districtsController.selectedDistrictId,
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
                        districtsController.selectedDistrict.value,
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
                  blocksController.selectedBlock,
                  blocksController.selectedBlockId,
                  blocksController.blocksList,
                  "blockId",
                  "name"),
              //    blocksController.getBlocks(districtsController.selectedDistrictId.value,userController.userId.value);
              const SizedBox(
                height: 8,
              ),

              const SizedBox(
                height: 8,
              ),

              Obx(() => GestureDetector(
                onTap: () {
                  _showSelectionDialog(
                      "LocationType",
                      locationTypeController.selectedLocationType,
                      locationTypeController.selectedLocationTypeId,
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
                        locationTypeController.selectedLocationType.value,
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

              _buildDropdownField(
                  "Location",
                  locationSubTypeController.selectedLocationName,
                  locationSubTypeController.selectedLocationId,
                  locationSubTypeController.location,
                  "stop_ID",
                  "stop_Name"),


              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Category'),
                value: _category,
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _category = value!;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Cattle Details'),
              ),
            ],
          ),
        ),
      ),
    );

  }
  final UserController userController = Get.put(UserController());

  final DistrictsController districtsController =
  Get.put(DistrictsController());
  final BlocksController blocksController = Get.put(BlocksController());
  final LocationTypeController locationTypeController =
  Get.put(LocationTypeController());
  final LocationSubTypeController locationSubTypeController =
  Get.put(LocationSubTypeController());

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
              selectedValue.value,
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


}
