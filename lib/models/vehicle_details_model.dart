class VehicleDetailsModel {
  final String? errorCode;
  final String? errorMessage;
  final int vehicleId;
  final double odometerLast;
  final double odometerBase;
  final VehicleDetails vehicleDetails;
  final ScheduledTripDetails schTripDetails;
  final EmergencyCaseDetails emgCaseDetails;
  final List<FuelHistory> fuelHistory;

  VehicleDetailsModel({
    this.errorCode,
    this.errorMessage,
    required this.vehicleId,
    required this.odometerLast,
    required this.odometerBase,
    required this.vehicleDetails,
    required this.schTripDetails,
    required this.emgCaseDetails,
    required this.fuelHistory,
  });

  factory VehicleDetailsModel.fromJson(Map<String, dynamic> json) {
    return VehicleDetailsModel(
      errorCode: json['error_Code'],
      errorMessage: json['error_Message'],
      vehicleId: json['vehicle_ID'] ?? 0,
      odometerLast: (json['odometer_Last'] ?? 0).toDouble(),
      odometerBase: (json['odometer_Base'] ?? 0).toDouble(),
      vehicleDetails: VehicleDetails.fromJson(json['vehicle_Details'] ?? {}),
      schTripDetails: ScheduledTripDetails.fromJson(json['sch_Trip_Details'] ?? {}),
      emgCaseDetails: EmergencyCaseDetails.fromJson(json['emg_Case_Details'] ?? {}),
      fuelHistory: (json['fule_History'] as List?)
          ?.map((e) => FuelHistory.fromJson(e))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'error_Code': errorCode,
      'error_Message': errorMessage,
      'vehicle_ID': vehicleId,
      'odometer_Last': odometerLast,
      'odometer_Base': odometerBase,
      'vehicle_Details': vehicleDetails.toJson(),
      'sch_Trip_Details': schTripDetails.toJson(),
      'emg_Case_Details': emgCaseDetails.toJson(),
      'fule_History': fuelHistory.map((e) => e.toJson()).toList(),
    };
  }
}

class VehicleDetails {
  final String vehicleNumber;
  final String petroCardNo;
  final String serviceType;
  final String district;
  final String baseBlock;
  final String baseLocation;
  final String onDutyStaffName;
  final double lastDutyCloseKm;

  VehicleDetails({
    required this.vehicleNumber,
    required this.petroCardNo,
    required this.serviceType,
    required this.district,
    required this.baseBlock,
    required this.baseLocation,
    required this.onDutyStaffName,
    required this.lastDutyCloseKm,
  });

