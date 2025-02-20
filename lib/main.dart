import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/home_page.dart';
import 'pages/measurements_page.dart';
import 'pages/food_guide_page.dart';
import 'pages/recipes_page.dart';
import 'pages/settings_page.dart';
import 'providers/measurement_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => MeasurementProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OG Diyabet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF15202B),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF15202B),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF15202B),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          titleLarge: TextStyle(color: Colors.white),
          headlineMedium: TextStyle(color: Colors.white),
          labelLarge: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    HomePage(),
    MeasurementsPage(),
    FoodGuidePage(),
    RecipesPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OG Diyabet'),
        centerTitle: true,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedIndex: _selectedIndex,
        backgroundColor: const Color(0xFF15202B),
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.home, color: Colors.white),
            label: 'Ana Sayfa',
          ),
          NavigationDestination(
            icon: Icon(Icons.monitor_heart, color: Colors.white),
            label: 'Ölçümler',
          ),
          NavigationDestination(
            icon: Icon(Icons.food_bank, color: Colors.white),
            label: 'Besinler',
          ),
          NavigationDestination(
            icon: Icon(Icons.restaurant_menu, color: Colors.white),
            label: 'Tarifler',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings, color: Colors.white),
            label: 'Ayarlar',
          ),
        ],
      ),
    );
  }
}
