import 'dart:convert';

class TripDetailsModel {
  final int deptId;
  final int userId;
  final int driverId;
  final int doctorId;
  final int zoneId;
  final int blockId;
  final int locationId;
  final String locationName;
  final String address;
  final int vehicleId;
  final String vehicleName;
  final String driverName;
  final String doctorName;
  final String zoneName;
  final String blockName;
  final double baseKm;
  final double latitude;
  final double longitude;
  final String deviceRegnId;
  final String imeiNumber;
  final String osVersion;
  final int tripId;
  final String startTime;

  TripDetailsModel({
    required this.deptId,
    required this.userId,
    required this.driverId,
    required this.driverName,
    required this.doctorId,
    required this.doctorName,
    required this.zoneId,
    required this.zoneName,
    required this.blockId,
    required this.blockName,
    required this.locationId,
    required this.locationName,
    required this.address,
    required this.vehicleId,
    required this.vehicleName,
    required this.baseKm,
    required this.latitude,
    required this.longitude,
    required this.deviceRegnId,
    required this.imeiNumber,
    required this.osVersion,
    required this.tripId,
    required this.startTime,
  });

  factory TripDetailsModel.fromJson(Map<String, dynamic> json) {
    return TripDetailsModel(
      deptId: json['depT_ID']??0,
      userId: json['user_ID']??0,
      driverId: json['driver_ID']??0,
      driverName: json['driver_Name'] ?? '',
      doctorId: json['doctor_ID']??0,
      doctorName: json['doctor_Name'] ?? '',
      zoneId: json['zone_ID']??0,
      zoneName: json['zone_Name'] ?? '',
      blockId: json['block_ID']??0,
      blockName: json['block_Name'] ?? '',
      locationId: json['location_ID']??0,
      locationName: json['location_Name'] ?? '',
      address: json['address'] ?? '',
      vehicleId: json['vehicle_ID']??0,
      vehicleName: json['vehicle_Name'] ?? '',
      baseKm: (json['base_KM']??0.0 as num).toDouble(),
      latitude: (json['latitude']??0.0 as num).toDouble(),
      longitude: (json['longitude']??0.0 as num).toDouble(),
      deviceRegnId: json['device_Regn_ID']??'',
      imeiNumber: json['imeI_Number']??'',
      osVersion: json['os_Version']??'',
      tripId: json['trip_ID']??0,
      startTime: json['start_Time']??'',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "depT_ID": deptId,
      "user_ID": userId,
      "driver_ID": driverId,
      "driver_Name": driverName,
      "doctor_ID": doctorId,
      "doctor_Name": doctorName,
      "zone_ID": zoneId,
      "zone_Name": zoneName,
      "block_ID": blockId,
      "block_Name": blockName,
      "location_ID": locationId,
      "location_Name": locationName,
      "address": address,
      "vehicle_ID": vehicleId,
      "vehicle_Name": vehicleName,
      "base_KM": baseKm,
      "latitude": latitude,
      "longitude": longitude,
      "device_Regn_ID": deviceRegnId,
      "imeI_Number": imeiNumber,
      "os_Version": osVersion,
      "trip_ID": tripId,
      "start_Time": startTime,
    };
  }

  static TripDetailsModel fromJsonString(String jsonData) {
    return TripDetailsModel.fromJson(jsonDecode(jsonData));
  }
}
