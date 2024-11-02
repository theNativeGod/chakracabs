import 'package:flutter/material.dart';

push(BuildContext context, Widget Screen) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (ctx) => Screen),
  );
}

replace(BuildContext context, Widget Screen) {
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (ctx) => Screen),
  );
}

void showSnackbar(String text, Color color, BuildContext context) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: color,
      duration: Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
