import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:pharmacy_app_updated/screens/login_screen.dart';
import 'package:pharmacy_app_updated/screens/role_selection_screen.dart';
import 'package:pharmacy_app_updated/widgets/ui/no_connection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  Widget startScreen = LoginScreen();
  bool isConnectedToInternet = false;

  StreamSubscription? _internetConnectionStreamSubscription;

  @override
  void initState() {
    super.initState();
    _internetConnectionStreamSubscription =
        InternetConnection().onStatusChange.listen((event) {
      switch (event) {
        case InternetStatus.connected:
          setState(() {
            isConnectedToInternet = true;
          });
          break;
        case InternetStatus.disconnected:
          setState(() {
            isConnectedToInternet = false;
          });
          break;
        default:
          setState(() {
            isConnectedToInternet = false;
          });
          break;
      }
    });
    checkUserLogin();
  }

  void checkUserLogin() async {
    final SharedPreferences localStorage =
        await SharedPreferences.getInstance();
    var user = localStorage.getString('user');
    var token = localStorage.getString('token');
    if (user != null && token != null) {
      setState(() {
        startScreen = RoleSelectionScreen();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: isConnectedToInternet
          ? startScreen
          : Scaffold(
              body: Center(
                child: noInternet(),
              ),
            ),
    );
  }
}
