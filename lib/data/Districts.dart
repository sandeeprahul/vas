class Districts {
  int id;
  String name;

  Districts({
    required this.id,
    required this.name,
  });

  factory Districts.fromJson(Map<String, dynamic> json) => Districts(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}