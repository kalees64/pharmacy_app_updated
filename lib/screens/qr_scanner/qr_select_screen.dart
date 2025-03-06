import 'package:flutter/material.dart';
import 'package:pharmacy_app_updated/constants/colors.dart';
import 'package:pharmacy_app_updated/constants/navigator.dart';
import 'package:pharmacy_app_updated/guard/auth.guard.dart';
import 'package:pharmacy_app_updated/screens/qr_scanner/assay_qr_scanner_screen.dart';
import 'package:pharmacy_app_updated/screens/qr_scanner/general_qr_scanner_screen.dart';
import 'package:pharmacy_app_updated/widgets/ui/headings.dart';

class QrSelectScreen extends StatefulWidget {
  const QrSelectScreen({super.key});

  @override
  State<QrSelectScreen> createState() => _QrSelectScreenState();
}

class _QrSelectScreenState extends State<QrSelectScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: navBarTitle("Select Scanner"),
        backgroundColor: appBarColor,
      ),
      body: AuthGuard(
          child: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(19),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
              ),
              child: Column(
                children: [
                  Row(
                    spacing: 20,
                    children: [
                      InkWell(
                        onTap: () {
                          navigateTo(context, GeneralQrScannerScreen());
                        },
                        child: Column(
                          children: [
                            Icon(
                              Icons.qr_code,
                              size: 40,
                            ),
                            Text(
                              "General",
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          navigateTo(context, AssayQrScannerScreen());
                        },
                        child: Column(
                          children: [
                            Icon(
                              Icons.qr_code_scanner,
                              size: 40,
                            ),
                            Text(
                              "Assay",
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      )),
    );
  }
}
