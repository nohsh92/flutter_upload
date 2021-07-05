import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loginpage/main.dart';

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

dynamic tokenIsValid(String jwtStr) {
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
