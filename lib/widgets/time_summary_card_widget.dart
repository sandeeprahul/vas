import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimeSummaryCardWidget extends StatefulWidget {
  const TimeSummaryCardWidget({super.key});

  @override
  State<TimeSummaryCardWidget> createState() => _TimeSummaryCardWidgetState();
}

class _TimeSummaryCardWidgetState extends State<TimeSummaryCardWidget> {
  String _timeDifference = '00:00';
  Timer? _timer;
  String logInTime = '00:00 AM';
  @override
  void initState() {
    super.initState();
    getLoginTime();

    _startTimer();
  }
  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }
  void _startTimer() {
    // Timer that runs every 1 minute
    _timer = Timer.periodic(Duration(minutes: 1), (timer) async {
      await _calculateTimeDifference();
    });
  }
  Future<void> _calculateTimeDifference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? loggedInTimeString = prefs.getString('loggedInTime');

    if (loggedInTimeString != null) {
      // Parse the stored time string into a DateTime object
      DateTime loggedInTime = DateTime.parse(loggedInTimeString);
      DateTime currentTime = DateTime.now();

      // Calculate the difference
      Duration difference = currentTime.difference(loggedInTime);

      // Format the difference into a readable string
      String formattedDifference = _formatDuration(difference);

      // Update the UI
      setState(() {
        _timeDifference = formattedDifference;
      });
    } else {
      setState(() {
        _timeDifference = 'No logged-in time found';
      });
    }
  }
  // Helper function to format Duration into "HH:mm Hrs" format
  /*String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0'); // Ensure two digits
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    return '$hours:$minutes';
  }*/
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0'); // Ensure two digits
    String hours = twoDigits(duration.inHours.remainder(24)); // Ensures 00 format
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    return '$hours:$minutes';
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      margin: const EdgeInsets.symmetric(horizontal: 16,vertical: 20),
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
          // Title and arrow
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Summary",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54),
            ],
          ),
          const SizedBox(height: 16),

          Row(
            children: [

              Column(
                children: [

                  // Logged In
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration:  BoxDecoration(
                          color: Colors.teal.shade100, // Light blue background
                          shape: BoxShape.circle,
                        ),
                        child: Transform.rotate(angle: 9.5,
                        child: const Icon(Icons.outbond, color: Colors.green, size: 18)),
                        // child: const Icon(Icons.login, color: Color(0xFF4A90E2), size: 18),
                      ),
                      const SizedBox(width: 10),
                       Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Logged In", style: TextStyle(fontSize: 12, color: Colors.black54)),
                          Text(logInTime, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Logged Out
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFF0E5), // Light orange background
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.outbond, color: Color(0xFFFF7849), size: 18),
                      ),
                      const SizedBox(width: 10),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Logged Out", style: TextStyle(fontSize: 12, color: Colors.black54)),
                          Text("05:44 PM", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              CircularPercentIndicator(
                radius: 50.0,
                lineWidth: 8.0,
                percent:  _calculateProgress(_timeDifference),
                // percent: 0.75,
                center: Text("$_timeDifference\nhrs",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                progressColor: Colors.blueAccent,
                backgroundColor: Colors.grey[200]!,
                circularStrokeCap: CircularStrokeCap.round,
              ),
            ],
          )

        ],
      ),
    );
  }
  double _calculateProgress(String timeDifference) {
    try {
      // Extract hours and minutes from formatted string "HH:MM Hrs"
      List<String> parts = timeDifference.split(" ")[0].split(":");
      int hours = int.parse(parts[0]);
      int minutes = int.parse(parts[1]);

      // Convert total time to minutes
      int totalMinutes = (hours * 60) + minutes;

      // Max duration = 8 hours (480 minutes)
      double progress = totalMinutes / 480;

      // Ensure the progress stays between 0 and 1
      return progress.clamp(0.0, 1.0);
    } catch (e) {
      return 0.0; // Default to 0 if parsing fails
    }
  }

  Future<void> getLoginTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? loggedInTimeString = prefs.getString('loggedInTime');

    if (loggedInTimeString != null) {
      // Parse the stored time string into a DateTime object
      DateTime loggedInTime = DateTime.parse(loggedInTimeString);

      String formattedLogInTime = DateFormat('hh:mm a').format(loggedInTime);

      // Update the UI
      setState(() {
        logInTime = formattedLogInTime;
      });
    } else {
      setState(() {
        logInTime = '00:00 AM';
      });
    }
  }

}
