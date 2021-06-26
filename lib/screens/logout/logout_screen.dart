import 'package:flutter/material.dart';
import 'package:loginpage/widgets/bottom_nav_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';

class LogoutScreen extends StatelessWidget {
  static const String id = "LogoutScreen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text("Logout")),
          TextButton.icon(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString('token', '');
                Navigator.pushNamed(context, LoginScreen.id);
              },
              icon: Icon(Icons.send),
              label: Text("Logout"))
        ],
      ),
      bottomNavigationBar: BottomNavWidget(),
    );
  }
}
