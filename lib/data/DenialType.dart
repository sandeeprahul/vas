class DenialType {
  final int id;
  final String text;
  final int order;

  DenialType({required this.id, required this.text, required this.order});

  factory DenialType.fromJson(Map<String, dynamic> json) {
    return DenialType(
      id: json['ddT_ID'],
      text: json['ddT_TEXT'],
      order: json['order'],
    );
  }

  Map<String, dynamic> toJson() => {
    'ddT_ID': id,
    'ddT_TEXT': text,
    'order': order,
  };
}
