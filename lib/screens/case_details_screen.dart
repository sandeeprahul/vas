import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/blocks_controller.dart';
import '../controllers/districts_controller.dart';
import '../controllers/live_stock_controller.dart';
import '../controllers/location_sub_type_controller.dart';
import '../controllers/location_type_controller.dart';
import '../controllers/user_controller.dart';
import '../widgets/trip_details_widget.dart';
import 'cattle_registration_screen.dart';
import '../theme.dart';

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
        'AmbulanceNo': _ambulanceNoController.text,
        'OwnersContactNo': _ownerContactNoController.text,
        'Owners Name': _ownerNameController.text,
        'District': _districtController.text,
        'Block': _blockController.text,
        'Village': _villageController.text,
        'Category': _category,
      };
      final liveCaseController = Get.put(LivestockController());
      liveCaseController.saveFormData(formData);
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
  final LivestockController liveCaseController = Get.put(LivestockController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tripController.fetchTripDetails();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Obx(() {
                  final trip = tripController.tripDetails.value;
                  if(tripController.isLoading.value){
                    return const Center(child: CircularProgressIndicator(),);
                  }
                  if (trip == null) {
                    return const Center(child: Text("No trip details available"));
                  }
                  return _buildInputCard(
                    icon: Icons.emergency,
                    title: 'Ambulance No',
                    value: trip.vehicle,
                    edit: false,
                  );
                }),
                const SizedBox(height: 16),

                // Owner's Contact No
                _buildInputCard(
                  icon: Icons.phone,
                  title: 'Owner\'s Contact No',

                  controller: _ownerContactNoController,
                  keyboardType: TextInputType.phone,
                  edit: false,
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

                // Owner's Name
                _buildInputCard(
                  icon: Icons.person,
                  title: 'Owner\'s Name',
                  controller: _ownerNameController,
                  edit: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the owner\'s name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // District Dropdown
                Obx(() => GestureDetector(
                  onTap: () {
                    _showSelectionDialog(
                      "District",
                      districtsController.selectedDistrict,
                      districtsController.selectedDistrictId,
                      districtsController.districtsList,
                      "id",
                      "name",
                    );
                  },
                  child: _buildInputCard(
                    icon: Icons.location_city,
                    title: 'District',
                    value: districtsController.selectedDistrict.value,
                    edit: false,
                  ),
                )),
                const SizedBox(height: 16),


                // Block Dropdown
                _buildDropdownField(
                  "Block",
                  blocksController.selectedBlock,
                  blocksController.selectedBlockId,
                  blocksController.blocksList,
                  "blockId",
                  "name",Icons.streetview
                ),
                const SizedBox(height: 16),

                // Location Type Dropdown
                Obx(() => GestureDetector(
                  onTap: () {
                    _showSelectionDialog(
                      "LocationType",
                      locationTypeController.selectedLocationType,
                      locationTypeController.selectedLocationTypeId,
                      locationTypeController.locationTypes,
                      "stopType_ID",
                      "stopType_Name",
                    );
                  },
                  child: _buildInputCard(
                    icon: Icons.place,
                    title: 'Location Type',
                    value: locationTypeController.selectedLocationType.value,
                    edit: false,
                  ),
                )),
                const SizedBox(height: 16),

                // Location Dropdown
                _buildDropdownField(
                  "Location",
                  locationSubTypeController.selectedLocationName,
                  locationSubTypeController.selectedLocationId,
                  locationSubTypeController.location,
                  "stop_ID",
                  "stop_Name",
                    Icons.add_location_alt_rounded

                ),
                const SizedBox(height: 16),

                // Category Dropdown
                _buildInputCard(
                  icon: Icons.category,
                  title: 'Category',
                  value: _category,
                  edit: false,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Select Category'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: _categories.map((category) {
                            return ListTile(
                              title: Text(category),
                              onTap: () {
                                setState(() {
                                  _category = category;
                                });
                                Get.back();
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppThemes.light.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Cattle Details',
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputCard({
    required IconData icon,
    required String title,
    TextEditingController? controller,
    String? value,
    TextInputType keyboardType = TextInputType.text,
    required bool edit,
    String? Function(String?)? validator,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: edit ? Colors.red : Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: onTap,
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
                    if (controller != null)
                      TextFormField(
                        controller: controller,
                        keyboardType: keyboardType,
                        decoration:  InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 8),
                          hintText: "$title"
                        ),
                        style: GoogleFonts.montserrat(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        validator: validator,
                      )
                    else
                      Text(
                        value ?? '',
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
      ),
    );
  }
  Widget _buildDropdownField(
      String title,
      RxString selectedValue, // Stores valueField (UI)
      RxString selectedKey, // Stores keyField (Submission)
      List<dynamic> dataList,
      String keyField,
      String valueField,     IconData icon,
      ) {
    return Obx(() => Card(
      elevation: 0,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),

        side: BorderSide(color:  Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: () {
          _showSelectionDialog(title, selectedValue, selectedKey, dataList,
              keyField, valueField);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    Text(
                      selectedValue.value,
                      style: TextStyle(
                          color: selectedValue.value == title
                              ? Colors.grey
                              : Colors.black),
                    ),
                  ],
                ),
              ),
              // const Icon(Icons.arrow_drop_down),
            ],
          ),
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
  final UserController userController = Get.put(UserController());

  final DistrictsController districtsController =
  Get.put(DistrictsController());
  final BlocksController blocksController = Get.put(BlocksController());
  final LocationTypeController locationTypeController =
  Get.put(LocationTypeController());
  final LocationSubTypeController locationSubTypeController =
  Get.put(LocationSubTypeController());


}
