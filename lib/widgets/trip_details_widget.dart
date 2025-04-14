import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vas/controllers/user_controller.dart';
import 'package:vas/widgets/trip_history_seek_bar.dart';
import 'dart:convert';

import '../controllers/ambulance_controller.dart';
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

  void fetchTripDetails() async {
    isLoading.value = true;

    final UserController userController = Get.put(UserController());
    final ambulanceController = Get.put(AmbulanceController());

    try {

      final response = await _apiService
          .getRequestForMaster(
              "/getCurrentTripDetail/${userController.deptId.value}/${userController.userId.value}/3/1/1");
      print(response);
      var vehicleId = ambulanceController.selectedAmbulanceId.value.isEmpty?userController.vehicleId.value:ambulanceController.selectedAmbulanceId.value;
      // final response = await _apiService.getRequestForMaster(
      //     "/getCurrentTripDetail/${userController.deptId.value}/${userController.userId.value}/$vehicleId/1/1");
      print(response);
      print(
          "http://49.207.44.107/mvas/getCurrentTripDetail/${userController.deptId.value}/${userController.userId.value}/${ambulanceController.selectedAmbulanceId.value}/1/1");
      // tripDetails.value = null;

      if (response != null &&
          response is Map<String, dynamic> &&
          response['records'] != null &&
          response['records'] is List &&
          response['records'].isNotEmpty) {
        try {
          if (response['total_Records'] != 0) {
            tripDetails.value =
                TripDetailsModel.fromJson(response['records'][0]);
          }
        } catch (e) {
          tripDetails.value = null;
        }
      } else {
        print("No records found or invalid format");
        tripDetails.value = null;
        isLoading.value = false;
        Get.snackbar('Alert', 'Error:No records found or invalid format',overlayBlur: 2,backgroundColor: Colors.red);

      }

    } catch (e) {
      isLoading.value = false;

      Get.snackbar('Alert', 'Error:$e',overlayBlur: 2,backgroundColor: Colors.red);
    }finally{
      isLoading.value = false;

    }
  }

  void updateDeparture(int km) {}

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
