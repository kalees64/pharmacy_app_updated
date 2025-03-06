import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app_updated/constants/colors.dart';

class ToastNotification {
  static void showToast({
    required BuildContext context,
    required String message,
    IconData icon = Icons.notifications,
    Color color = toastColor,
    Duration duration = const Duration(seconds: 2),
  }) {
    DelightToastBar(
      builder: (context) => ToastCard(
        leading: Icon(icon),
        title: Text(message),
        color: color,
      ),
      autoDismiss: true,
      snackbarDuration: duration,
    ).show(context);
  }
}

// Usage example
// ToastNotification.showToast(
//   context: context,
//   message: "Login Success",
//   icon: Icons.check_circle,
//   color: Colors.green,
//   duration: Duration(seconds: 3),
// );
