import 'package:flutter/material.dart';
import 'package:pharmacy_app_updated/constants/colors.dart';
import 'package:pharmacy_app_updated/guard/auth.guard.dart';
import 'package:pharmacy_app_updated/widgets/forms/add_medicine_form.dart';
import 'package:pharmacy_app_updated/widgets/ui/headings.dart';

class AddMedicineScreen extends StatefulWidget {
  const AddMedicineScreen({super.key, this.originalQrCodeData});

  final String? originalQrCodeData;

  @override
  State<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: navBarTitle("Add Medicine"),
        backgroundColor: appBarColor,
      ),
      body: AuthGuard(
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                // padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: gradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                ),
                child: Column(
                  spacing: 10,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          color: const Color.fromARGB(55, 255, 255, 255),
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  if (widget.originalQrCodeData != null)
                                    Card(
                                      child: ListTile(
                                        title: Text("Scanned QR code Data : "),
                                        subtitle: Text(
                                          widget.originalQrCodeData!,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  AddMedicineForm(
                                    originalQrCodeData:
                                        widget.originalQrCodeData,
                                  ),
                                ],
                              )),
                        ),
                      ),
                    ),
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
