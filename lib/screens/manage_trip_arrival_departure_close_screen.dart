import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/trip_details_widget.dart';

class ManageTripArrivalDepartureCloseScreen extends StatefulWidget {
  const ManageTripArrivalDepartureCloseScreen({super.key});

  @override
  State<ManageTripArrivalDepartureCloseScreen> createState() => _ManageTripArrivalDepartureCloseScreenState();
}

class _ManageTripArrivalDepartureCloseScreenState extends State<ManageTripArrivalDepartureCloseScreen> {
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
      appBar: AppBar(title: const Text("Trip Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          final trip = tripController.tripDetails.value;
          if (trip == null) {
            return const Center(child: Text("No trip details available"));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Trip ID: ${trip.tripId}", style: TextStyle(fontSize: 18)),
              Text("Driver: ${trip.driverName}", style: TextStyle(fontSize: 18)),
              Text("Vehicle: ${trip.vehicleName}", style: TextStyle(fontSize: 18)),
              Text("Location: ${trip.locationName}", style: TextStyle(fontSize: 18)),
              Text("Address: ${trip.address}", style: TextStyle(fontSize: 18)),
              Text("Start Time: ${trip.startTime}", style: TextStyle(fontSize: 18)),
            ],
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          tripController.loadTripDetails("your_trip_type_key");
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
