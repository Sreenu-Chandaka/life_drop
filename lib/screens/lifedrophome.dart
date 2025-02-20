import 'package:flutter/material.dart';
import 'package:life_drop/screens/home.dart';

import 'blood_request_screen.dart';
import 'profile_screen.dart';
import 'receivers_screen.dart';

class LifeDropHome extends StatefulWidget {
  const LifeDropHome({super.key});

  @override
  _LifeDropHomeState createState() => _LifeDropHomeState();
}

class _LifeDropHomeState extends State<LifeDropHome> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const BloodRequestScreen(),
    const ReceiversScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Icon(Icons.bloodtype, color: Colors.red[700]),
            const SizedBox(width: 8),
            Text(
              'Life Drop',
              style: TextStyle(
                color: Colors.red[900],
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            color: Colors.red[700],
            onPressed: () {},
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _widgetOptions[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined,
                  color: _selectedIndex == 0 ? Colors.red[700] : Colors.grey),
              activeIcon: Icon(Icons.home,
                  color: Theme.of(context).colorScheme.primary),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bloodtype_outlined,
                  color: _selectedIndex == 1 ? Colors.red[700] : Colors.grey),
              activeIcon: Icon(Icons.bloodtype,
                  color: Theme.of(context).colorScheme.primary),
              label: 'Request',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline,
                  color: _selectedIndex == 2 ? Colors.red[700] : Colors.grey),
              activeIcon: Icon(Icons.people,
                  color: Theme.of(context).colorScheme.primary),
              label: 'Receivers',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline,
                  color: _selectedIndex == 3 ? Colors.red[700] : Colors.grey),
              activeIcon: Icon(Icons.person,
                  color: Theme.of(context).colorScheme.primary),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          elevation: 0,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
