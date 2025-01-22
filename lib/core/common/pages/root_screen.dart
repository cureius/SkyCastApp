
import 'package:flutter/material.dart';
import 'package:sky_cast/features/weather/presentation/pages/favorite_page.dart';
import 'package:sky_cast/features/weather/presentation/pages/weathers_page.dart';

class RootScreen extends StatefulWidget {
  static route() => MaterialPageRoute(
    builder: (context) => const RootScreen(),
  );
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}


class _RootScreenState extends State<RootScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const WeatherPage(),
    const FavoritePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.location_history),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
