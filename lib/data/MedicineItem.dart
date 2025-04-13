class MedicineItem {
  final int item_ID;
  final String itemName;
  final String iD_Name;
  final String itemUnit;
  final String itemNumber;
  final String itemType;
  final double itemPrice;
  String quantity;

  MedicineItem({
    required this.item_ID,
    required this.iD_Name,
    required this.itemName,
    required this.itemUnit,
    required this.itemNumber,
    required this.itemType,
    required this.itemPrice,
    this.quantity = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'item_ID': item_ID,
      'iD_Name': iD_Name,
      'item_Name': itemName,
      'item_Unit': itemUnit,
      'item_Number': itemNumber,
      'item_Type': itemType,
      'item_Price': itemPrice,
      'quantity': quantity,
    };
  }
}
