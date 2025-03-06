import 'package:flutter/material.dart';
import 'package:pharmacy_app_updated/screens/login_screen.dart';
import 'package:pharmacy_app_updated/services/auth.service.dart';

class AuthGuard extends StatefulWidget {
  const AuthGuard({super.key, required this.child});

  final Widget child;

  @override
  State<AuthGuard> createState() => _AuthGuardState();
}

class _AuthGuardState extends State<AuthGuard> {
  AuthService authService = AuthService();

  late dynamic user;
  late dynamic token;
  bool isLoading = true;

  @override
  void initState() {
    fetchUserDetails();
    super.initState();
  }

  void fetchUserDetails() async {
    final fetchedUser = await authService.getUserDataFromLocalStorage();
    final fetchedToken = await authService.getUserTokenFromLocalStorage();

    setState(() {
      user = fetchedUser;
      token = fetchedToken;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (user != null && token != null) {
      return widget.child;
    } else {
      return LoginScreen();
    }
  }
}
