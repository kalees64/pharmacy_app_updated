import 'package:flutter/material.dart';
import 'package:pharmacy_app_updated/constants/colors.dart';
import 'package:pharmacy_app_updated/guard/auth.guard.dart';
import 'package:pharmacy_app_updated/widgets/ui/headings.dart';

class EditMedicineScreen extends StatefulWidget {
  const EditMedicineScreen({super.key});

  @override
  State<EditMedicineScreen> createState() => _EditMedicineScreenState();
}

class _EditMedicineScreenState extends State<EditMedicineScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: navBarTitle("Update Medicine"),
        backgroundColor: appBarColor,
      ),
      body: AuthGuard(
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
              children: [],
            ),
          ))
        ],
      )),
    );
  }
}
