import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vas/controllers/user_controller.dart';
import 'package:vas/widgets/trip_history_seek_bar.dart';
import 'dart:convert';

import '../data/TripDetails.dart';
import '../services/api_service.dart';
import '../utils/showOdodmeterDialog.dart';

// Model Class

// Controller
class TripController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    // loadTripDetails("StartTrip");
    fetchTripDetails();
  }

  Rxn<TripDetailsModel> tripDetails = Rxn<TripDetailsModel>();
  var isLoading = false.obs;

  var tripStatus = 9.obs;
  var tripStartTime = ''.obs;
  var tripSeenArrivalTime = ''.obs;
  var tripSeenDepartureTime = ''.obs;
  final ApiService _apiService = ApiService();

  Future<void> loadTripDetailsssss(String tripType) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(tripType);
    int? tripStatusInt = prefs.getInt('tripStatus') ?? 9;
    String? tripTime = prefs.getString('tripStartTime') ?? '';
    String? tripSeenArrivalTimeString =
        prefs.getString('tripSeenArrivalTime') ?? '';
    String? tripSeenDepartureTimeString =
        prefs.getString('tripSeenDepartureTime') ?? '';

    if (jsonString != null) {
      Map<String, dynamic> jsonData = jsonDecode(jsonString);
      tripDetails.value = TripDetailsModel.fromJson(jsonData["payload"]);
    }
    // Set values for observables
    tripStatus.value = tripStatusInt;
    tripStartTime.value = tripTime;
    tripSeenArrivalTime.value = tripSeenArrivalTimeString;
    tripSeenDepartureTime.value = tripSeenDepartureTimeString;
    print("  tripDetails.value ");
    print("  ${tripDetails.value!.tripId} ");
  }

  Future<TripDetailsModel?> loadTripDetails(String tripType) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonData = prefs.getString(tripType);

    if (jsonData != null) {
      try {
        Map<String, dynamic> tripData = jsonDecode(jsonData);
        Map<String, dynamic> tripDetailsJson = tripData["payload"];

        TripDetailsModel tripDetails =
            TripDetailsModel.fromJson(tripDetailsJson);

        fetchTripDetails(); // Or call with a trigger/ID if needed
        // fetchTripDetails(tripDetails.deptId,tripDetails.vehicleId); // Or call with a trigger/ID if needed

        return tripDetails;
      } catch (e) {
        print("Error loading trip details: $e");
        return null;
      }
    } else {
      print("No trip data found in SharedPreferences.");
      return null;
    }
  }

  void fetchTripDetails() async {
    final UserController userController = Get.put(UserController());
    isLoading.value = true;

    final response = await _apiService.getRequestForMaster(
        "/getCurrentTripDetail/${userController.deptId.value}/${userController.userId.value}/2/1/1");
    print(response);
    // final response = await _apiService.getRequestForMaster(
    //     "/getCurrentTripDetail/${userController.deptId.value}/${userController.userId.value}/${userController.vehicleId.value}/1/1");
    // print(response);

    if (response != null &&
        response is Map<String, dynamic> &&
        response['records'] != null &&
        response['records'] is List &&
        response['records'].isNotEmpty) {
      try {
        tripDetails.value = TripDetailsModel.fromJson(response['records'][0]);
        print(tripDetails.value!.vehicle);
        print("${tripDetails.value!.vehicleId}");
        print(tripDetails.value!.doctor);
      } catch (e) {
        print("Parsing error: $e");
        tripDetails.value = null;
      }
    } else {
      print("No records found or invalid format");
      tripDetails.value = null;
    }

    isLoading.value = false;
  }

  void updateDeparture(int km) {

  }

  void closeTrip(int km) {}

  void updateReach(int km) {}
}

// Widget to Display Trip Details
class TripDetailsWidget extends StatelessWidget {
  final TripController controller = Get.put(TripController());

  TripDetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      final trip = controller.tripDetails.value;
      if (trip == null) {
        return const Center(child: Text(""));
      }

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Trip Id: ${trip.tripId}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            // Add spacing between title and details

            // Text("Trip ID: ${trip.tripId}"),
            TripHistorySeekBar(
              currentStep: controller.tripStatus.value,
            ),
            Row(
              children: [
                const Icon(Icons.location_on), // Location Icon
                const SizedBox(width: 4),
                Expanded(
                    child: Text(
                  trip.location,
                  maxLines: 2,
                )),
              ],
            ),
            // Text("Location: ${trip.locationName}"),
            Row(
              children: [
                const Icon(Icons.person), // Driver Icon
                const SizedBox(width: 4),
                Text("Driver: ${trip.driver}"),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.directions_car), // Vehicle Icon
                const SizedBox(width: 4),
                Text("Vehicle: ${trip.vehicle}"),
              ],
            ),
            Visibility(
              visible: controller.tripStatus.value == 0 ? true : false,
              child: Row(
                children: [
                  const Icon(Icons.directions_car), // Vehicle Icon
                  const SizedBox(width: 4),
                  Text("StartTime: ${controller.tripStartTime}"),
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.tripStatus.value == 3
                    ? null
                    : () {
                        getOdometerReading();
                      },
                child: Obx(() {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: controller.tripStatus.value == 1
                        ? const Text('Departure',
                            style: TextStyle(fontWeight: FontWeight.bold))
                        : controller.tripStatus.value == 2
                            ? const Text(
                                'Close',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            : controller.tripStatus.value == 3
                                ? const Text(
                                    '',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                : const Text(
                                    'Seen Arrival',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                  );
                }),
              ),
            ),
          ],
        ),
      );
    });
  }

  void getOdometerReading() async {
    String? odometerValue = await showOdometerDialog(Get.context!);
    if (odometerValue != null) {
      print("Odometer Entered: $odometerValue");
    }
  }
}
