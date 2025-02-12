import 'package:flutter/material.dart';
import '../widgets/side_menu.dart';

class CaseManagementScreen extends StatelessWidget {
  final List<Map<String, String>> cases = [
    {"id": "101", "status": "Completed", "animal": "Dog"},
    {"id": "102", "status": "In Progress", "animal": "Cow"},
    {"id": "103", "status": "Pending", "animal": "Cat"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Case Management")),
      drawer: SideMenu(),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: cases.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: Icon(Icons.pets, color: cases[index]["status"] == "Completed" ? Colors.green : Colors.red),
              title: Text("Case ID: ${cases[index]["id"]}"),
              subtitle: Text("Status: ${cases[index]["status"]} - Animal: ${cases[index]["animal"]}"),
            ),
          );
        },
      ),
    );
  }
}
