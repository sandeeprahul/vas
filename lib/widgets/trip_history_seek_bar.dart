import 'package:flutter/material.dart';

class TripHistorySeekBar extends StatelessWidget {
  final int currentStep; // Change this dynamically to update progress

  const TripHistorySeekBar({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final steps = [
      "Started",
      "Arrival",
      "Departure",
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(steps.length, (index) {
        final isActive = index == currentStep;
        final isCompleted = index < currentStep;

        return Expanded(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  if (index !=
                      0) // Add a connecting line except for the first step
                    Expanded(
                      child: Container(
                        height: 2,
                        color: isCompleted ? Colors.green : Colors.red[300],
                      ),
                    ),
                  CircleAvatar(
                    radius: 6,
                    backgroundColor: isActive
                        ? Colors.red
                        : (isCompleted ? Colors.green : Colors.red),
                  ),
                  if (index != steps.length - 1) // Add space for next connector
                    Expanded(
                      child: Container(
                        height: 2,
                        color: isCompleted ? Colors.green : Colors.red[300],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                textAlign: TextAlign.center,
                steps[index],
                style: TextStyle(
                  fontSize: 12,
                  color: isActive
                      ? Colors.red
                      : (isCompleted ? Colors.green : Colors.red),
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
