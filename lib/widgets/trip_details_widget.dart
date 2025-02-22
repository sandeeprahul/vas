import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../data/TripDetails.dart';

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

  Future<void> loadTripDetails(String tripType) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(tripType);

    if (jsonString != null) {
      Map<String, dynamic> jsonData = jsonDecode(jsonString);
      tripDetails.value = TripDetailsModel.fromJson(jsonData["payload"]);
    }
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
    return FutureBuilder(
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
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
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
                    onPressed: () => controller.tripDetails,
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
    );
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
