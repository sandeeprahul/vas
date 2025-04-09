import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vas/controllers/trip_from_controller.dart';

import '../controllers/user_controller.dart';
import '../widgets/trip_details_widget.dart';

class ManageTripArrivalDepartureCloseScreen extends StatefulWidget {
  const ManageTripArrivalDepartureCloseScreen({super.key});

  @override
  State<ManageTripArrivalDepartureCloseScreen> createState() =>
      _ManageTripArrivalDepartureCloseScreenState();
}

class _ManageTripArrivalDepartureCloseScreenState
    extends State<ManageTripArrivalDepartureCloseScreen> {
  final TripController tripController = Get.put(TripController());
  final FormController formController = Get.put(FormController());

  final TextEditingController controller = TextEditingController();

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
              _textWidget("Trip ID:", "${trip.tripId}"),
              _textWidget("Driver:", trip.driver),
              _textWidget("Vehicle:", trip.vehicle),
              _textWidget("Location:", trip.location),
              _textWidget("BaseOdometer:", "${trip.startKm}"),
              _textWidget("StartOdometer:", "${trip.reachKm}"),
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                    labelText: 'Seen Arrival', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
              ),
              // _textWidget("Address:","${trip.address}"),
              const SizedBox(height: 6,),
              Obx(() => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        formController.isLoading.value
                            ? null
                            : formController
                                .submitFormSeen(controller.value.text);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            // Add this
                            borderRadius: BorderRadius.circular(
                                28.0), // Adjust the radius as needed
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          textStyle: GoogleFonts.montserrat(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      child: formController.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Submit"),
                    ),
                  )),
            ],
          );
        }),
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: () {
          tripController.loadTripDetails("StartTrip");
        },
        child: const Icon(Icons.refresh),
      ),*/
    );
  }

  Widget _textWidget(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey), // Grey border
                borderRadius: BorderRadius.circular(8), // Rounded corners
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      subtitle,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down), // Dropdown icon
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }




}
