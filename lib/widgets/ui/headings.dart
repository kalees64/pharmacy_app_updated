import 'package:flutter/material.dart';

Widget h1(String title, {Color color = Colors.black}) {
  return Text(
    title,
    style: TextStyle(
      fontSize: 25,
      fontWeight: FontWeight.bold,
      color: color,
    ),
  );
}

Widget h2(String title, {Color color = Colors.black}) {
  return Text(
    title,
    style: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: color,
    ),
  );
}

Widget navBarTitle(String title) {
  return Text(
    title,
    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
  );
}
