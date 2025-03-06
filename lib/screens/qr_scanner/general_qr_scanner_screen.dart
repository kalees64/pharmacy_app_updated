import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pharmacy_app_updated/constants/colors.dart';
import 'package:pharmacy_app_updated/guard/auth.guard.dart';
import 'package:pharmacy_app_updated/screens/qr_scanner/general_qr_scan_result_screen.dart';
import 'package:pharmacy_app_updated/widgets/ui/headings.dart';

class GeneralQrScannerScreen extends StatefulWidget {
  const GeneralQrScannerScreen({super.key});

  @override
  State<GeneralQrScannerScreen> createState() => _GeneralQrScannerScreenState();
}

class _GeneralQrScannerScreenState extends State<GeneralQrScannerScreen>
    with SingleTickerProviderStateMixin {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    returnImage: true,
  );

  late AnimationController _animationController;
  late Animation<double> _animation;

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
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GeneralQrScanResultScreen(
              qrResult: barcodes.first.rawValue,
              qrResultImage: image,
            ),
          ),
        );

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
      body: AuthGuard(
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
                        margin: EdgeInsets.only(top: _animation.value * 250),
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
