import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vas/widgets/animal_bg_widget.dart';

import '../controllers/case_registration_new_controller.dart';
import '../theme.dart';
import '../widgets/trip_details_widget.dart';
import 'case_details_screen.dart';

class CaseRegistrationNewScreen extends StatefulWidget {
  const CaseRegistrationNewScreen({super.key});

  @override
  State<CaseRegistrationNewScreen> createState() =>
      _CaseRegistrationNewScreenState();
}

class _CaseRegistrationNewScreenState extends State<CaseRegistrationNewScreen> {

  final TripController tripController = Get.put(TripController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // tripController.fetchTripDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Case Registration'),
        backgroundColor: AppThemes.light.primaryColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppThemes.light.primaryColor,
              AppThemes.light.primaryColor.withOpacity(0.55),
              AppThemes.light.primaryColor.withOpacity(0.6),
              Colors.white,
            ],
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            AnimalBgWidget(),
            Obx(() {
              final trip = tripController.tripDetails.value;
              if (trip == null) {
                return const Center(child: Text("No trip details available",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),));
              }

              return Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        // _buildInputCard(icon: Icons.near_me, title: 'Name', value:"${trip.tripId}"),
                        _buildInputCard(
                            icon: Icons.near_me,
                            title: 'Trip ID',
                            value: "${trip.tripId}"),
                        _buildInputCard(
                            icon: Icons.emergency,
                            title: 'Ambulance No',
                            value: trip.vehicle),
                        _buildInputCard(
                            icon: Icons.near_me,
                            title: 'No Of Cases',
                            value: "${trip.noOfCases}"),
                        _buildInputCard(
                            icon: Icons.speed,
                            title: 'Odometer',
                            value: "${trip.startKm}"),
                        _buildInputCard(
                            icon: Icons.speed,
                            title: 'Seen Arrival Odometer',
                            value: "${trip.reachKm}"),
                        _buildInputCard(
                            icon: Icons.speed,
                            title: 'Seen Departure Odometer',
                            value: "${trip.departKm}"),
                        _buildInputCard(
                            icon: Icons.vaccines,
                            title: 'Service Village',
                            value: trip.location),

                        // buildTextField("Name","${trip.tripId}", icon: Icons.near_me),
                        // buildTextField("Ambulance No", trip.vehicle, icon: Icons.emergency),
                        // buildTextField("No Of Cases", controller.noOfCases.value, icon: Icons.library_books_sharp),
                        // buildTextField("Start Odometer", "${trip.startKm}", icon: Icons.speed),
                        // buildTextField("Seen Arrival Odometer",
                        //     "${trip.reachKm}", icon: Icons.view_sidebar),
                        // buildTextField("Seen Departure Odometer",
                        //     "${trip.departKm}", icon: Icons.foggy),
                        // buildTextField(
                        //     "Service Village ", trip.location, icon: Icons.vaccines),

                        // buildTextField("Location Type",trip.address),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(() => const CaseDetailsScreen());

                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text("CONTINUE",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFieldWithController(
      String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration:
          InputDecoration(labelText: label, border: const OutlineInputBorder()),
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildInputCard({
    required IconData icon,
    required String title,
    TextInputType keyboardType = TextInputType.text,
    required String value,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppThemes.dark.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppThemes.dark.primaryColor),
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
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    value,
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(
    String label,
    String value, {
    required IconData icon,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppThemes.dark.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppThemes.dark.primaryColor),
            ),
            // Expanded(child: Text("$label:")),
            Expanded(
              flex: 3,
              child: Container(
                // padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  // border: Border.all(color: Colors.grey), // Grey border
                  borderRadius: BorderRadius.circular(8), // Rounded corners
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        value,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    // const Icon(Icons.arrow_drop_down), // Dropdown icon
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


}


