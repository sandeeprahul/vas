class EventType {
  final String eventType;
  final String description;
  final String groupId;

  EventType({required this.eventType, required this.description, required this.groupId});

  factory EventType.fromJson(Map<String, dynamic> json) {
    return EventType(
      eventType: json['evenT_TYPE'],
      description: json['description'],
      groupId: json['grouP_ID'],
    );
  }

  Map<String, dynamic> toJson() => {
    'evenT_TYPE': eventType,
    'description': description,
    'grouP_ID': groupId,
  };
}