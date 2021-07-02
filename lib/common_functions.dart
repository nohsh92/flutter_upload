import 'package:flutter/material.dart';
import 'package:loginpage/main.dart';

void displayDialog(context, title, text) => showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(title: Text(title), content: Text(text)),
    );

Future<String> get jwtOrEmpty async {
  var jwt = await storage.read(key: "jwt");
  // storage.delete(key: "jwt");
  if (jwt == null) return "";
  return jwt;
}
