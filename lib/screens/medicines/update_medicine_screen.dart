import 'package:flutter/material.dart';
import 'package:pharmacy_app_updated/constants/colors.dart';
import 'package:pharmacy_app_updated/guard/auth.guard.dart';
import 'package:pharmacy_app_updated/widgets/forms/update_medicine_form.dart';
import 'package:pharmacy_app_updated/widgets/ui/headings.dart';

class UpdateMedicineScreen extends StatefulWidget {
  const UpdateMedicineScreen({super.key, required this.medicineAccessCode});

  final String medicineAccessCode;

  @override
  State<UpdateMedicineScreen> createState() => _UpdateMedicineScreenState();
}

class _UpdateMedicineScreenState extends State<UpdateMedicineScreen> {
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
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Text(widget.medicineAccessCode),
                    UpdateMedicineForm(
                        medicineAccessCode: widget.medicineAccessCode)
                  ],
                ),
              ),
            ),
          )
        ],
      )),
    );
  }
}
