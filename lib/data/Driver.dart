class Driver {
  final int driverId;
  final String driverName;
  final String contactNo;

  Driver({required this.driverId, required this.driverName, required this.contactNo});

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      driverId: json['driver_ID'],
      driverName: json['driver_Name'],
      contactNo: json['contact_No'],
    );
  }

  Map<String, dynamic> toJson() => {
    'driver_ID': driverId,
    'driver_Name': driverName,
    'contact_No': contactNo,
  };
}
