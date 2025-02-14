class IncidentType {
  final int incidentId;
  final String incidentType;
  final String incidentName;
  final bool isCovered;
  final int serviceTypeId;
  final List<String> regnTypes;

  IncidentType({
    required this.incidentId,
    required this.incidentType,
    required this.incidentName,
    required this.isCovered,
    required this.serviceTypeId,
    required this.regnTypes,
  });

  factory IncidentType.fromJson(Map<String, dynamic> json) {
    return IncidentType(
      incidentId: json['incident_ID'],
      incidentType: json['incident_Type'],
      incidentName: json['incident_Name'],
      isCovered: json['isCovered'],
      serviceTypeId: json['service_Type_ID'],
      regnTypes: List<String>.from(json['regn_Types'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
    'incident_ID': incidentId,
    'incident_Type': incidentType,
    'incident_Name': incidentName,
    'isCovered': isCovered,
    'service_Type_ID': serviceTypeId,
    'regn_Types': regnTypes,
  };
}
