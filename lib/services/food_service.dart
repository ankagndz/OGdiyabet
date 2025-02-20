import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/food_item.dart';

class FoodService {
  static const String apiUrl = 'https://oguzcangunduz.com.tr/diyabet-data.json';

  static Future<List<FoodItem>> getFoods() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final foods = (data['foods'] as List).map((food) => FoodItem(
          name: food['name'],
          category: food['category'],
          isAllowed: food['isAllowed'],
          description: food['description'],
          glycemicIndex: food['glycemicIndex']?.toDouble(),
        )).toList();
        return foods;
      }
      throw Exception('Veri yüklenemedi');
    } catch (e) {
      throw Exception('Bağlantı hatası: $e');
    }
  }

  static Future<List<String>> getCategories() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<String>.from(data['categories']);
      }
      throw Exception('Kategoriler yüklenemedi');
    } catch (e) {
      throw Exception('Bağlantı hatası: $e');
    }
  }
}
