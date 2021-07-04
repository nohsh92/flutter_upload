import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loginpage/main.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:loginpage/screens/home/home_screen.dart';
import 'package:loginpage/screens/login/login_screen.dart';

void displayDialog(context, title, text) => showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(title: Text(title), content: Text(text)),
    );

Future<String> get checkForJWT async {
  var jwt = await storage.read(key: "jwt");
  // storage.delete(key: "jwt");
  if (jwt == null) return "";
  return jwt;
}

dynamic tokenIsValid(dynamic jwtStr) {
  var jwt = jwtStr.split(".");
  if (jwt.length != 3) {
    return false;
  } else {
    var payload =
        json.decode(utf8.decode(base64.decode(base64.normalize(jwt[1]))));

    if (DateTime.fromMillisecondsSinceEpoch(payload["exp"] * 1000)
        .isAfter(DateTime.now())) {
      return payload;
    } else {
      return false;
    }
  }
}
