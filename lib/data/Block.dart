class Block {
  final int districtId;
  final int blockId;
  final String name;

  Block({required this.districtId, required this.blockId, required this.name});

  factory Block.fromJson(Map<String, dynamic> json) {
    return Block(
      districtId: json['districtId'],
      blockId: json['blockId'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() => {
    'districtId': districtId,
    'blockId': blockId,
    'name': name,
  };
}
