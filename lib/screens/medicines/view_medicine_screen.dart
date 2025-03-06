import 'package:flutter/material.dart';
import 'package:pharmacy_app_updated/constants/colors.dart';
import 'package:pharmacy_app_updated/constants/logger.dart';
import 'package:pharmacy_app_updated/widgets/ui/headings.dart';

class ViewMedicineScreen extends StatefulWidget {
  const ViewMedicineScreen({super.key, required this.medicine});

  final dynamic medicine;

  @override
  State<ViewMedicineScreen> createState() => _ViewMedicineScreenState();
}

class _ViewMedicineScreenState extends State<ViewMedicineScreen> {
  dynamic _medicine;

  @override
  void initState() {
    super.initState();
    _medicine = widget.medicine;
    logger.d("--medicine data from nav: ${widget.medicine}");
    logger.d("--medicine data: $_medicine");
  }

  @override
  Widget build(BuildContext context) {
    if (_medicine == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: navBarTitle(_medicine["medicineName"] ?? "N/A"),
        backgroundColor: appBarColor,
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_medicine["medicineName"] != null)
                  _buildListTile("Brand Name", _medicine["medicineName"]),
                if (_medicine["manufacturerName"] != null)
                  _buildListTile(
                      "Manufacturer Name", _medicine["manufacturerName"]),
                if (_medicine["batchNumber"] != null)
                  _buildListTile("Batch No", _medicine["batchNumber"]),
                if (_medicine["dosageForm"] != null)
                  _buildListTile("Dosage Form", _medicine["dosageForm"]),
                if (_medicine["unitOfMeasurement"] != null)
                  _buildListTile("Dose", _medicine["unitOfMeasurement"]),
                if (_medicine["usageIndications"] != null)
                  _buildListTile(
                      "Usage Indications", _medicine["usageIndications"]),
                if (_medicine['compositions'] != null &&
                    _medicine['compositions'].isNotEmpty)
                  _buildCompositionTile(_medicine['compositions']),
                if (_medicine["supplierName"] != null)
                  _buildListTile("Supplier Name", _medicine["supplierName"]),
                if (_medicine["invoiceNumber"] != null)
                  _buildListTile("Invoice No", _medicine["invoiceNumber"]),
                if (_medicine["purchaseDate"] != null)
                  _buildListTile("Purchase Date", _medicine["purchaseDate"]),
                if (_medicine["receivedQuantity"] != null)
                  _buildListTile("Received Quantity",
                      _medicine["receivedQuantity"].toString()),
                if (_medicine["purchasePricePerUnit"] != null)
                  _buildListTile("Purchase Price Per Unit",
                      _medicine["purchasePricePerUnit"].toString()),
                if (_medicine["totalPurchaseCost"] != null)
                  _buildListTile("Total Purchase Cost",
                      _medicine["totalPurchaseCost"].toString()),
                if (_medicine["stockLocation"] != null)
                  _buildListTile("Stock Location", _medicine["stockLocation"]),
                if (_medicine["currentStackQuantity"] != null)
                  _buildListTile("Current Stack Quantity",
                      _medicine["currentStackQuantity"].toString()),
                if (_medicine["minimumStockLevel"] != null)
                  _buildListTile("Minimum Stock Level",
                      _medicine["minimumStockLevel"].toString()),
                if (_medicine["maximumStockLevel"] != null)
                  _buildListTile("Maximum Stock Level",
                      _medicine["maximumStockLevel"].toString()),
                if (_medicine["drugLicenseNumber"] != null)
                  _buildListTile(
                      "Drug Licence Number", _medicine["drugLicenseNumber"]),
                if (_medicine["scheduleCategory"] != null)
                  _buildListTile(
                      "Schedule Category", _medicine["scheduleCategory"]),
                if (_medicine["manufacturedDate"] != null)
                  _buildListTile(
                      "Manufacture Date", _medicine["manufacturedDate"]),
                if (_medicine["expiryDate"] != null)
                  _buildListTile("Expiry Date", _medicine["expiryDate"]),
                if (_medicine["storageConditions"] != null)
                  _buildListTile(
                      "Storage Conditions", _medicine["storageConditions"]),
                if (_medicine["sellingPricePerUnit"] != null)
                  _buildListTile("Selling Price Per Unit",
                      _medicine["sellingPricePerUnit"].toString()),
                if (_medicine["discount"] != null)
                  _buildListTile("Discount", "${_medicine["discount"]} %"),
                if (_medicine['taxDetails'] != null &&
                    _medicine['taxDetails'].isNotEmpty)
                  _buildTaxTile(_medicine['taxDetails']),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListTile(String title, String value) {
    return ListTile(
      title: Text(title),
      subtitle: Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildCompositionTile(List<dynamic> compositions) {
    return ListTile(
      title: const Text("Compositions"),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: compositions.map((item) {
          final index = compositions.indexOf(item) + 1;
          final ingredient = item["activeIngredient"] ?? "N/A";
          final strength = item["strength"]?.toString() ?? "N/A";
          final scale = item["strengthScale"] ?? "N/A";
          return Text(
            "$index. $ingredient $strength $scale",
            style: const TextStyle(fontWeight: FontWeight.bold),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTaxTile(List<dynamic> taxDetails) {
    return ListTile(
      title: const Text("Taxes"),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: taxDetails.map((item) {
          final index = taxDetails.indexOf(item) + 1;
          final taxType = item["taxType"] ?? "N/A";
          final taxRate = item["taxRate"]?.toString() ?? "N/A";
          return Text(
            "$index. $taxType $taxRate %",
            style: const TextStyle(fontWeight: FontWeight.bold),
          );
        }).toList(),
      ),
    );
  }
}
