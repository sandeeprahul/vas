import 'package:flutter/material.dart';
import '../widgets/side_menu.dart';

class TripManagementScreen extends StatelessWidget {
  final List<Map<String, String>> trips = [
    {"id": "1", "status": "Completed", "location": "City A"},
    {"id": "2", "status": "Pending", "location": "City B"},
    {"id": "3", "status": "In Progress", "location": "City C"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Manage Trips")),
      drawer: SideMenu(),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: trips.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: Icon(Icons.local_taxi, color: trips[index]["status"] == "Completed" ? Colors.green : Colors.orange),
              title: Text("Trip ID: ${trips[index]["id"]}"),
              subtitle: Text("Status: ${trips[index]["status"]} - Location: ${trips[index]["location"]}"),
            ),
          );
        },
      ),
    );
  }
}