  factory VehicleDetails.fromJson(Map<String, dynamic> json) {
    return VehicleDetails(
      vehicleNumber: json['vehicle_Number'] ?? '',
      petroCardNo: json['petro_Card_No'] ?? '',
      serviceType: json['service_Type'] ?? '',
      district: json['district'] ?? '',
      baseBlock: json['base_Block'] ?? '',
      baseLocation: json['base_Location'] ?? '',
      onDutyStaffName: json['on_Duty_Staff_Name'] ?? '',
      lastDutyCloseKm: (json['last_Duty_Close_KM'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vehicle_Number': vehicleNumber,
      'petro_Card_No': petroCardNo,
      'service_Type': serviceType,
      'district': district,
      'base_Block': baseBlock,
      'base_Location': baseLocation,
      'on_Duty_Staff_Name': onDutyStaffName,
      'last_Duty_Close_KM': lastDutyCloseKm,
    };
  }
}

class ScheduledTripDetails {
  final String tripId;
  final String serviceDistrict;
  final String serviceBlock;
  final String serviceLocation;
  final String startAt;
  final String seenArrivalAt;
  final String seenDepartAt;
  final double tripOdometer;

  ScheduledTripDetails({
    required this.tripId,
    required this.serviceDistrict,
    required this.serviceBlock,
    required this.serviceLocation,
    required this.startAt,
    required this.seenArrivalAt,
    required this.seenDepartAt,
    required this.tripOdometer,
  });

  factory ScheduledTripDetails.fromJson(Map<String, dynamic> json) {
    return ScheduledTripDetails(
      tripId: json['trip_ID'] ?? '',
      serviceDistrict: json['service_District'] ?? '',
      serviceBlock: json['service_Block'] ?? '',
      serviceLocation: json['service_Location'] ?? '',
      startAt: json['start_At'] ?? '',
      seenArrivalAt: json['seen_Arrival_At'] ?? '',
      seenDepartAt: json['seen_Depart_At'] ?? '',
      tripOdometer: (json['trip_Odometer'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'trip_ID': tripId,
      'service_District': serviceDistrict,
      'service_Block': serviceBlock,
      'service_Location': serviceLocation,
      'start_At': startAt,
      'seen_Arrival_At': seenArrivalAt,
      'seen_Depart_At': seenDepartAt,
      'trip_Odometer': tripOdometer,
    };
  }
}

class EmergencyCaseDetails {
  final String caseNo;
  final String serviceDistrict;
  final String serviceBlock;
  final String serviceLocation;
  final String jobStatTime;
  final String seenArrivalAt;
  final String procedureStartTime;
  final String procedureEndTime;
  final double caseOdometer;

  EmergencyCaseDetails({
    required this.caseNo,
    required this.serviceDistrict,
    required this.serviceBlock,
    required this.serviceLocation,
    required this.jobStatTime,
    required this.seenArrivalAt,
    required this.procedureStartTime,
    required this.procedureEndTime,
    required this.caseOdometer,
  });

  factory EmergencyCaseDetails.fromJson(Map<String, dynamic> json) {
    return EmergencyCaseDetails(
      caseNo: json['case_No'] ?? '0',
      serviceDistrict: json['service_District'] ?? '',
      serviceBlock: json['service_Block'] ?? '',
      serviceLocation: json['service_Location'] ?? '',
      jobStatTime: json['job_Stat_Time'] ?? '',
      seenArrivalAt: json['seen_Arrival_At'] ?? '',
      procedureStartTime: json['procedure_Start_Time'] ?? '',
      procedureEndTime: json['procedure_End_Time'] ?? '',
      caseOdometer: (json['case_Odometer'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'case_No': caseNo,
      'service_District': serviceDistrict,
      'service_Block': serviceBlock,
      'service_Location': serviceLocation,
      'job_Stat_Time': jobStatTime,
      'seen_Arrival_At': seenArrivalAt,
      'procedure_Start_Time': procedureStartTime,
      'procedure_End_Time': procedureEndTime,
      'case_Odometer': caseOdometer,
    };
  }
}

class FuelHistory {
  final String ticketNumber;
  final String entryTime;
  final String tripId;
  final String caseNo;
  final String odometerBase;
  final String odometer;
  final String odometerBackAtBase;
  final String fuelStationName;
  final double quantity;
  final double unitPrice;
  final double amount;
  final String paymentMode;

  FuelHistory({
    required this.ticketNumber,
    required this.entryTime,
    required this.tripId,
    required this.caseNo,
    required this.odometerBase,
    required this.odometer,
    required this.odometerBackAtBase,
    required this.fuelStationName,
    required this.quantity,
    required this.unitPrice,
    required this.amount,
    required this.paymentMode,
  });

  factory FuelHistory.fromJson(Map<String, dynamic> json) {
    return FuelHistory(
      ticketNumber: json['ticket_Number'] ?? '',
      entryTime: json['entry_Time'] ?? '',
      tripId: json['trip_ID'] ?? '',
      caseNo: json['case_No'] ?? '',
      odometerBase: json['odometer_Base'] ?? '',
      odometer: json['odometer'] ?? '',
      odometerBackAtBase: json['odometer_Back_At_Base'] ?? '',
      fuelStationName: json['fuel_Station_Name'] ?? '',
      quantity: (json['quantity'] ?? 0).toDouble(),
      unitPrice: (json['unit_Price'] ?? 0).toDouble(),
      amount: (json['amount'] ?? 0).toDouble(),
      paymentMode: json['payment_Mode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ticket_Number': ticketNumber,
      'entry_Time': entryTime,
      'trip_ID': tripId,
      'case_No': caseNo,
      'odometer_Base': odometerBase,
      'odometer': odometer,
      'odometer_Back_At_Base': odometerBackAtBase,
      'fuel_Station_Name': fuelStationName,
      'quantity': quantity,
      'unit_Price': unitPrice,
      'amount': amount,
      'payment_Mode': paymentMode,
    };
  }
} 