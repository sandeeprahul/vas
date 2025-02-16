

class Doctor {
  List<DoctorDatum> doctorData;

  Doctor({
    required this.doctorData,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) => Doctor(
    doctorData: List<DoctorDatum>.from(json["doctorData"].map((x) => DoctorDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "doctorData": List<dynamic>.from(doctorData.map((x) => x.toJson())),
  };
}

class DoctorDatum {
  int doctorId;
  String doctorName;
  String contactNo;

  DoctorDatum({
    required this.doctorId,
    required this.doctorName,
    required this.contactNo,
  });

  factory DoctorDatum.fromJson(Map<String, dynamic> json) => DoctorDatum(
    doctorId: json["doctor_ID"],
    doctorName: json["doctor_Name"],
    contactNo: json["contact_No"],
  );

  Map<String, dynamic> toJson() => {
    "doctor_ID": doctorId,
    "doctor_Name": doctorName,
    "contact_No": contactNo,
  };
}