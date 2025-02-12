import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vas/controllers/home_master_data_controller.dart';


class MasterDataScreen extends StatefulWidget {
  const MasterDataScreen({super.key});

  @override
  _MasterDataScreenState createState() => _MasterDataScreenState();
}

class _MasterDataScreenState extends State<MasterDataScreen> {
  // Mock data for last sync timestamps
  final Map<String, String> _lastSyncData = {
    'General Settings': '16/06/2024 10:12:49',
    'Event Type': '16/06/2024 10:12:50',
    'Denial Type': '16/06/2024 10:12:50',
    'Hospitals': '16/06/2024 10:12:50',
    'Incident Type': '16/06/2024 10:12:58',
  };

  // Function to handle synchronization
  void _synchronize(String dataType) {
    setState(() {
      // Update the last sync timestamp (mock implementation)
      _lastSyncData[dataType] = _getCurrentTimestamp();
    });
    print('$dataType synchronized at ${_lastSyncData[dataType]}');
  }

  // Helper function to get the current timestamp
  String _getCurrentTimestamp() {
    final now = DateTime.now();
    return '${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute}:${now
        .second}';
  }

  final HomeMasterDataController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Master Data'),
      ),
      body: data(),
    );
  }

  Widget data() {
    return Obx(() {
      if (homeController.apiDownloadHistory.isEmpty) {
        return const Center(child: Text("No history available"));
      }

      return ListView.builder(
          itemCount: homeController.apiDownloadHistory.length,

          itemBuilder: (context, index) {
            var history = homeController.apiDownloadHistory[index];

            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      history["endpoint"]!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Last Downloaded: ${history["lastDownloaded"]}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      // onPressed: () => _synchronize(dataType),
                      onPressed: () {  },
                      child: const Text('SYNCHRONIZE'),
                    ),
                  ],
                ),
              ),
            );
          });
    });
  }
}