class Food {
  final int? id;
  final String name;
  final String category;
  final bool isAllowed;
  final String description;

  Food({
    this.id,
    required this.name,
    required this.category,
    required this.isAllowed,
    this.description = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'isAllowed': isAllowed ? 1 : 0,
      'description': description,
    };
  }

  factory Food.fromMap(Map<String, dynamic> map) {
    return Food(
      id: map['id'],
      name: map['name'],
      category: map['category'],
      isAllowed: map['isAllowed'] == 1,
      description: map['description'],
    );
  }
}