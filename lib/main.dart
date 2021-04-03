import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SignUpSection(), routes: {
      LandingScreen.id: (context) => LandingScreen(),
      LoginSection.id: (context) => LoginSection(),
      LogoutScreen.id: (context) => LogoutScreen(),
    });
  }
}

// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
class SignUpSection extends StatelessWidget {
  var email;
  var password;

  @override
  Widget build(BuildContext context) {
    checkToken() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token');
      if (token != null) {
        Navigator.pushNamed(context, LandingScreen.id);
      }
    }

    checkToken();
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        automaticallyImplyLeading: false,
      ),
      child: SafeArea(
        child: ListView(
          restorationId: 'text_field_demo_list_view',
          padding: const EdgeInsets.all(16),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: CupertinoTextField(
                restorationId: 'email_address_text_field',
                placeholder: "Email",
                keyboardType: TextInputType.emailAddress,
                clearButtonMode: OverlayVisibilityMode.editing,
                autocorrect: false,
                onChanged: (value) {
                  email = value;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: CupertinoTextField(
                restorationId: 'login_password_text_field',
                placeholder: "Password",
                clearButtonMode: OverlayVisibilityMode.editing,
                obscureText: true,
                autocorrect: false,
                onChanged: (value) {
                  password = value;
                },
              ),
            ),
            TextButton.icon(
                onPressed: () async {
                  await signup(email, password);
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  String token = prefs.getString('token');
                  if (token != null) {
                    Navigator.pushNamed(context, LandingScreen.id);
                  }
                },
                icon: Icon(Icons.save),
                label: Text("Sign up")),
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, LoginSection.id);
                },
                child: Text("login")),
          ],
        ),
      ),
    );
  }
}

signup(email, password) async {
  final http.Response response = await http.post(
    Uri.http("127.0.0.1:5000", "/signup"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': email,
      'password': password,
    }),
  );

  print(response.body);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var parse = jsonDecode(response.body);

  await prefs.setString('token', parse["token"]);
}

class LoginSection extends StatelessWidget {
  static const String id = "LoginSection";
  var email;
  var password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          automaticallyImplyLeading: false,
        ),
        child: SafeArea(
          child: ListView(
            restorationId: 'text_field_demo_list_view',
            padding: const EdgeInsets.all(16),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: CupertinoTextField(
                  restorationId: 'email_address_text_field',
                  placeholder: "Email",
                  keyboardType: TextInputType.emailAddress,
                  clearButtonMode: OverlayVisibilityMode.editing,
                  autocorrect: false,
                  onChanged: (value) {
                    email = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: CupertinoTextField(
                  restorationId: 'login_password_text_field',
                  placeholder: "Password",
                  clearButtonMode: OverlayVisibilityMode.editing,
                  obscureText: true,
                  autocorrect: false,
                  onChanged: (value) {
                    password = value;
                  },
                ),
              ),
              TextButton.icon(
                  onPressed: () async {
                    await login(email, password);
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    String token = prefs.getString('token');
                    if (token != null) {
                      Navigator.pushNamed(context, LandingScreen.id);
                    }
                  },
                  icon: Icon(Icons.save),
                  label: Text("Login"))
            ],
          ),
        ),
      ),
    );
  }
}

login(email, password) async {
  final http.Response response = await http.post(
    Uri.http("127.0.0.1:5000", "/login"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': email,
      'password': password,
    }),
  );
  print(response.body);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var parse = jsonDecode(response.body);

  await prefs.setString('token', parse["token"]);
}

class LandingScreen extends StatelessWidget {
  static const String id = "LandingScreen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(child: Text("Welcome to the Landing Screen")),
          TextButton.icon(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString('token', '');
                Navigator.pushNamed(context, LoginSection.id);
              },
              icon: Icon(Icons.send),
              label: Text("Logout"))
        ],
      ),
      bottomNavigationBar: _BottomNav(),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class _BottomNav extends StatefulWidget {
  const _BottomNav({Key key}) : super(key: key);

  @override
  __BottomNavState createState() => __BottomNavState();
}

/// This is the private State class that goes with _BottomNav.
class __BottomNavState extends State<_BottomNav> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        Navigator.pushNamed(context, LandingScreen.id);
      }
      if (index == 1) {
        Navigator.pushNamed(context, LandingScreen.id);
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
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.business),
          label: 'Business',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.school),
          label: 'Logout',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.amber[800],
      onTap: _onItemTapped,
    );
  }
}

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
                Navigator.pushNamed(context, LoginSection.id);
              },
              icon: Icon(Icons.send),
              label: Text("Logout"))
        ],
      ),
      bottomNavigationBar: _BottomNav(),
    );
  }
}
