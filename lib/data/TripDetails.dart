import 'dart:convert';

import 'dart:convert';

class TripDetailsModel {
  final int tripId;
  final int doctorId;
  final String doctor;
  final int driverId;
  final String driver;
  final int vehicleId;
  final String vehicle;
  final int districtId;
  final String district;
  final int blockId;
  final String block;
  final int locationId;
  final String location;
  final String address;
  final double locationLat;
  final double locationLong;
  final int noOfCases;
  final String startTime;
  final double startKm;
  final String reachTime;
  final double reachKm;
  final String departureTime;
  final double departKm;
  final String closeTime;
  final double closeKm;

  TripDetailsModel({
    required this.tripId,
    required this.doctorId,
    required this.doctor,
    required this.driverId,
    required this.driver,
    required this.vehicleId,
    required this.vehicle,
    required this.districtId,
    required this.district,
    required this.blockId,
    required this.block,
    required this.locationId,
    required this.location,
    required this.address,
    required this.locationLat,
    required this.locationLong,
    required this.noOfCases,
    required this.startTime,
    required this.startKm,
    required this.reachTime,
    required this.reachKm,
    required this.departureTime,
    required this.departKm,
    required this.closeTime,
    required this.closeKm,
  });

  factory TripDetailsModel.fromJson(Map<String, dynamic> json) {
    return TripDetailsModel(
      tripId: json['trip_ID'] ?? 0,
      doctorId: json['doctor_ID'] ?? 0,
      doctor: json['doctor'] ?? '',
      driverId: json['driver_ID'] ?? 0,
      driver: json['driver'] ?? '',
      vehicleId: json['vehicle_ID'] ?? 0,
      vehicle: json['vehicle'] ?? '',
      districtId: json['district_ID'] ?? 0,
      district: json['district'] ?? '',
      blockId: json['block_ID'] ?? 0,
      block: json['block'] ?? '',
      locationId: json['location_ID'] ?? 0,
      location: json['location'] ?? '',
      address: json['address'] ?? '',
      locationLat: (json['location_Lat'] ?? 0.0).toDouble(),
      locationLong: (json['location_Long'] ?? 0.0).toDouble(),
      noOfCases: json['no_Of_Cases'] ?? 0,
      startTime: json['start_Time'] ?? '',
      startKm: (json['start_KM']).toDouble(),
      reachTime: json['reach_Time'] ?? '',
      reachKm: (json['reach_KM']).toDouble(),
      departureTime: json['departure_Time'] ?? '',
      departKm: (json['depart_KM']).toDouble(),
      closeTime: json['close_Time'] ?? '',
      closeKm: (json['close_KM'] ).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "trip_ID": tripId,
      "doctor_ID": doctorId,
      "doctor": doctor,
      "driver_ID": driverId,
      "driver": driver,
      "vehicle_ID": vehicleId,
      "vehicle": vehicle,
      "district_ID": districtId,
      "district": district,
      "block_ID": blockId,
      "block": block,
      "location_ID": locationId,
      "location": location,
      "address": address,
      "location_Lat": locationLat,
      "location_Long": locationLong,
      "no_Of_Cases": noOfCases,
      "start_Time": startTime,
      "start_KM": startKm,
      "reach_Time": reachTime,
      "reach_KM": reachKm,
      "departure_Time": departureTime,
      "depart_KM": departKm,
      "close_Time": closeTime,
      "close_KM": closeKm,
    };
  }

  static TripDetailsModel fromJsonString(String jsonData) {
    return TripDetailsModel.fromJson(jsonDecode(jsonData));
  }
}

// class TripDetailsModelssssssss {
//   final int deptId;
//   final int userId;
//   final int driverId;
//   final int doctorId;
//   final int zoneId;
//   final int blockId;
//   final int locationId;
//   final String locationName;
//   final String address;
//   final int vehicleId;
//   final String vehicleName;
//   final String driverName;
//   final String doctorName;
//   final String zoneName;
//   final String blockName;
//   final double baseKm;
//   final double startKm;
//   final double latitude;
//   final double longitude;
//   final String deviceRegnId;
//   final String imeiNumber;
//   final String osVersion;
//   final int tripId;
//   final String startTime;
//
//   TripDetailsModel({
//     required this.deptId,
//     required this.userId,
//     required this.driverId,
//     required this.driverName,
//     required this.doctorId,
//     required this.doctorName,
//     required this.zoneId,
//     required this.zoneName,
//     required this.blockId,
//     required this.blockName,
//     required this.locationId,
//     required this.locationName,
//     required this.address,
//     required this.vehicleId,
//     required this.vehicleName,
//     required this.baseKm,
//     required this.startKm,
//     required this.latitude,
//     required this.longitude,
//     required this.deviceRegnId,
//     required this.imeiNumber,
//     required this.osVersion,
//     required this.tripId,
//     required this.startTime,
//   });
//
//   factory TripDetailsModel.fromJson(Map<String, dynamic> json) {
//     return TripDetailsModel(
//       deptId: json['depT_ID']??0,
//       userId: json['user_ID']??0,
//       driverId: json['driver_ID']??0,
//       driverName: json['driver_Name'] ?? '',
//       doctorId: json['doctor_ID']??0,
//       doctorName: json['doctor_Name'] ?? '',
//       zoneId: json['zone_ID']??0,
//       zoneName: json['zone_Name'] ?? '',
//       blockId: json['block_ID']??0,
//       blockName: json['block_Name'] ?? '',
//       locationId: json['location_ID']??0,
//       locationName: json['location_Name'] ?? '',
//       address: json['address'] ?? '',
//       vehicleId: json['vehicle_ID']??0,
//       vehicleName: json['vehicle_Name'] ?? '',
//       baseKm: (json['base_KM']??0.0 as num).toDouble(),
//       startKm: (json['startKm']??0.0 as num).toDouble(),
//       latitude: (json['latitude']??0.0 as num).toDouble(),
//       longitude: (json['longitude']??0.0 as num).toDouble(),
//       deviceRegnId: json['device_Regn_ID']??'',
//       imeiNumber: json['imeI_Number']??'',
//       osVersion: json['os_Version']??'',
//       tripId: json['trip_ID']??0,
//       startTime: json['start_Time']??'',
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       "depT_ID": deptId,
//       "user_ID": userId,
//       "driver_ID": driverId,
//       "driver_Name": driverName,
//       "doctor_ID": doctorId,
//       "doctor_Name": doctorName,
//       "zone_ID": zoneId,
//       "zone_Name": zoneName,
//       "block_ID": blockId,
//       "block_Name": blockName,
//       "location_ID": locationId,
//       "location_Name": locationName,
//       "address": address,
//       "vehicle_ID": vehicleId,
//       "vehicle_Name": vehicleName,
//       "base_KM": baseKm,
//       "startKm": startKm,
//       "latitude": latitude,
//       "longitude": longitude,
//       "device_Regn_ID": deviceRegnId,
//       "imeI_Number": imeiNumber,
//       "os_Version": osVersion,
//       "trip_ID": tripId,
//       "start_Time": startTime,
//     };
//   }
//
//   static TripDetailsModel fromJsonString(String jsonData) {
//     return TripDetailsModel.fromJson(jsonDecode(jsonData));
//   }
// }
