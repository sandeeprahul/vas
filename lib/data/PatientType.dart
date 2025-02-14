class PatientType {
  final String type;
  final List<String> subTypes;

  PatientType({required this.type, required this.subTypes});

  factory PatientType.fromJson(Map<String, dynamic> json) {
    return PatientType(
      type: json['type'],
      subTypes: List<String>.from(json['subTypes'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    'subTypes': subTypes,
  };
}
