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
              _textWidget("Driver:", "${trip.driverName}"),
              _textWidget("Vehicle:", "${trip.vehicleName}"),
              _textWidget("Location:", "${trip.locationName}"),
              _textWidget("BaseOdometer:", "${trip.baseKm}"),
              _textWidget("StartOdometer:", "${trip.startKm}"),
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                    labelText: 'Seen Arrival', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
              ),
              // _textWidget("Address:","${trip.address}"),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          tripController.loadTripDetails("StartTrip");
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _textWidget(String title, String subtitle) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 18),
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
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                const Icon(Icons.arrow_drop_down), // Dropdown icon
              ],
            ),
          ),
        ),
      ],
    );
  }


  // Future<void> submitFormSeen(String value) async {
  //   UserController userController = Get.put(UserController());
  //   TripController tripController = Get.put(TripController());
  //
  //   // String? odometerValue = await showOdometerDialog(Get.context!);
  //   // if (odometerValue == null) return;
  //
  //
  //   Map<String, dynamic> requestData = {
  //     "deptId": int.tryParse(userController.deptId.value)??0,
  //     "userId": int.tryParse(userController.userId.value),
  //     "tripId": 25021900002,
  //     // "tripId": tripController.tripDetails.value?.tripId ?? 0,
  //     "odometer":double.tryParse(value) ?? 0.0, // Convert to integer
  //     "lat":16.470866 ,
  //     "lng": 80.6065381
  //   };
  //   print(requestData);
  //
  //
  //   showLoadingDialog(); // Show loading before API call
  //
  //
  //   try {
  //
  //     final response = await apiService.postRequest("/TripSeenArrival", requestData);
  //     print("submitFormSeen");
  //     print(response);
  //     if (response != null) {
  //       hideLoadingDialog(); // Ensure loading dialog is dismissed
  //
  //
  //       if (response['result'] == 1) {
  //         int tripId = response['trip_ID']; // Extract trip ID
  //         Future.delayed(const Duration(milliseconds: 300), () {
  //           showErrorDialog("Alert!", "${response['message']}");
  //         });
  //         SharedPreferences prefs = await SharedPreferences.getInstance();
  //         await prefs.setInt("tripStatus",2);
  //         // await prefs.setString("tripTime",response['reach_Time']);
  //         await prefs.setString("tripSeenArrivalTime",response['reach_Time']);
  //         await prefs.setString("tripSeenDepartureTime",'');
  //
  //       }else{
  //         Future.delayed(const Duration(milliseconds: 300), () {
  //           showErrorDialog("Alert!", "$response");
  //         });
  //       }
  //
  //     }
  //     else{
  //       Future.delayed(const Duration(milliseconds: 300), () {
  //         showErrorDialog("Alert!", "$response");
  //       });
  //       hideLoadingDialog(); // Ensure loading dialog is dismissed
  //
  //     }
  //   } catch (e) {
  //     // hideLoadingDialog(); // Ensure loading dialog is dismissed
  //     showErrorDialog("Alert!","Failed to start trip: $e");
  //
  //     print("Failed to start trip: $e");
  //   }
  //   finally{
  //     hideLoadingDialog(); // Ensure loading dialog is dismissed
  //
  //   }
  // }

}
