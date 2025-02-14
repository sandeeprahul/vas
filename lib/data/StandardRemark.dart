class StandardRemark {
  final int id;
  final String type;
  final String remark;

  StandardRemark({required this.id, required this.type, required this.remark});

  factory StandardRemark.fromJson(Map<String, dynamic> json) {
    return StandardRemark(
      id: json['sR_ID'],
      type: json['sR_Type'],
      remark: json['sR_Remark'],
    );
  }

  Map<String, dynamic> toJson() => {
    'sR_ID': id,
    'sR_Type': type,
    'sR_Remark': remark,
  };
}
