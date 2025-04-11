
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vas/widgets/trip_details_widget.dart';
import 'package:vas/widgets/trip_history_seek_bar.dart';

import '../data/TripDetails.dart';
import '../theme.dart';
import '../utils/showOdodmeterDialog.dart';

class TripDetailsNewWidget extends StatefulWidget {
  const TripDetailsNewWidget({super.key});

  @override
  State<TripDetailsNewWidget> createState() => _TripDetailsNewWidgetState();
}

class _TripDetailsNewWidgetState extends State<TripDetailsNewWidget> {
  TripController tripController = Get.put(TripController());
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (tripController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      final trip = tripController.tripDetails.value;
      if (trip == null || trip.startTime.isEmpty) {
        return const SizedBox.shrink(); // Don't show widget if no start time
      }

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
            Text(
              "Trip Id: ${trip.tripId}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),

            TripHistorySeekBar(
              currentStep: _getTripStatus(trip),
            ),

            // Location Details
            _buildInfoRow(
              icon: Icons.location_on,
              text: trip.location,
              isMultiLine: true,
            ),

            // Driver Details
            _buildInfoRow(
              icon: Icons.person,
              text: "Driver: ${trip.driver}",
            ),

            // Vehicle Details
            _buildInfoRow(
              icon: Icons.directions_car,
              text: "Vehicle: ${trip.vehicle}",
            ),

            // Trip Timings and Kilometers
            if (trip.startTime.isNotEmpty)
              _buildTimeKmRow(
                label: "Start",
                time: trip.startTime,
                km: "${trip.startKm}",
                icon: Icons.play_circle,
              ),

            if (trip.reachTime.isNotEmpty)
              _buildTimeKmRow(
                label: "Reach",
                time: trip.reachTime,
                km: "${trip.reachKm}",
                icon: Icons.location_on,
              ),

            if (trip.departureTime.isNotEmpty)
              _buildTimeKmRow(
                label: "Departure",
                time: trip.departureTime,
                km: "${trip.departKm}",
                icon: Icons.departure_board,
              ),

            if (trip.closeTime.isNotEmpty)
              _buildTimeKmRow(
                label: "Close",
                time: trip.closeTime,
                km: "${trip.closeKm}",
                icon: Icons.check_circle,
              ),

            const SizedBox(height: 16),

            // Action Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isActionButtonEnabled(trip) ? () => _handleAction(trip) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:  Colors.blue,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  _getActionButtonText(trip),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String text,
    bool isMultiLine = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[700], size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              maxLines: isMultiLine ? 2 : 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeKmRow({
    required String label,
    required String time,
    required String km,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppThemes.light.primaryColor, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppThemes.light.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$km KM',
              style: TextStyle(
                color: AppThemes.light.primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _getTripStatus(TripDetailsModel trip) {
    if (trip.closeTime.isNotEmpty) return 3;
    if (trip.departureTime.isNotEmpty) return 2;
    if (trip.reachTime.isNotEmpty) return 1;
    return 0;
  }

  bool _isActionButtonEnabled(TripDetailsModel trip) {
    if (trip.closeTime.isNotEmpty) return false;
    return true;
  }

  String _getActionButtonText(TripDetailsModel trip) {
    if (trip.closeTime.isNotEmpty) return 'Completed';
    if (trip.departureTime.isNotEmpty) return 'Close Trip';
    if (trip.reachTime.isNotEmpty) return 'Departure';
    return 'Seen Arrival';
  }

  void _handleAction(TripDetailsModel trip) async {
    String? odometerValue = await showOdometerDialog(Get.context!);
    if (odometerValue != null) {
      int km = int.tryParse(odometerValue) ?? 0;
      if (km > 0) {
        if (trip.departureTime.isEmpty) {
          // Handle departure
          tripController.updateDeparture(km);
        } else if (trip.closeTime.isEmpty) {
          // Handle close
          tripController.closeTrip(km);
        } else if (trip.reachTime.isEmpty) {
          // Handle reach
          tripController.updateReach(km);
        }
      }
    }
  }
}
