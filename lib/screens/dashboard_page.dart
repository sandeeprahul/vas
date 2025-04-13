import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vas/controllers/user_controller.dart';
import 'package:vas/theme.dart';
import 'package:vas/widgets/rounded_corner_card_widget.dart';
import 'package:vas/widgets/trip_details_new_widget.dart';

import '../controllers/dash_boardcontroller.dart';
import '../controllers/trip_from_controller.dart';
import '../widgets/profile_card.dart';
import '../widgets/summary_card.dart';
import '../widgets/time_summary_card_widget.dart';
import '../widgets/trip_details_widget.dart';
import 'dashboard_custom_menu_widget.dart';

class DashboardPage extends StatefulWidget {
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String? token;
  String? employeeId;
  String? name;
  String? roleId;
  final DashboardController dashboardController =
      Get.put(DashboardController()); // Initialize controller
  final TripController tripController =
      Get.put(TripController()); // Initialize controller
  FormController formController = Get.put(FormController());
  UserController userController = Get.put(UserController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadUserDetails();
    tripController.fetchTripDetails();
  }

  Future<void> _loadUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString("token");
      employeeId = prefs.getString("employeeId");
      name = prefs.getString("name");
      roleId = prefs.getString("roleId");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(

        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.blue,
                  Colors.white,
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 16,
                ),

                const SizedBox(
                  height: 16,
                ),

                Stack(
                  clipBehavior: Clip.none,
                  // Allows overflow outside the Stack
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      // width: MediaQuery.of(context).size.width / 1.2,
                      height: MediaQuery.of(context).size.height / 4,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50, //#dcdee7

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
                        mainAxisSize: MainAxisSize.min,
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 18,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const SizedBox(
                                width: 16,
                              ),
                              const CircleAvatar(
                                backgroundColor: Colors.blue,
                                radius: 38,
                                child: Icon(
                                  Icons.person,
                                  size: 38,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                // mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    " $name",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(28),
                                      color: Colors.blue, //#dcdee7
                                    ),
                                    child: Text(
                                      " ClientId: ${userController.clientId.value} ",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight:
                                            FontWeight.bold, /*color: Colors.black*/
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(top: 12, bottom: 12),
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(28),
                                    bottomRight: Radius.circular(28)),
                                color: Colors.white, //#dcdee7
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      // text: 'Hello ',
                                      style: DefaultTextStyle.of(context).style,
                                      children: const <TextSpan>[
                                        TextSpan(
                                            text: 'Gudivada\n',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        TextSpan(text: 'Block'),
                                      ],
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      // text: 'Hello ',
                                      style: DefaultTextStyle.of(context).style,
                                      children: const <TextSpan>[
                                        TextSpan(
                                            text: 'Krishna\n',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        TextSpan(text: 'District'),
                                      ],
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      // text: 'Hello ',
                                      style: DefaultTextStyle.of(context).style,
                                      children: const <TextSpan>[
                                        TextSpan(
                                            text: 'GOAP\n',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black)),
                                        TextSpan(text: 'Vehicle Class'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: false,
                      child: Positioned(
                        top: -52, // Move button outside the card
                        left: 1,
                        right: 1,
                        child: CircleAvatar(
                          backgroundColor: Colors.blue.shade100,
                          radius: 50,
                          child: const Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const TimeSummaryCardWidget(),
                // TripDetailsWidget(),
                const TripDetailsNewWidget(),
                /* Obx(() {
              final trip = tripController.tripDetails.value;
              if (trip == null) {
                return const Center(child: Text("No trip details available."));
              }

              return Card(
                elevation: 4,
                margin: const EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Trip ID: ${trip.tripId}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Text("Location ID: ${trip.payload['location_ID']}"),
                      Text("Driver ID: ${trip.payload['driver_ID']}"),
                      Text("Vehicle ID: ${trip.payload['vehicle_ID']}"),
                    ],
                  ),
                ),
              );
            }),*/
                //menu
                const SizedBox(
                  height: 400,
                    child: DashboardCustomMenuWidget()),
                Visibility(
                  visible: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              if (tripController.tripStatus.value == 1) {
                                Navigator.pushNamed(context,
                                    '/manage_trip_arrival_departure_close_screen'); // N
                              } else {
                                Navigator.pushNamed(context, '/manage_trip'); // N
                              }
                            },
                            child: const RoundedCornerCardWidget(
                              title: "Manage Trip",
                              subtitle: "Trip",
                              // kcal: "525 pending",
                              // imagePath: "assets/egg.png",
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(28),
                                bottomRight: Radius.circular(0),
                                topRight: Radius.circular(0),
                                bottomLeft: Radius.circular(0),
                              ),
                              icon: Icons.car_crash,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              // formController.saveTempDetails();
                              //
                              Navigator.pushNamed(
                                  context, '/case_registration_new'); // N
                            },
                            child: const RoundedCornerCardWidget(
                              title: "Live Case",
                              subtitle: "Live Case Registration",
                              // kcal: "5 pending",
                              // imagePath: "assets/egg.png",
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(0),
                                bottomRight: Radius.circular(0),
                                topRight: Radius.circular(28),
                                bottomLeft: Radius.circular(0),
                              ),
                              icon: Icons.car_crash,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),

                const Visibility(
                  visible: false,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: RoundedCornerCardWidget(
                            title: "Cattle Register",
                            subtitle: "Cattle Registration",
                            // kcal: "525 pending",
                            // imagePath: "assets/egg.png",
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(0),
                              bottomRight: Radius.circular(0),
                              topRight: Radius.circular(0),
                              bottomLeft: Radius.circular(28),
                            ),
                            icon: Icons.car_crash,
                          ),
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Expanded(
                          child: RoundedCornerCardWidget(
                            title: "Cattle Case",
                            subtitle: "Case Registration",
                            // kcal: "5 pending",
                            // imagePath: "assets/egg.png",
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(0),
                              bottomRight: Radius.circular(28),
                              topRight: Radius.circular(0),
                              bottomLeft: Radius.circular(0),
                            ),
                            icon: Icons.car_crash,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String title, String value, IconData icon, Color color,
      var angle, var colors) {
    return SizedBox(
      width: 200,
      child: Row(
        children: [
          Container(
            height: 40,
            width: 1,
            color: colors,
          ),
          const SizedBox(
            width: 4,
          ),
          Column(
            // mainAxisAlignment: MainAxisAlignment.start,

            children: [
              // Text(title, style: GoogleFonts.montserrat(fontSize: 14, color: Colors.grey)),
              Row(
                mainAxisSize: MainAxisSize.min,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value,
                      style: GoogleFonts.montserrat(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 5),
                  Transform.rotate(
                      angle: angle, child: Icon(icon, color: color, size: 20)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: GoogleFonts.montserrat(
                  fontSize: 14, fontWeight: FontWeight.bold)),
          Text(value,
              style: GoogleFonts.montserrat(fontSize: 14, color: color)),
        ],
      ),
    );
  }
}
