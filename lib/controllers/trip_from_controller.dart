import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vas/controllers/ambulance_controller.dart';
import 'package:vas/controllers/blocks_controller.dart';
import 'package:vas/controllers/districts_controller.dart';
import 'package:vas/controllers/location_type_controller.dart';
import 'package:vas/controllers/user_controller.dart';
import 'package:vas/utils/showDialogNoContext.dart';
import 'package:vas/widgets/trip_details_widget.dart';
import '../data/TripDetails.dart';
import '../screens/manage_trip_arrival_departure_close_screen.dart';
import '../services/api_service.dart';
import '../shared_pref_helper.dart';
import '../utils/showLoadingDialog.dart';
import '../utils/showOdodmeterDialog.dart';
import 'location_sub_type_controller.dart';

class FormController extends GetxController {
  // Loading state
  final RxBool isLoading = false.obs;
  final ApiService apiService = ApiService();

  // Selected values for dropdowns
  // final RxString selectedDistrict = 'Select District'.obs;
  // final RxString selectedDistrictId = ''.obs; // ✅ Stores districtId for submission

  final RxString selectedBlock = 'Select Block'.obs;
  final RxString selectedBlockId = ''.obs; // ✅ Stores districtId for submission

  final RxString selectedDoctor = 'Select Doctor'.obs;
  final RxString selectedDoctorId =
      ''.obs; // ✅ Stores districtId for submission

  final RxString selectedDriver = 'Select Driver'.obs;
  final RxString selectedDriverId = ''.obs;

  // Input controllers
  final TextEditingController ambulanceController = TextEditingController();
  TextEditingController baseOdometerController = TextEditingController();

