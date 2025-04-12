import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/user_controller.dart';
import '../models/fuel_entry_model.dart';
import '../models/vehicle_details_model.dart';
import '../services/api_service.dart';
import '../theme.dart';

class FuelEntryScreen extends StatefulWidget {
  final VehicleDetailsModel vehicleData;


  const FuelEntryScreen({
    super.key,
    required this.vehicleData
  });

  @override
  State<FuelEntryScreen> createState() => _FuelEntryScreenState();
}

class _FuelEntryScreenState extends State<FuelEntryScreen> {
  final UserController userController = Get.find<UserController>();
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  final ApiService apiService = ApiService();
  bool isLoading = false;
  
  // Controllers
  final odometerController = TextEditingController();
  final odometerAtFuelStationController = TextEditingController();
  final odometerBackAtBaseController = TextEditingController();
  final fuelStationNameController = TextEditingController();
  final quantityController = TextEditingController();
  final unitPriceController = TextEditingController();
  final paymentRefNoController = TextEditingController();
  final billNoController = TextEditingController();

  // Variables
  int modeOfPayment = 0; // 0 for cash, 1 for petrol card
  String? odometerImageBase64;
  String? odometerImageName;
  String? billImageBase64;
  String? billImageName;
  double? latitude;
  double? longitude;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    setValues();
  }
  void setValues() {
    odometerController.text = "${widget.vehicleData.odometerBase}";
  }


  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
      });
      print(latitude);
      print(longitude);
    } catch (e) {
      Get.snackbar('Error', 'Could not get location: $e');
    }
  }

  Future<void> _takePicture(bool isOdometer) async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        final bytes = await image.readAsBytes();
        final base64String = base64Encode(bytes);
        
        setState(() {
          if (isOdometer) {
            odometerImageBase64 = base64String;
            odometerImageName = image.name;
          } else {
            billImageBase64 = base64String;
            billImageName = image.name;
          }
        });
      }
    } catch (e) {
      Get.snackbar('Error', 'Could not take picture: $e');
    }
  }
  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  Future<void> _submitFuelEntry() async {
    if (_formKey.currentState!.validate() &&
        odometerImageBase64 != null &&
        billImageBase64 != null &&
        latitude != null &&
        longitude != null) {
      
      setState(() {
        isLoading = true;
      });

      try {
        final now = DateTime.now();
        final formatted = "${now.year}-${_twoDigits(now.month)}-${_twoDigits(now.day)} "
            "${_twoDigits(now.hour)}:${_twoDigits(now.minute)}";

        final fuelEntry = FuelEntryModel(
          userId: int.parse(userController.userId.value),
          entryDateTime: formatted,
          vehicleId: widget.vehicleData.vehicleId,
          tripId: widget.vehicleData.schTripDetails.tripId.isEmpty?0:int.parse(widget.vehicleData.schTripDetails.tripId),
          caseId: widget.vehicleData.emgCaseDetails.caseNo.isEmpty?0:int.parse(widget.vehicleData.emgCaseDetails.caseNo),
          odometerLast: odometerController.text,
          odometerBase: "${widget.vehicleData.odometerBase}",
          odometer: odometerAtFuelStationController.text,
          odometerBackAtBase: odometerBackAtBaseController.text,
          fuelStationName: fuelStationNameController.text,
          quantity: double.parse(quantityController.text),
          unitPrice: double.parse(unitPriceController.text),
          modeOfPayment: modeOfPayment,
          paymentRefNo: paymentRefNoController.text,
          billNo: billNoController.text,
          docOdometerName: odometerImageName!,
          docBillName: "",
          // docBillName: billImageName!,
          latitude: latitude!,
          longitude: longitude!,
          docOdometer: "",
          // docOdometer: odometerImageBase64!,
          docBill: billImageBase64!,

        );
        print("fuelEntry");
        print(latitude);
        print(longitude);
        var tpvh = jsonEncode(fuelEntry);
        print(tpvh);
            print(fuelEntry.toJson());

        final response = await apiService.postRequest("/SetFuelRecord", fuelEntry.toJson());

        print(response);
        if (response != null) {

          if (response["result"] == 1) {
            // final ticketNumber = response["ticket_Number"] ?? 0;
            Get.back();
            Get.snackbar(
              "Success",
              "${response["message"]}",//
              backgroundColor: Colors.green,
              colorText: Colors.white,
              duration: const Duration(seconds: 7),
              overlayBlur: 2
            );
          clearAll();

            // Navigate back after success
          } else {
            Get.snackbar(
              "Error",
              response["message"] ?? "Failed to save fuel record",
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        } else {
          Get.snackbar(
            "Error",
            "Failed to connect to server",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } catch (e) {
        Get.snackbar(
          "Error",
          "An error occurred: $e",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      Get.snackbar(
        "Error",
        "Please fill all required fields and take both photos",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
  void clearAll(){
    // Controllers
    odometerController.text = "";
    odometerAtFuelStationController.text = "";
    odometerBackAtBaseController.text = "";
    fuelStationNameController.text = "";
    odometerController.text = "";
    unitPriceController.text = "";
    quantityController.text = "";
    paymentRefNoController.text = "";
    billNoController.text = "";


    // Variables
     modeOfPayment = 0; // 0 for cash, 1 for petrol card
     odometerImageBase64 = '';
     odometerImageName = '';
     billImageBase64 = '';
     billImageName = '';
     latitude = 0.0;
     longitude = 0.0;
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fuel Entry'),
        elevation: 0,
        backgroundColor: AppThemes.light.primaryColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppThemes.light.primaryColor.withOpacity(0.05),
              Colors.white,
            ],
          ),
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Odometer Reading
                    _buildInputCard(
                      icon: Icons.speed,
                      title: 'Odometer Reading',
                      controller: odometerController,
                      keyboardType: TextInputType.number,
                      edit: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter odometer reading';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Odometer at Fuel Station
                    _buildInputCard(
                      icon: Icons.speed,
                      title: 'Odometer at Fuel Station',
                      controller: odometerAtFuelStationController,
                      keyboardType: TextInputType.number,
                      edit: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter odometer reading';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Odometer Back at Base
                    _buildInputCard(
                      icon: Icons.speed,
                      title: 'Odometer Back at Base',
                      controller: odometerBackAtBaseController,
                      keyboardType: TextInputType.number,
                      edit: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter odometer back at base';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Fuel Station Name
                    _buildInputCard(
                      icon: Icons.local_gas_station,
                      title: 'Fuel Station Name',
                      controller: fuelStationNameController,
                      edit: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter fuel station name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Quantity
                    _buildInputCard(
                      icon: Icons.water_drop,
                      title: 'Quantity in Ltr',
                      controller: quantityController,
                      keyboardType: TextInputType.number,
                      edit: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter quantity';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Unit Price
                    _buildInputCard(
                      icon: Icons.attach_money,
                      title: 'Unit Price',
                      controller: unitPriceController,
                      keyboardType: TextInputType.number,
                      edit: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter unit price';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Mode of Payment
                    _buildPaymentModeSelector(),
                    const SizedBox(height: 16),

                    // Payment Reference Number
                    _buildInputCard(
                      icon: Icons.payment,
                      title: 'Payment Reference Number',
                      controller: paymentRefNoController,
                      edit: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter payment reference number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Bill Number
                    _buildInputCard(
                      icon: Icons.receipt,
                      title: 'Bill Number',
                      controller: billNoController,
                      edit: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter bill number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Odometer Photo
                    _buildPhotoSection(
                      title: 'Odometer Photo',
                      imageBase64: odometerImageBase64,
                      onTap: () => _takePicture(true),
                    ),
                    const SizedBox(height: 16),

                    // Bill Photo
                    _buildPhotoSection(
                      title: 'Bill Photo',
                      imageBase64: billImageBase64,
                      onTap: () => _takePicture(false),
                    ),
                    const SizedBox(height: 24),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _submitFuelEntry,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppThemes.light.primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'Submit',
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
            if (isLoading)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputCard({
    required IconData icon,
    required String title,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    required bool edit,
    String? Function(String?)? validator,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: edit ? Colors.red : Colors.grey.shade200),
      ),
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
                  TextFormField(
                    controller: controller,
                    keyboardType: keyboardType,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                    ),
                    style: GoogleFonts.montserrat(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    validator: validator,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentModeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mode of Payment',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: RadioListTile<int>(
                title: const Text('Cash'),
                value: 0,
                groupValue: modeOfPayment,
                onChanged: (value) {
                  setState(() {
                    modeOfPayment = value!;
                  });
                },
              ),
            ),
            Expanded(
              child: RadioListTile<int>(
                title: const Text('Petrol Card'),
                value: 1,
                groupValue: modeOfPayment,
                onChanged: (value) {
                  setState(() {
                    modeOfPayment = value!;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPhotoSection({
    required String title,
    required String? imageBase64,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          child: Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: imageBase64 != null
                ? Image.memory(
                    base64Decode(imageBase64),
                    fit: BoxFit.cover,
                  )
                : const Center(
                    child: Icon(
                      Icons.camera_alt,
                      size: 50,
                      color: Colors.grey,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

}