import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pharmacy_app_updated/constants/colors.dart';
import 'package:pharmacy_app_updated/constants/logger.dart';
import 'package:pharmacy_app_updated/constants/navigator.dart';
import 'package:pharmacy_app_updated/screens/dashboard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoleSelectionForm extends StatefulWidget {
  const RoleSelectionForm({super.key, required this.userRoles});

  final List<dynamic> userRoles;

  @override
  State<RoleSelectionForm> createState() => _RoleSelectionFormState();
}

class _RoleSelectionFormState extends State<RoleSelectionForm> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedRole;
  bool isLoading = false;

  void onSelectionSubmit() async {
    setState(() {
      isLoading = true;
    });
    if (!_formKey.currentState!.validate()) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    final selectedRoleDetails = widget.userRoles
        .firstWhere((role) => role['roleId'].toString() == _selectedRole);

    logger.d("Selected Role : $_selectedRole");
    logger.d("Selected Role Details : $selectedRoleDetails");

    final SharedPreferences localStorage =
        await SharedPreferences.getInstance();
    await localStorage.setString('user', json.encode(selectedRoleDetails));

    navigateToHard(context, DashboardScreen());

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedRole,
              decoration: const InputDecoration(
                labelText: 'Select a Role',
                border: OutlineInputBorder(),
              ),
              items: widget.userRoles.map<DropdownMenuItem<String>>((role) {
                return DropdownMenuItem<String>(
                  value: role['roleId'].toString(), // Ensure roleId is a string
                  child: Text(role['roleDescription'] ?? 'Unknown Role'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedRole = value;
                });
              },
              validator: (value) =>
                  value == null ? 'Please select a role' : null,
            ),
            const SizedBox(height: 20),
            if (isLoading)
              CircularProgressIndicator(
                color: primaryColor,
              ),
            if (!isLoading)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    onSelectionSubmit();
                  },
                  child: const Text('Submit'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
