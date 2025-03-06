import 'package:flutter/material.dart';

Widget noInternet() {
  return Expanded(
      child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(Icons.wifi_off),
      Text('No Internet'),
    ],
  ));
}
