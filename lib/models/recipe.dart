class Recipe {
  final int? id;
  final String name;
  final List<String> ingredients;
  final String instructions;
  final String category;
  final int preparationTime;
  final int calories;

  Recipe({
    this.id,
    required this.name,
    required this.ingredients,
    required this.instructions,
    required this.category,
    required this.preparationTime,
    required this.calories,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'ingredients': ingredients.join('|'),
      'instructions': instructions,
      'category': category,
      'preparationTime': preparationTime,
      'calories': calories,
    };
  }

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'],
      name: map['name'],
      ingredients: map['ingredients'].split('|'),
      instructions: map['instructions'],
      category: map['category'],
      preparationTime: map['preparationTime'],
      calories: map['calories'],
    );
  }
}