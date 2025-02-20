import 'package:flutter/material.dart';
import '../models/food_item.dart';
import '../data/food_data.dart';

class FoodGuidePage extends StatefulWidget {
  const FoodGuidePage({super.key});

  @override
  State<FoodGuidePage> createState() => _FoodGuidePageState();
}

class _FoodGuidePageState extends State<FoodGuidePage> {
  String _searchQuery = '';
  String? _selectedCategory;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      await FoodData.initialize();
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Hata: $_error', style: const TextStyle(color: Colors.red)),
            ElevatedButton(
              onPressed: _loadData,
              child: const Text('Tekrar Dene'),
            ),
          ],
        ),
      );
    }

    List<FoodItem> displayedFoods = _searchQuery.isEmpty && _selectedCategory == null
        ? FoodData.foods
        : _searchQuery.isNotEmpty
            ? FoodData.searchFoods(_searchQuery)
            : FoodData.getFoodsByCategory(_selectedCategory!);

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Arama Çubuğu
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Yiyecek veya içecek ara...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: const Color(0xFF1C2732),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                      _selectedCategory = null;
                    });
                  },
                ),
                const SizedBox(height: 16),
                // Kategori Filtreleri
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: const Text('Tümü'),
                          selected: _selectedCategory == null,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = null;
                              _searchQuery = '';
                            });
                          },
                        ),
                      ),
                      ...FoodData.categories.map((category) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(category),
                            selected: _selectedCategory == category,
                            onSelected: (selected) {
                              setState(() {
                                _selectedCategory = selected ? category : null;
                                _searchQuery = '';
                              });
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: displayedFoods.length,
              itemBuilder: (context, index) {
                final food = displayedFoods[index];
                return Card(
                  color: const Color(0xFF1C2732),
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ListTile(
                    leading: Icon(
                      food.isAllowed ? Icons.check_circle : Icons.cancel,
                      color: food.isAllowed ? Colors.green : Colors.red,
                    ),
                    title: Text(
                      food.name,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          food.category,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                          ),
                        ),
                        if (food.description.isNotEmpty)
                          Text(
                            food.description,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                            ),
                          ),
                        if (food.glycemicIndex != null)
                          Text(
                            'Glisemik İndeks: ${food.glycemicIndex}',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
