import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import '../controllers/user_controller.dart';
import '../models/fuel_entry_model.dart';
import '../models/vehicle_details_model.dart';
import '../services/api_service.dart';
import '../theme.dart';
import 'package:http/http.dart' as http;

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
  final UserController userController = Get.put(UserController());
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
    // Request location permission
    var status = await Permission.location.request();

    if (status.isGranted) {
      try {
        LocationSettings locationSettings = const LocationSettings(
          accuracy: LocationAccuracy.bestForNavigation,
          distanceFilter: 0,
        );
        Position position = await Geolocator.getCurrentPosition(
          locationSettings: locationSettings,
        );
        setState(() {
          latitude = position.latitude;
          longitude = position.longitude;
        });
        print("Latitude: $latitude");
        print("Longitude: $longitude");
      } catch (e) {
        Get.snackbar('Error', 'Could not get location: $e');
      }
    } else if (status.isDenied) {
      Get.defaultDialog(
        title: "Permission Denied",
        middleText: "Location permission is required to get your current position.",
        confirm: ElevatedButton(
          onPressed: () {
            openAppSettings(); // Open settings to enable manually
            Get.back();
          },
          child: const Text("Open Settings"),
        ),
        cancel: TextButton(
          onPressed: () => Get.back(),
          child: const Text("Cancel"),
        ),
      );
    } else if (status.isPermanentlyDenied) {
      Get.defaultDialog(
        title: "Permission Permanently Denied",
        middleText: "Please enable location permission from app settings.",
        confirm: ElevatedButton(
          onPressed: () {
            openAppSettings();
            Get.back();
          },
          child: const Text("Open Settings"),
        ),
        cancel: TextButton(
          onPressed: () => Get.back(),
          child: const Text("Cancel"),
        ),
      );
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
            odometerImageName = image.path;
            print(odometerImageName);
          } else {
            billImageBase64 = base64String;
            billImageName = image.path;
            print(billImageName);

          }
        });
      }
    } catch (e) {
      Get.snackbar('Error', 'Could not take picture: $e');
    }
  }
  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  String _formatDateTime() {
    final now = DateTime.now();
    return "${now.year}-${_twoDigits(now.month)}-${_twoDigits(now.day)} ${_twoDigits(now.hour)}:${_twoDigits(now.minute)}";
  }

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
        // Create request body
        final requestBody = {
          'user_ID': userController.userId.value,
          'entry_DateTime': _formatDateTime(),
          'vehicle_ID': widget.vehicleData.vehicleId.toString(),
          'trip_ID': widget.vehicleData.schTripDetails.tripId.isEmpty?"0":int.parse(widget.vehicleData.schTripDetails.tripId).toString(),
          'case_ID': widget.vehicleData.emgCaseDetails.caseNo.isEmpty?"0":int.parse(widget.vehicleData.emgCaseDetails.caseNo).toString(),
          'odometer_Last': odometerController.text,
          'odometer_Base': "${widget.vehicleData.odometerBase}",
          'odometer': odometerAtFuelStationController.text,
          'odometer_Back_At_Base': odometerBackAtBaseController.text,
          'fuel_Station_Name': fuelStationNameController.text,
          'quantity': quantityController.text,
          'unit_Price': unitPriceController.text,
          'mode_Of_Payment': modeOfPayment.toString(),
          'payment_Ref_No': paymentRefNoController.text,
          'bill_No': billNoController.text,
          'doc_Odometer': odometerImageBase64!,
          'doc_Odometer_Name': 'odo_${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}.jpg',
          'doc_Bill': billImageBase64!,
          'doc_Bill_Name': 'bill_${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}.jpg',
          'latitude': latitude.toString(),
          'longitude': longitude.toString(),
        };

        print("REQUEST BODY:");
        print(requestBody);

        // Send the request
        final response = await http.post(
          Uri.parse('http://49.207.44.107/mvas/SetFuelRecord'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(requestBody),
        );

        print("RESPONSE STATUS: ${response.statusCode}");
        print("RESPONSE BODY: ${response.body}");

        if (response.statusCode == 200) {
          final responseBody = jsonDecode(response.body);
          if (responseBody['result'] == 0) {
            // final ticketNumber = responseBody['ticket_Number'];
            Get.back();

            Get.dialog(
              AlertDialog(
                title: const Text('Alert!'),
                content: Text("${responseBody['message']}\n${responseBody['ticket_Number']}" ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            );

          } else {
            Get.dialog(
              AlertDialog(
                title: const Text('Error'),
                content: Text(responseBody['message'] ?? 'Unknown error'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          }
        } else {
          final responseBody = jsonDecode(response.body);
          Get.dialog(
            AlertDialog(
              title: const Text('Error'),
              content: Text(responseBody['reasonPhrase'] ?? 'Unknown error'),
              actions: [
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      } catch (e) {
        print("ERROR: $e");
        Get.dialog(
          AlertDialog(
            title: const Text('Error'),
            content: Text('Exception: $e'),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      Get.dialog(
        AlertDialog(
          title: const Text('Error'),
          content: const Text('Please fill all required fields and capture both images'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('OK'),
            ),
          ],
        ),
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

  // Add this method to calculate total
  String _calculateTotal() {
    if (quantityController.text.isNotEmpty && unitPriceController.text.isNotEmpty) {
      try {
        final quantity = double.parse(quantityController.text);
        final unitPrice = double.parse(unitPriceController.text);
        final total = quantity * unitPrice;
        return '₹${total.toStringAsFixed(2)}';
      } catch (e) {
        return '₹0.00';
      }
    }
    return '₹0.00';
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
                  AppThemes.light.primaryColor,
                 Colors.black,
                 Colors.black,
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
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: Colors.grey.shade200),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppThemes.light.primaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(Icons.attach_money, color: AppThemes.light.primaryColor),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Unit Price',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                      TextFormField(
                                        controller: unitPriceController,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          isDense: true,
                                          contentPadding: EdgeInsets.symmetric(vertical: 8),
                                        ),
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter unit price';
                                          }
                                          return null;
                                        },
                                        onChanged: (value) {
                                          setState(() {}); // Trigger rebuild to update total
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Total Amount: ',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  _calculateTotal(),
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppThemes.light.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 34),

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
                      title: 'Take Odometer Photo',
                      imageBase64: odometerImageBase64,
                      onTap: () => _takePicture(true),
                    ),
                    const SizedBox(height: 16),

                    // Bill Photo
                    _buildPhotoSection(
                      title: 'Take Bill Photo',
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
                          backgroundColor:               Colors.white,

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
                                'SUBMIT',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
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
                color: Colors.white,
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 6,),
                      Text('Please wait...'),

                    ],
                  ),
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
    VoidCallback? onChanged,
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
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Colors.black,
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
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    validator: validator,
                    // onChanged: onChanged,
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
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          margin: EdgeInsets.all(4),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius: BorderRadius.circular(12),

          ),

          child: Row(
            children: [
              Expanded(
                child: RadioListTile<int>(
                  // activeColor: Colors.white,
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
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          child: SizedBox(
            height: 150,

            child: Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                // color: Colors.white,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: imageBase64 != null
                  ? Image.memory(
                      base64Decode(imageBase64),
                      fit: BoxFit.cover,
                    )
                  : Column(
                mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera,
                        size: 50,
                        color: Colors.grey,
                      ),
                      Text(
                        "Click Here",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
            ),
          ),
        ),

      ],
    );
  }

}