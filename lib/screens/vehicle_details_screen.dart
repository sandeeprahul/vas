import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/vehicle_details_model.dart';

class VehicleDetailsScreen extends StatelessWidget {
  final VehicleDetailsModel vehicleData;

  const VehicleDetailsScreen({Key? key, required this.vehicleData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const SizedBox(height: 16),

          // Vehicle Status Card
          _buildStatusCard(),
          const SizedBox(height: 16),

          // Vehicle Details Card
          _buildVehicleDetailsCard(),
          const SizedBox(height: 16),

          // Scheduled Trip Details Card
          _buildScheduledTripCard(),
          const SizedBox(height: 16),

          // Emergency Case Details Card
          // _buildEmergencyCaseCard(),
          const SizedBox(height: 16),

          // Fuel History Card
          _buildFuelHistoryCard(),
        ],
      ),
    );
  }

  Widget _buildErrorCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.red[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Error Information',
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            if (vehicleData.errorCode != null)
              _buildInfoRow('Error Code', vehicleData.errorCode!),
            if (vehicleData.errorMessage != null)
              _buildInfoRow('Error Message', vehicleData.errorMessage!),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vehicle Status',
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoRow('Vehicle ID', "${vehicleData.vehicleId}"),
            _buildInfoRow('Odometer (Last)', vehicleData.odometerLast.toString()),
            _buildInfoRow('Odometer (Base)', vehicleData.odometerBase.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleDetailsCard() {
    final details = vehicleData.vehicleDetails;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vehicle Information',
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoRow('Vehicle Number', details.vehicleNumber),
            _buildInfoRow('Petro Card No', details.petroCardNo),
            _buildInfoRow('Service Type', details.serviceType),
            _buildInfoRow('District', details.district),
            _buildInfoRow('Base Block', details.baseBlock),
            _buildInfoRow('Base Location', details.baseLocation),
            _buildInfoRow('On Duty Staff', details.onDutyStaffName),
            _buildInfoRow('Last Duty Close KM', details.lastDutyCloseKm.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduledTripCard() {
    final trip = vehicleData.schTripDetails;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Scheduled Trip',
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoRow('Trip ID', trip.tripId),
            _buildInfoRow('Service District', trip.serviceDistrict),
            _buildInfoRow('Service Block', trip.serviceBlock),
            _buildInfoRow('Service Location', trip.serviceLocation),
            _buildInfoRow('Start At', trip.startAt),
            _buildInfoRow('Seen Arrival At', trip.seenArrivalAt),
            _buildInfoRow('Seen Depart At', trip.seenDepartAt),
            _buildInfoRow('Trip Odometer', trip.tripOdometer.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyCaseCard() {
    final caseDetails = vehicleData.emgCaseDetails;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Emergency Case',
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoRow('Case No', caseDetails.caseNo),
            _buildInfoRow('Service District', caseDetails.serviceDistrict),
            _buildInfoRow('Service Block', caseDetails.serviceBlock),
            _buildInfoRow('Service Location', caseDetails.serviceLocation),
            _buildInfoRow('Job Start Time', caseDetails.jobStatTime),
            _buildInfoRow('Seen Arrival At', caseDetails.seenArrivalAt),
            _buildInfoRow('Procedure Start Time', caseDetails.procedureStartTime),
            _buildInfoRow('Procedure End Time', caseDetails.procedureEndTime),
            _buildInfoRow('Case Odometer', caseDetails.caseOdometer.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildFuelHistoryCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Fuel History',
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 12),
            ...vehicleData.fuelHistory.map((entry) => Column(
              children: [
                _buildInfoRow('Ticket Number', entry.ticketNumber),
                _buildInfoRow('Entry Time', entry.entryTime),
                _buildInfoRow('Trip ID', entry.tripId),
                _buildInfoRow('Case No', entry.caseNo),
                _buildInfoRow('Odometer Base', entry.odometerBase),
                _buildInfoRow('Odometer', entry.odometer),
                _buildInfoRow('Odometer Back At Base', entry.odometerBackAtBase),
                _buildInfoRow('Fuel Station', entry.fuelStationName),
                _buildInfoRow('Quantity', entry.quantity.toString()),
                _buildInfoRow('Unit Price', entry.unitPrice.toString()),
                _buildInfoRow('Amount', entry.amount.toString()),
                _buildInfoRow('Payment Mode', entry.paymentMode),
                const Divider(),
              ],
            )).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 