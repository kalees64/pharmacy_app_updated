import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pharmacy_app_updated/constants/colors.dart';
import 'package:pharmacy_app_updated/constants/logger.dart';
import 'package:pharmacy_app_updated/screens/role_selection_screen.dart';
import 'package:pharmacy_app_updated/services/auth.service.dart';
import 'package:pharmacy_app_updated/widgets/ui/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLoading = false;

  AuthService authService = AuthService();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    setState(() {
      isLoading = true;
    });

    if (!_formKey.currentState!.validate()) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    Map<String, dynamic> loginData = {
      'username': _usernameController.text,
      'password': _passwordController.text
    };

    logger.i("--User Login Credentials : $loginData");

    try {
      final dynamic res = await authService.login(loginData);
      logger.i("--User Login Response : $res");
      // logger.w("--User Token : ${res["token"]}");

      if (res == null) {
        ToastNotification.showToast(
            context: context, message: "Invalid Credentials");
      }

      if (res != null) {
        final SharedPreferences localStorage =
            await SharedPreferences.getInstance();
        localStorage.setString('user', json.encode(res));
        localStorage.setString('token', json.encode(res["token"]));

        ToastNotification.showToast(context: context, message: "Login Success");

        Navigator.push(context,
            MaterialPageRoute(builder: (context) => RoleSelectionScreen()));
      }
    } catch (e) {
      logger.e("--Error Occured During User Login : $e");
    }

    setState(() {
      isLoading = false;
      // _formKey.currentState!.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          spacing: 15,
          children: [
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: inputBoxColor),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: inputBoxColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: inputBoxColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: inputBoxColor, width: 2.0),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                final emailRegex =
                    RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                if (!emailRegex.hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            TextFormField(
              keyboardType: TextInputType.text,
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: inputBoxColor),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: inputBoxColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: inputBoxColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: inputBoxColor, width: 2.0),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),
            if (isLoading)
              CircularProgressIndicator(
                color: primaryColor,
              ),
            if (!isLoading)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Login'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
