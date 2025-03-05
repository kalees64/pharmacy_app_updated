import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pharmacy_app_updated/constants/colors.dart';
import 'package:pharmacy_app_updated/constants/logger.dart';
import 'package:pharmacy_app_updated/guard/auth.guard.dart';
import 'package:pharmacy_app_updated/services/auth.service.dart';
import 'package:pharmacy_app_updated/services/medicine.service.dart';
import 'package:pharmacy_app_updated/widgets/forms/role_selection_form.dart';
import 'package:pharmacy_app_updated/widgets/ui/headings.dart';
import 'package:pharmacy_app_updated/widgets/ui/toast.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  List<dynamic> _userRoles = [];

  AuthService authService = AuthService();
  MedicineService medicineService = MedicineService();

  @override
  void initState() {
    fetchUserRoles();
    super.initState();
  }

  void fetchUserRoles() async {
    try {
      final user = await authService.getUserDataFromLocalStorage();
      final userData = json.decode(user);
      logger.i("--User Data : $userData");

      final res = await authService
          .getUserRolesByUserId({"username": userData["email"]});
      logger.i("--User Roles Response: $res");

      if (res == null) {
        logger.i("--User Roles Response is null");
        ToastNotification.showToast(
            context: context, message: "No roles found login again");
      }

      setState(() {
        _userRoles = res;
      });
    } catch (e) {
      logger.e("--Error fetching user data and User roles : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthGuard(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: gradientColors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight),
                  ),
                  child: Column(
                    spacing: 10,
                    children: [
                      Image.asset(
                        'assets/images/pharmacy_logo.png',
                        width: 250,
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      h1("Select Role"),
                      RoleSelectionForm(userRoles: _userRoles)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
