import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/food_item.dart';

class FoodData {
  static const String apiUrl = 'https://oguzcangunduz.com.tr/diyabet-data.json';
  static List<FoodItem> _foods = [];
  static List<String> _categories = [];
  static bool _isInitialized = false;

  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {'Accept-Charset': 'utf-8'},
      );
      
      if (response.statusCode == 200) {
        // UTF-8 encoding ile decode et
        final String decodedBody = utf8.decode(response.bodyBytes);
        final data = json.decode(decodedBody);
        
        _categories = List<String>.from(data['categories']);
        
        _foods = (data['foods'] as List).map((food) => FoodItem(
          name: food['name'],
          category: food['category'],
          isAllowed: food['isAllowed'],
          description: food['description'],
          glycemicIndex: food['glycemicIndex']?.toDouble(),
        )).toList();

        _isInitialized = true;
      } else {
        throw Exception('Veri yüklenemedi: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Veri yükleme hatası: $e');
    }
  }

  static List<String> get categories {
    if (!_isInitialized) throw Exception('FoodData henüz başlatılmadı');
    return _categories;
  }

  static List<FoodItem> get foods {
    if (!_isInitialized) throw Exception('FoodData henüz başlatılmadı');
    return List<FoodItem>.from(_foods);
  }

  static List<FoodItem> getFoodsByCategory(String category) {
    if (!_isInitialized) throw Exception('FoodData henüz başlatılmadı');
    return _foods
        .where((f) => f.category == category)
        .toList()
        ..sort((a, b) => a.name.compareTo(b.name));
  }

  static List<FoodItem> searchFoods(String query) {
    if (!_isInitialized) throw Exception('FoodData henüz başlatılmadı');
    return _foods
        .where((f) =>
            f.name.toLowerCase().contains(query.toLowerCase()) ||
            f.category.toLowerCase().contains(query.toLowerCase()) ||
            f.description.toLowerCase().contains(query.toLowerCase()))
        .toList()
        ..sort((a, b) => a.name.compareTo(b.name));
  }
}
