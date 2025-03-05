import 'package:flutter/material.dart';
import 'package:pharmacy_app_updated/screens/login_screen.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Pharmacy",
      home: Scaffold(
        body: LoginScreen(),
      ),
    );
  }
}
