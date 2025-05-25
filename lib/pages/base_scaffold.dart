import 'package:flutter/material.dart';


// Create a base scaffold widget that all pages can use
class BaseScaffold extends StatelessWidget {
  final Widget body;
  final int currentIndex;

  const BaseScaffold({
    Key? key,
    required this.body,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5F4E5),
      body: body,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/scan');
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.camera_alt_outlined, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => _onItemTapped(context, index),
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        backgroundColor: const Color(0xFFE5F4E5),
        elevation: 8,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.info_outline), label: 'About'),
          BottomNavigationBarItem(icon: Icon(Icons.camera_alt_outlined), label: 'Scan'),
          BottomNavigationBarItem(icon: Icon(Icons.book_outlined), label: 'Almanac'),
          BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: 'Devs'),
        ],
      ),
    );
  }

  void _onItemTapped(BuildContext context, int index) {
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        break;
      case 1:
        Navigator.pushNamedAndRemoveUntil(context, '/about', (route) => false);
        break;
      case 2:
        Navigator.pushNamed(context, '/scan');
        break;
      case 3:
        Navigator.pushNamedAndRemoveUntil(context, '/almanac', (route) => false);
        break;
      case 4:
        Navigator.pushNamedAndRemoveUntil(context, '/developers', (route) => false);
        break;
    }
  }
}
