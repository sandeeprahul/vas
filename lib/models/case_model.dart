// lib/models/case_model.dart
class CaseModel {
  final String caseNo;
  final String status;
  final String district;
  final String block;
  final String livestockDetails;
  final String serviceAddress;
  final String callerName; // Added this field

  CaseModel({
    required this.caseNo,
    required this.status,
    required this.district,
    required this.block,
    required this.livestockDetails,
    required this.serviceAddress,
    required this.callerName, // Added this parameter
  });

  factory CaseModel.fromJson(Map<String, dynamic> json) {
    return CaseModel(
      caseNo: json['caseNo'] ?? '',
      status: json['status'] ?? '',
      district: json['district'] ?? '',
      block: json['block'] ?? '',
      livestockDetails: json['livestockDetails'] ?? '',
      serviceAddress: json['serviceAddress'] ?? '',
      callerName: json['callerName'] ?? '', // Added this field
    );
  }
}