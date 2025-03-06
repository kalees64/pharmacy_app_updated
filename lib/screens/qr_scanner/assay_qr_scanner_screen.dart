import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pharmacy_app_updated/constants/colors.dart';
import 'package:pharmacy_app_updated/constants/logger.dart';
import 'package:pharmacy_app_updated/guard/auth.guard.dart';
import 'package:pharmacy_app_updated/screens/medicines/add_medicine_screen.dart';
import 'package:pharmacy_app_updated/screens/medicines/update_medicine_screen.dart';
import 'package:pharmacy_app_updated/services/medicine.service.dart';
import 'package:pharmacy_app_updated/widgets/ui/headings.dart';

class AssayQrScannerScreen extends StatefulWidget {
  const AssayQrScannerScreen({super.key});

  @override
  State<AssayQrScannerScreen> createState() => _AssayQrScannerScreenState();
}

class _AssayQrScannerScreenState extends State<AssayQrScannerScreen>
    with SingleTickerProviderStateMixin {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    returnImage: true,
  );

  late AnimationController _animationController;
  late Animation<double> _animation;

  MedicineService medicineService = MedicineService();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
  }

  void _onDetect(capture) async {
    final List<Barcode> barcodes = capture.barcodes;
    final Uint8List? image = capture.image;

    if (barcodes.isNotEmpty && image != null) {
      // Stop scanning immediately
      await _controller.stop();

      if (mounted) {
        if (barcodes.first.rawValue!.startsWith("assaycr")) {
          setState(() {
            isLoading = true;
          });

          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UpdateMedicineScreen(
                medicineAccessCode: barcodes.first.rawValue!,
              ),
            ),
          );

          // Restart the scanner only if you return to this screen
          if (result == null && mounted) {
            _controller.start();
          }
          setState(() {
            isLoading = false;
          });
          return;
        }

        try {
          setState(() {
            isLoading = true;
          });
          final res = await medicineService
              .getMedicineByOriginalQrCodedata(barcodes.first.rawValue!);
          logger.i("--Getting medicine by original qr code Response : $res");

          if (res.isNotEmpty) {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UpdateMedicineScreen(
                  medicineAccessCode: res[0]["currentQrAccessCode"],
                ),
              ),
            );

            // Restart the scanner only if you return to this screen
            if (result == null && mounted) {
              _controller.start();
            }
            setState(() {
              isLoading = false;
            });
            return;
          }
        } catch (e) {
          setState(() {
            isLoading = false;
          });
          logger.e(
              "--Error while getting medicine data using original qr code data : $e");
        }

        setState(() {
          isLoading = true;
        });

        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddMedicineScreen(
              originalQrCodeData: barcodes.first.rawValue,
            ),
          ),
        );
        setState(() {
          isLoading = false;
        });
        // Restart the scanner only if you return to this screen
        if (result == null && mounted) {
          _controller.start();
        }
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: navBarTitle("Scanner"),
        backgroundColor: appBarColor,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : AuthGuard(
              child: Column(
              children: [
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      MobileScanner(
                        controller: _controller,
                        onDetect: _onDetect,
                      ),
                      Positioned(
                        child: Container(
                          width: 250,
                          height: 250,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        child: AnimatedBuilder(
                          animation: _animation,
                          builder: (context, child) {
                            return Container(
                              width: 250,
                              height: 4,
                              margin:
                                  EdgeInsets.only(top: _animation.value * 250),
                              color: primaryColor,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )),
    );
  }
}
