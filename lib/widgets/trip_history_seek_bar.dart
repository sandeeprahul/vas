import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vas/widgets/trip_details_widget.dart';

class TripHistorySeekBar extends StatelessWidget {
  final int currentStep; // Change this dynamically to update progress

  const TripHistorySeekBar({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final steps = ["Started", "SeenArrival", "Departure"];
    final TripController tripController = Get.find();

    return Obx(() {
      final currentStatus = tripController.tripStatus.value;
      print("TripHistorySeekBar");
      print(currentStatus);
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(steps.length, (index) {
          final isCompleted = index <= currentStatus; // <= instead of <

          return Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    if (index != 0)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: isCompleted ? Colors.green : Colors.red[300],
                        ),
                      ),
                    CircleAvatar(
                      radius: 6,
                      backgroundColor: isCompleted ? Colors.green : Colors.red,
                    ),
                    if (index != steps.length - 1)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: (index + 1 <= currentStatus)
                              ? Colors.green
                              : Colors.red[300],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  steps[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: isCompleted ? Colors.green : Colors.red,
                    fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        }),
      );
    });
  }

}
