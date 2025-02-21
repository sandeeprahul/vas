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


  Rxn<TripDetailsModel> tripDetails = Rxn<TripDetailsModel>();

  Future<TripDetailsModel?> loadTripDetails(String tripType) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonData = prefs.getString(tripType);

    if (jsonData != null) {
      try {
        Map<String, dynamic> tripData = jsonDecode(jsonData);
        Map<String, dynamic> tripDetailsJson = tripData["payload"];

        TripDetailsModel tripDetails =
        TripDetailsModel.fromJson(tripDetailsJson);
        print("loadTripDetails");
        print(tripDetails);
        return tripDetails;
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
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text("No trip details available."));
        }

        final trip = snapshot.data!; // TripDetailsModel instance

       return  Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
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
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Trip Details",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        )),
                    Icon(Icons.arrow_forward_ios,
                        size: 16, color: Colors.black54),
                  ],
                ),
                Text("Trip ID: ${trip.tripId}",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text("Location : ${trip.locationName}"),
                Text("Driver ID: ${trip.driverName}"),
                Text("Vehicle ID: ${trip.vehicleName}"),
                ElevatedButton(
                    onPressed: () {},
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text('Seen Arrival'),
                    ))
              ],
            ),
          ),
        );
      },
    );
  }
}
