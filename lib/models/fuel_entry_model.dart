class FuelEntryModel {
  final int userId;
  final String entryDateTime;
  final int vehicleId;
  final int tripId;
  final int caseId;
  final String odometerLast;
  final String odometerBase;
  final String odometer;
  final String odometerBackAtBase;
  final String fuelStationName;
  final double quantity;
  final double unitPrice;
  final int modeOfPayment;
  final String paymentRefNo;
  final String billNo;
  final String docOdometer;
  final String docOdometerName;
  final String docBill;
  final String docBillName;
  final double latitude;
  final double longitude;

  FuelEntryModel({
    required this.userId,
    required this.entryDateTime,
    required this.vehicleId,
    required this.tripId,
    required this.caseId,
    required this.odometerLast,
    required this.odometerBase,
    required this.odometer,
    required this.odometerBackAtBase,
    required this.fuelStationName,
    required this.quantity,
    required this.unitPrice,
    required this.modeOfPayment,
    required this.paymentRefNo,
    required this.billNo,
    required this.docOdometer,
    required this.docOdometerName,
    required this.docBill,
    required this.docBillName,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_ID': userId,
      'entry_DateTime': entryDateTime,
      'vehicle_ID': vehicleId,
      'trip_ID': tripId,
      'case_ID': caseId,
      'odometer_Last': odometerLast,
      'odometer_Base': odometerBase,
      'odometer': odometer,
      'odometer_Back_At_Base': odometerBackAtBase,
      'fuel_Station_Name': fuelStationName,
      'quantity': quantity,
      'unit_Price': unitPrice,
      'mode_Of_Payment': modeOfPayment,
      'payment_Ref_No': paymentRefNo,
      'bill_No': billNo,
      'doc_Odometer': docOdometer,
      'doc_Odometer_Name': docOdometerName,
      'doc_Bill': docBill,
      'doc_Bill_Name': docBillName,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
} 