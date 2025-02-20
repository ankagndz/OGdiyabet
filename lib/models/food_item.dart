class FoodItem {
  final String name;
  final String category;
  final bool isAllowed;
  final String description;
  final double? glycemicIndex; // Glisemik indeks değeri (varsa)

  const FoodItem({
    required this.name,
    required this.category,
    required this.isAllowed,
    this.description = '',
    this.glycemicIndex,
  });
}
