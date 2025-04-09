class MedicineItem {
  final String itemName;
  final String itemUnit;
  final String itemNumber;
  String quantity;

  MedicineItem({
    required this.itemName,
    required this.itemUnit,
    required this.itemNumber,
    this.quantity = '',
  });
  factory MedicineItem.fromJson(Map<String, dynamic> json) {
    return MedicineItem(
      itemName: json['item_name'] ?? '',
      itemUnit: json['item_unit'] ?? '',
      itemNumber: json['item_number'] ?? '',
      quantity: json['quantity'] ?? '',
    );
  }

  // ✅ Convert MedicineItem object to JSON
  Map<String, dynamic> toJson() {
    return {
      'item_name': itemName,
      'item_unit': itemUnit,
      'item_number': itemNumber,
      'quantity': quantity,
    };
  }
}
