class IncidentType {
  final int? incidentId;
  final String? incidentType;
  final String? incidentName;
  final int? isCovered;
  final int? serviceTypeId;
  final List<String>? regnTypes;

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
      incidentId: json['incident_ID']??-1,
      incidentType: json['incident_Type']??'',
      incidentName: json['incident_Name']??'',
      isCovered: json['isCovered']??-1,
      serviceTypeId: json['service_Type_ID']??-1,
      regnTypes: (json['regn_Types'] as List<dynamic>)
          .map((e) => e['regnType'] as String)
          .toList()??[],    );
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
class IncidentSubType {
  final int incidentID;
  final int subID;
  final String subType;

  IncidentSubType({
    required this.incidentID,
    required this.subID,
    required this.subType,
  });

  factory IncidentSubType.fromJson(Map<String, dynamic> json) {
    return IncidentSubType(
      incidentID: json['incident_ID'],
      subID: json['incident_Sub_ID'],
      subType: json['incident_Sub_Type'].trim(),
    );
  }
}
