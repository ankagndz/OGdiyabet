import 'package:flutter/material.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({super.key});

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            color: const Color(0xFF1C2732),
            child: ListTile(
              title: Text('Sağlıklı Tarifler',
                style: Theme.of(context).textTheme.titleLarge),
              subtitle: const Text('Diyabetik beslenmeye uygun tarifler',
                style: TextStyle(color: Colors.white70)),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
