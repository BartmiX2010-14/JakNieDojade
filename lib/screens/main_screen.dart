import 'package:flutter/material.dart';
import 'home/home_screen.dart';
import 'generator/generator_screen.dart';
import 'situations/situations_screen.dart';
import 'profile/profile_screen.dart';
import 'teach_ai/teach_ai_screen.dart'; // Nowy ekran v5.0

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const GeneratorScreen(),
    const SituationsScreen(),
    const TeachAiScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF755BFF),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Główna'),
          BottomNavigationBarItem(icon: Icon(Icons.auto_awesome_rounded), label: 'AI'),
          BottomNavigationBarItem(icon: Icon(Icons.explore_rounded), label: 'Sytuacje'),
          BottomNavigationBarItem(icon: Icon(Icons.psychology_rounded), label: 'Ucz AI'),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profil'),
        ],
      ),
    );
  }
}
