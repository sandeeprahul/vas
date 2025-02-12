import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ManageTripScreen extends StatefulWidget {
  @override
  _ManageTripScreenState createState() => _ManageTripScreenState();
}

class _ManageTripScreenState extends State<ManageTripScreen> {
  TextEditingController arrivalOdometerController = TextEditingController();
  bool isTripStarted = false;
  bool isOdometerUpdated = false;

  // Dummy Data
  Map<String, dynamic> tripData = {
    "name": "Paravet Two",
    "tripId": "2016",
    "district": "RAIPUR",
    "block": "AARANG",
    "ambulanceNo": "AARANG - CG02 AU1682",
    "doctorName": "Kalpak Kayande",
    "driverName": "Driver Five",
    "baseOdometer": "9.00",
    "startOdometer": "10.00 - 16/06/2024 10:15"
  };

  Future<void> updateArrivalOdometer() async {
    if (arrivalOdometerController.text.isEmpty) {
      return;
    }
    setState(() {
      isOdometerUpdated = true;
    });

    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Message"),
        content: Text("Reach Time updated for this trip"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Trip v2"),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTripDetail("Name", tripData['name']),
            buildTripDetail("Trip ID", tripData['tripId']),
            buildTripDetail("District", tripData['district']),
            buildTripDetail("Block", tripData['block']),
            buildTripDetail("Ambulance No", tripData['ambulanceNo']),
            buildTripDetail("Doctor Name", tripData['doctorName']),
            buildTripDetail("Driver Name", tripData['driverName']),
            buildTripDetail("Base Odometer", tripData['baseOdometer']),
            buildTripDetail("Start Odometer", tripData['startOdometer']),

            SizedBox(height: 20),
            Text("Seen Arrival Odometer"),
            TextField(
              controller: arrivalOdometerController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isOdometerUpdated ? null : updateArrivalOdometer,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text("SEEN ARRIVAL"),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTripDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(value, style: TextStyle(color: Colors.blue)),
        ],
      ),
    );
  }
}
