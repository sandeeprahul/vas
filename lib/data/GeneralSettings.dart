class GeneralSettings {
  final String projectName;
  final bool featureEnabled;

  GeneralSettings({required this.projectName, required this.featureEnabled});

  factory GeneralSettings.fromJson(Map<String, dynamic> json) {
    return GeneralSettings(
      projectName: json['projectName'],
      featureEnabled: json['featureEnabled'],
    );
  }

  Map<String, dynamic> toJson() => {
    'projectName': projectName,
    'featureEnabled': featureEnabled,
  };
}