  // Data lists
  final RxList<dynamic> districts = <dynamic>[].obs;
  final RxList<dynamic> blocks = <dynamic>[].obs;
  final RxList<dynamic> doctors = <dynamic>[].obs;
  final RxList<dynamic> drivers = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadLastSyncedData();
    loadTripDetails("StartTrip"); // Load previously saved trip details
  }

  /// Loads last synced API data from SharedPreferences
  Future<void> loadLastSyncedData() async {
    isLoading.value = true;
    try {
      // Load districts
      // var districtData = await SharedPrefHelper.getApiData('/GetDistricts');
      // districts.value = (districtData is List) ? districtData : [];

      // Load blocks
      var blockData = await SharedPrefHelper.getApiData('/GetBlocks');
      blocks.value = (blockData is List) ? blockData : [];

      // Load doctors
      var doctorData = await SharedPrefHelper.getApiData('/GetDoctors');
      doctors.value = (doctorData is List &&
              doctorData.isNotEmpty &&
              doctorData[0] is Map<String, dynamic>)
          ? doctorData[0]['doctorData'] ?? []
          : [];

      // Load drivers
      var driverData = await SharedPrefHelper.getApiData('/GetDrivers');
      drivers.value = (driverData is List &&
              driverData.isNotEmpty &&
              driverData[0] is Map<String, dynamic>)
          ? driverData[0]['driverData'] ?? []
          : [];
    } catch (e) {
      print("Error loading last synced data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Submits form data to the backend
  Future<void> submitForm() async {
    isLoading.value = true;
    // showLoadingDialog();
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      UserController userController = Get.put(UserController());
      LocationSubTypeController locationSubTypeController =
          Get.put(LocationSubTypeController());
      LocationTypeController locationTypeController =
          Get.put(LocationTypeController());
      AmbulanceController ambulanceController = Get.put(AmbulanceController());
      BlocksController blocksController = Get.put(BlocksController());
      DistrictsController districtsController = Get.put(DistrictsController());
      final Map<String, dynamic> formData = {
        "depT_ID": userController.deptId.value,
        "user_ID": userController.userId.value,
        "driver_ID": selectedDriverId.value,
        "doctor_ID": "23",
        // "doctor_ID": selectedDoctorId.value,
        "zone_ID": districtsController.selectedDistrictId.value,
        "block_ID": blocksController.selectedBlockId.value,
        "location_ID": locationSubTypeController.selectedLocationId.value,
        "address": "",
        "vehicle_ID": ambulanceController.selectedAmbulanceId.value,
        // "base_KM": "",
        "base_KM": baseOdometerController.value.text,
        "latitude": position.latitude,
        "longitude": position.longitude,
        "device_Regn_ID": userController.deviceRegnId.value,
        "imeI_Number": userController.imeiNumber.value,
        "os_Version": "13"
      };

      //Response
      //{result: 1, message: Trip created, trip_ID: 25021900001, start_Time: 2025-02-19 23:53:22}
      //sending payload
      // {depT_ID: 3, user_ID: 1888, driver_ID: 819, doctor_ID: 23,
      // zone_ID: 3, block_ID: 22, location_ID: 43190, address: ,
      // vehicle_ID: 3, base_KM: 2.0, latitude: 16.470866, longitude: 80.6065381,
      // device_Regn_ID: , imeI_Number: 0, os_Version: 13}

      print("Submitting Form Data: $formData");

      // Make API POST request
      final response = await apiService.postRequest("/StartTrip", formData);

      if (response != null) {
        isLoading.value = false;
        // hideLoadingDialog();

        print("Form submitted successfully: $response");
        // Form submitted successfully: {result: 0, message: Vehicle already on an emergency trip, trip_ID: 0, start_Time: null}
        // Handle success (e.g., show success message, navigate, etc.)

        if (response['result'] == "1") {
          int tripId = response['trip_ID']; // Extract trip ID

          TripDetailsModel tripDetails = TripDetailsModel.fromJson(formData);
          final SharedPreferences prefs = await SharedPreferences.getInstance();

          await saveTripDetails("StartTrip", tripId, tripDetails,
              "${response['start_Time']}");

          clearAllFields();
          showErrorDialog('Alert', "${response["message"]}");
          Get.to(const ManageTripArrivalDepartureCloseScreen()); // Closes the current page

        } else {
          saveTempDetails();
          showErrorDialog('Alert', "${response["message"]}");
          Get.to(const ManageTripArrivalDepartureCloseScreen()); // Closes the current page

          // clearAllFields();
        }
      } else {
        print("Failed to submit form:$response");
        // Handle failure (e.g., show error message)
        showErrorDialog('Failure', "Trip Start Failed");
      }
      // TODO: Implement API POST request here
    } catch (e) {
      // isLoading.value = false;
      print("Submitting Form Error: $e");
      showErrorDialog('Failure', "$e");
    } finally {
      isLoading.value = false;
      // hideLoadingDialog();
    }
  }

  Future<void> saveTripDetails(
      String tripType, int tripId, TripDetailsModel tripDetails,String startTime) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    UserController userController = Get.find<UserController>();
    LocationSubTypeController locationSubTypeController =
        Get.find<LocationSubTypeController>();
    LocationTypeController locationTypeController =
        Get.find<LocationTypeController>();
    AmbulanceController ambulanceController = Get.find<AmbulanceController>();
    BlocksController blocksController = Get.find<BlocksController>();
    DistrictsController districtsController = Get.find<DistrictsController>();

    // Combine tripId and tripDetails into a single object
    Map<String, dynamic> tripData = {
      "trip_ID": tripId,
      "payload": {
        ...tripDetails.toJson(),
        "vehicle_Name": ambulanceController.selectedAmbulanceName.value,
        "location_Name": locationSubTypeController.selectedLocationName.value,
        "block_Name": blocksController.selectedBlock.value,
        "zone_Name": districtsController.selectedDistrict.value,
        "doctor_Name": "Dr. John Doe", // Replace with actual doctor selection
        "driver_Name": selectedDriver.value,
      },
    };
    print("saved");
    print(tripData);

    await prefs.setString(tripType, jsonEncode(tripData));
    await prefs.setInt("tripStatus",1);
    await prefs.setString("tripStartTime",startTime);
    await prefs.setString("tripSeenArrivalTime",'');
    await prefs.setString("tripSeenDepartureTime",'');

    // loadTripDetails("StartTrip");
  }

  Rxn<TripDetailsModel> tripDetails = Rxn<TripDetailsModel>();

  Future<TripDetailsModel?> loadTripDetails(String tripType) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonData = prefs.getString(tripType);

    if (jsonData != null) {
      try {
        Map<String, dynamic> tripData = jsonDecode(jsonData);
        Map<String, dynamic> tripDetailsJson = tripData["payload"];

        tripDetails.value =
            TripDetailsModel.fromJson(tripDetailsJson);
        print("loadTripDetails");
        print(tripDetails.value?.tripId);
        return tripDetails.value;
      } catch (e) {
        print("Error loading trip details: $e");
        return null;
      }
    }
    else {
      print("No trip data found in SharedPreferences.");
      return null;
    }

  }




  void clearAllFields() {
    final locationTypeController = Get.find<LocationTypeController>();
    final locationSubTypeController = Get.find<LocationSubTypeController>();

    final ambulanceController = Get.find<AmbulanceController>();
    final blocksController = Get.find<BlocksController>();
    final districtsController = Get.find<DistrictsController>();
    selectedDriverId.value = "";
    selectedDriver.value = "Select Driver";
    selectedDoctorId.value = "";
    selectedDoctor.value = "Select Doctor";
    selectedBlockId.value = "";
    selectedBlock.value = "Select Block";
    baseOdometerController.text = "";
    locationSubTypeController.selectedLocationName.value = "Select Location";
    locationSubTypeController.selectedLocationId.value = "";
    locationTypeController.selectedLocationType.value = "Select LocationType";
    locationTypeController.selectedLocationTypeId.value = "";
    ambulanceController.selectedAmbulanceId.value = "";
    ambulanceController.selectedAmbulanceName.value = "Select Ambulance";
    blocksController.selectedBlockId.value = "";
    blocksController.selectedBlock.value = "Select Block";
    districtsController.selectedDistrictId.value = "";
    districtsController.selectedDistrict.value = "Select District";

    print("All fields have been cleared.");
  }

  Future<void> saveTempDetails() async {
    int tripId = 25021900002;
    TripDetailsModel tripDetails = TripDetailsModel(
      deptId: 3,
      userId: 1888,
      driverId: 819,
      driverName: "John Doe",
      doctorId: 23,
      doctorName: "Dr. Smith",
      zoneId: 3,
      zoneName: "Zone A",
      blockId: 22,
      blockName: "Block 22",
      locationId: 43190,
      locationName: "City Hospital",
      vehicleId: 3,
      vehicleName: "Ambulance 101",
      baseKm: 2.0,
      deviceRegnId: '',
      address: "",
      latitude: 16.470866,
      longitude: 80.6065381,
      imeiNumber: '0',
      osVersion: '13',
      tripId: tripId,
      startTime: '2025-02-19 23:53:22',
    );

    // Save trip details
    await saveTripDetails("StartTrip", tripId, tripDetails,'2025-02-19 23:53:22');
  }


  Future<void> submitFormSeen(String value) async {
    UserController userController = Get.find<UserController>();
    TripController tripController = Get.find<TripController>();

    // String? odometerValue = await showOdometerDialog(Get.context!);
    // if (odometerValue == null) return;


    Map<String, dynamic> requestData = {
      "deptId": int.tryParse(userController.deptId.value)??0,
      "userId": int.tryParse(userController.userId.value),
      "tripId": 25021900002,
      // "tripId": tripController.tripDetails.value?.tripId ?? 0,
      "odometer":double.tryParse(value) ?? 0.0, // Convert to integer
      "lat":16.470866 ,
      "lng": 80.6065381
    };
    print(requestData);


    showLoadingDialog(); // Show loading before API call


    try {

      final response = await apiService.postRequest("/TripSeenArrival", requestData);
      print("submitFormSeen");
      print(response);
      if (response != null) {
        hideLoadingDialog(); // Ensure loading dialog is dismissed


        if (response['result'] == 1) {
          int tripId = response['trip_ID']; // Extract trip ID
          Future.delayed(const Duration(milliseconds: 300), () {
            showErrorDialog("Alert!", "${response['message']}");
          });
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setInt("tripStatus",2);
          // await prefs.setString("tripTime",response['reach_Time']);
          await prefs.setString("tripSeenArrivalTime",response['reach_Time']);
          await prefs.setString("tripSeenDepartureTime",'');

        }else{
          Future.delayed(const Duration(milliseconds: 300), () {
            showErrorDialog("Alert!", "$response");
          });
        }

      }
      else{
        Future.delayed(const Duration(milliseconds: 300), () {
          showErrorDialog("Alert!", "$response");
        });
        hideLoadingDialog(); // Ensure loading dialog is dismissed

      }
    } catch (e) {
      // hideLoadingDialog(); // Ensure loading dialog is dismissed
      showErrorDialog("Alert!","Failed to start trip: $e");

      print("Failed to start trip: $e");
    }
    finally{
      hideLoadingDialog(); // Ensure loading dialog is dismissed

    }
  }
  Future<void> submitFormDeparture(String value) async {
    UserController userController = Get.find<UserController>();
    TripController tripController = Get.find<TripController>();

    // String? odometerValue = await showOdometerDialog(Get.context!);
    // if (odometerValue == null) return;


    Map<String, dynamic> requestData = {
      "deptId": int.tryParse(userController.deptId.value)??0,
      "userId": int.tryParse(userController.userId.value),
      "tripId": 25021900001,
      // "tripId": tripController.tripDetails.value?.tripId ?? 0,
      "odometer":double.tryParse(value) ?? 0.0, // Convert to integer
      "lat":16.470866 ,
      "lng": 80.6065381
    };
    print(requestData);


    showLoadingDialog(); // Show loading before API call


    try {

      final response = await apiService.postRequest("/TripSeenDeparture", requestData);
      print("submitFormDeparture");
      print(response);
      if (response != null) {
        hideLoadingDialog(); // Ensure loading dialog is dismissed


        if (response['result'] == 1) {
          int tripId = response['trip_ID']; // Extract trip ID
          Future.delayed(const Duration(milliseconds: 300), () {
            showErrorDialog("Alert!", "${response['message']}");
          });
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setInt("tripStatus",3);
          // await prefs.setString("tripSeenArrivalTime",response['depart_Time']);
          await prefs.setString("tripSeenDepartureTime",response['depart_Time']);

        }else{
          Future.delayed(const Duration(milliseconds: 300), () {
            showErrorDialog("Alert!", "$response");
          });
        }

      }
      else{
        Future.delayed(const Duration(milliseconds: 300), () {
          showErrorDialog("Alert!", "$response");
        });
        hideLoadingDialog(); // Ensure loading dialog is dismissed

      }
    } catch (e) {
      // hideLoadingDialog(); // Ensure loading dialog is dismissed
      showErrorDialog("Alert!","Failed to start trip: $e");

      print("Failed to start trip: $e");
    }
    finally{
      hideLoadingDialog(); // Ensure loading dialog is dismissed

    }
  }
  Future<void> submitFormClose(String value) async {
    UserController userController = Get.find<UserController>();
    TripController tripController = Get.find<TripController>();

    // String? odometerValue = await showOdometerDialog(Get.context!);
    // if (odometerValue == null) return;


    Map<String, dynamic> requestData = {
      "deptId": int.tryParse(userController.deptId.value)??0,
      "userId": int.tryParse(userController.userId.value),
      "tripId": 25021900001,
      // "tripId": tripController.tripDetails.value?.tripId ?? 0,
      "odometer":double.tryParse(value) ?? 0.0, // Convert to integer
      "lat":16.470866 ,
      "lng": 80.6065381
    };
    print(requestData);


    showLoadingDialog(); // Show loading before API call


    try {

      final response = await apiService.postRequest("/TripClose", requestData);
      print("submitFormClose");
      print(response);
      if (response != null) {
        hideLoadingDialog(); // Ensure loading dialog is dismissed


        if (response['result'] == 1) {
          int tripId = response['trip_ID']; // Extract trip ID
          Future.delayed(const Duration(milliseconds: 300), () {
            showErrorDialog("Alert!", "${response['message']}");
          });
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setInt("tripStatus",3);
          // await prefs.setString("tripSeenArrivalTime",response['depart_Time']);
          await prefs.setString("tripSeenDepartureTime",response['close_Time']);

        }else{
          Future.delayed(const Duration(milliseconds: 300), () {
            showErrorDialog("Alert!", "$response");
          });
        }

      }
      else{
        Future.delayed(const Duration(milliseconds: 300), () {
          showErrorDialog("Alert!", "$response");
        });
        hideLoadingDialog(); // Ensure loading dialog is dismissed

      }
    } catch (e) {
      // hideLoadingDialog(); // Ensure loading dialog is dismissed
      showErrorDialog("Alert!","Failed to start trip: $e");

      print("Failed to start trip: $e");
    }
    finally{
      hideLoadingDialog(); // Ensure loading dialog is dismissed

    }
  }
}
