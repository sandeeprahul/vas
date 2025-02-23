import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vas/widgets/trip_history_seek_bar.dart';
import 'dart:convert';

import '../data/TripDetails.dart';
import '../utils/showOdodmeterDialog.dart';

// Model Class

// Controller
class TripController extends GetxController {
  // Rxn<TripDetailsModel> tripDetails = Rxn<TripDetailsModel>();

  /* Future<void> loadTripDetails(String tripType) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonData = prefs.getString(tripType);

    if (jsonData != null) {
      tripDetails.value = TripDetailsModel.fromJsonString(jsonData);
    }
    print("loadTripDetails");
    print(tripDetails.value?.tripId);
  }*/

  @override
  void onInit() {
    super.onInit();
    loadTripDetails("StartTrip");
  }

  Rxn<TripDetailsModel> tripDetails = Rxn<TripDetailsModel>();

  var tripStatus = 9.obs;
  var tripStartTime = ''.obs;
  var tripSeenArrivalTime = ''.obs;
  var tripSeenDepartureTime = ''.obs;

  Future<void> loadTripDetails(String tripType) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(tripType);
    int? tripStatusInt = prefs.getInt('tripStatus')??9;
    String? tripTime = prefs.getString('tripStartTime')??'';
    String? tripSeenArrivalTimeString = prefs.getString('tripSeenArrivalTime')??'';
    String? tripSeenDepartureTimeString = prefs.getString('tripSeenDepartureTime')??'';


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

  Future<TripDetailsModel?> loadTripDetailsOriginal(String tripType) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonData = prefs.getString(tripType);

    if (jsonData != null) {
      try {
        Map<String, dynamic> tripData = jsonDecode(jsonData);
        Map<String, dynamic> tripDetailsJson = tripData["payload"];

        TripDetailsModel tripDetails =
            TripDetailsModel.fromJson(tripDetailsJson);

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
}

// Widget to Display Trip Details
class TripDetailsWidget extends StatelessWidget {
  final TripController controller = Get.put(TripController());

  TripDetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
  return  Obx(() {
      final trip = controller.tripDetails.value;
      if (trip == null) {
        return const Center(child: Text("No trip details available."));
      }

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        margin: const EdgeInsets.symmetric(horizontal: 16, ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          image: DecorationImage(
            image: const AssetImage(
              'assets/trip_image_icon.png',
            ),
            // fit: BoxFit.values,
            // centerSlice: Rect.fromLTRB(10, 10, 20, 20), // Example: define the stretchable region

            // alignment: Alignment.center, //
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.96),
              // Adjust opacity here (0.0 to 1.0)
              BlendMode.srcOver,
            ),
          ),
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
             TripHistorySeekBar(currentStep:controller.tripStatus.value ,),
            Row(
              children: [
                const Icon(Icons.location_on), // Location Icon
                const SizedBox(width: 4),
                Expanded(
                    child: Text(
                      trip.locationName,
                      maxLines: 2,
                    )),
              ],
            ),
            // Text("Location: ${trip.locationName}"),
            Row(
              children: [
                const Icon(Icons.person), // Driver Icon
                const SizedBox(width: 4),
                Text("Driver: ${trip.driverName}"),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.directions_car), // Vehicle Icon
                const SizedBox(width: 4),
                Text("Vehicle: ${trip.vehicleName}"),
              ],
            ),  Visibility(
              visible: controller.tripStatus.value==0?true:false,
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
                onPressed: () {

                    getOdometerReading();

                },
                child:  Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: controller.tripStatus.value==1?const Text('Seen Arrival',style: TextStyle(fontWeight: FontWeight.bold)):controller.tripStatus.value==2?const Text('Departure',style: TextStyle(fontWeight: FontWeight.bold),):controller.tripStatus.value==3?const Text('Close',style: TextStyle(fontWeight: FontWeight.bold),):const Text('Started',style: TextStyle(fontWeight: FontWeight.bold),),
                ),
              ),
            ),
          ],
        ),
      );
    });
  /*  return FutureBuilder(
      future: controller.loadTripDetails("StartTrip"),
      builder: (context, snapshot) {
        return Obx(() {
          final trip = controller.tripDetails.value;
          if (trip == null) {
            return const Center(child: Text("No trip details available."));
          }

          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            margin: const EdgeInsets.symmetric(horizontal: 16, ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              image: DecorationImage(
                image: const AssetImage(
                  'assets/trip_image_icon.png',
                ),
                // fit: BoxFit.values,
                // centerSlice: Rect.fromLTRB(10, 10, 20, 20), // Example: define the stretchable region

                // alignment: Alignment.center, //
                colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.96),
                  // Adjust opacity here (0.0 to 1.0)
                  BlendMode.srcOver,
                ),
              ),
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
                const Text(
                  "Trip Details",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 16),
                // Add spacing between title and details

                // Text("Trip ID: ${trip.tripId}"),
                Row(
                  children: [
                    const Icon(Icons.confirmation_number), // Trip ID Icon
                    const SizedBox(width: 4),
                    Text("Trip ID: ${trip.tripId}"),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.location_on), // Location Icon
                    const SizedBox(width: 4),
                    Expanded(
                        child: Text(
                      trip.locationName,
                      maxLines: 2,
                    )),
                  ],
                ),
                // Text("Location: ${trip.locationName}"),
                Row(
                  children: [
                    const Icon(Icons.person), // Driver Icon
                    const SizedBox(width: 4),
                    Text("Driver: ${trip.driverName}"),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.directions_car), // Vehicle Icon
                    const SizedBox(width: 4),
                    Text("Vehicle: ${trip.vehicleName}"),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(

                    onPressed: () {
                      // getOdometerReading();
                    },

                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text('Trip Stared',style: TextStyle(fontWeight: FontWeight.bold),),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      getOdometerReading();
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text('Seen Arrival',style: TextStyle(fontWeight: FontWeight.bold),),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );*/
  }
  void getOdometerReading() async {
    String? odometerValue = await showOdometerDialog(Get.context!);
    if (odometerValue != null) {
      print("Odometer Entered: $odometerValue");
    }
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      // Add vertical padding to rows
      child: Row(
        children: [
          Icon(icon, size: 20), // Adjust icon size
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }
}
