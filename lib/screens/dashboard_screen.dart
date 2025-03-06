import 'package:flutter/material.dart';
import 'package:pharmacy_app_updated/constants/colors.dart';
import 'package:pharmacy_app_updated/constants/logger.dart';
import 'package:pharmacy_app_updated/constants/navigator.dart';
import 'package:pharmacy_app_updated/guard/auth.guard.dart';
import 'package:pharmacy_app_updated/screens/login_screen.dart';
import 'package:pharmacy_app_updated/screens/medicines/add_medicine_screen.dart';
import 'package:pharmacy_app_updated/screens/medicines/view_medicine_screen.dart';
import 'package:pharmacy_app_updated/screens/qr_scanner/qr_select_screen.dart';
import 'package:pharmacy_app_updated/services/medicine.service.dart';
import 'package:pharmacy_app_updated/widgets/ui/headings.dart';
import 'package:pharmacy_app_updated/widgets/ui/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final MedicineService medicineService = MedicineService();

  List<dynamic> _medicines = [];

  @override
  void initState() {
    fetchMedicines();
    super.initState();
  }

  void fetchMedicines() async {
    try {
      final res = await medicineService.getMedicines();
      logger.i("Fetched Medicines : $res");

      setState(() {
        _medicines = res;
      });
    } catch (e) {
      logger.e("Error while fetching medicines: $e");
    }
  }

  void logout() async {
    final SharedPreferences localStorage =
        await SharedPreferences.getInstance();
    localStorage.remove('user');
    localStorage.remove('token');
    localStorage.clear();
    navigateToHard(context, LoginScreen());
    ToastNotification.showToast(
        context: context, message: "Logged out successfully!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('assets/images/pharmacy_logo.png'),
        title: navBarTitle("Medicines"),
        actions: [
          Tooltip(
            message: "Add Medicine",
            child: IconButton(
              icon: Icon(Icons.local_pharmacy_outlined),
              onPressed: () {
                navigateTo(context, AddMedicineScreen());
              },
            ),
          ),
          Tooltip(
            message: "Scanner",
            child: IconButton(
              icon: Icon(Icons.qr_code_scanner_outlined),
              onPressed: () {
                navigateTo(context, QrSelectScreen());
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: logout,
          )
        ],
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
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    h2("Medicines (${_medicines.length.toString()})"),
                    if (_medicines.isEmpty)
                      Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      ),
                    if (_medicines.isNotEmpty)
                      Expanded(
                        child: ListView.builder(
                            itemCount: _medicines.length,
                            itemBuilder: (ctx, index) {
                              final medicine = _medicines[index];
                              return InkWell(
                                onTap: () {
                                  navigateTo(
                                    context,
                                    ViewMedicineScreen(medicine: medicine),
                                  );
                                },
                                child: Card(
                                  child: ListTile(
                                    title: Text(
                                      medicine['medicineName'] ?? 'N/A',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                        'Manufacturer: ${medicine['manufacturerName'] ?? 0}'),
                                  ),
                                ),
                              );
                            }),
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
