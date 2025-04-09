class PatientType {
  final int pT_ID;
  final String pT_TEXT;

  PatientType({required this.pT_ID, required this.pT_TEXT});

  factory PatientType.fromJson(Map<String, dynamic> json) {
    return PatientType(
      pT_ID: json['pT_ID'],
      pT_TEXT: json['pT_TEXT'],
    );
  }
}

class PatientSubType {
  final int pT_ID;
  final int ptS_ID;
  final String ptS_TEXT;

  PatientSubType({required this.pT_ID, required this.ptS_ID, required this.ptS_TEXT});

  factory PatientSubType.fromJson(Map<String, dynamic> json) {
    return PatientSubType(
      pT_ID: json['pT_ID'],
      ptS_ID: json['ptS_ID'],
      ptS_TEXT: json['ptS_TEXT'],
    );
  }
}
