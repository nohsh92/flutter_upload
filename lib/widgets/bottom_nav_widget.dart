import 'package:flutter/material.dart';
import 'package:loginpage/screens/home/landing_screen.dart';
import 'package:loginpage/screens/item/item_screen.dart';
import 'package:loginpage/screens/logout/logout_screen.dart';
import '../globals.dart';

/// TODO : Check using Stacks to position new widgets using Offset widget

/// This is the stateful widget that the main application instantiates.
class BottomNavWidget extends StatefulWidget {
  const BottomNavWidget({Key key}) : super(key: key);

  @override
  _BottomNavWidgetState createState() => _BottomNavWidgetState();
}

/// This is the private State class that goes with _BottomNav.
class _BottomNavWidgetState extends State<BottomNavWidget> {
  void _onItemTapped(int index) {
    setState(() {
      selectedPageIndex = index;
      if (index == 0) {
        Navigator.pushNamed(context, LandingScreen.id);
      }
      if (index == 1) {
        Navigator.pushNamed(context, ItemScreen.id);
      }
      if (index == 2) {
        Navigator.pushNamed(context, LogoutScreen.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.category),
          label: 'Categories',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: 'Items',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.logout),
          label: 'Logout',
        ),
      ],
      currentIndex: selectedPageIndex,
      selectedItemColor: Colors.blue[800],
      onTap: _onItemTapped,
    );
  }
}
