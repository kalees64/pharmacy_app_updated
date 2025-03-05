import 'package:flutter/material.dart';
import 'package:pharmacy_app_updated/constants/colors.dart';
import 'package:pharmacy_app_updated/widgets/ui/headings.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
