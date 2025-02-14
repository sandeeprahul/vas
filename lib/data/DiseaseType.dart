class DiseaseType {
  final int diseaseId;
  final String diseaseName;

  DiseaseType({required this.diseaseId, required this.diseaseName});

  factory DiseaseType.fromJson(Map<String, dynamic> json) {
    return DiseaseType(
      diseaseId: json['disease_ID'],
      diseaseName: json['disease_Name'],
    );
  }

  Map<String, dynamic> toJson() => {
    'disease_ID': diseaseId,
    'disease_Name': diseaseName,
  };
}
