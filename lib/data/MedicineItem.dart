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
}
