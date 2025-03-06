import 'package:flutter/material.dart';
import 'package:pharmacy_app_updated/constants/colors.dart';
import 'package:pharmacy_app_updated/constants/logger.dart';
import 'package:pharmacy_app_updated/constants/navigator.dart';
import 'package:pharmacy_app_updated/screens/dashboard_screen.dart';
import 'package:pharmacy_app_updated/services/medicine.service.dart';
import 'package:pharmacy_app_updated/widgets/ui/headings.dart';
import 'package:pharmacy_app_updated/widgets/ui/toast.dart';
// import 'package:uuid/uuid.dart';

class UpdateMedicineForm extends StatefulWidget {
  const UpdateMedicineForm({super.key, required this.medicineAccessCode});

  final String medicineAccessCode;
  @override
  State<UpdateMedicineForm> createState() => _UpdateMedicineFormState();
}

class _UpdateMedicineFormState extends State<UpdateMedicineForm> {
  final _formKey = GlobalKey<FormState>();

  dynamic _medicine;

  dynamic _medicines = [];
  dynamic _dosageForms = [];
  dynamic _doses = [];
  dynamic _compositions = [];
  dynamic _taxes = [];

  bool isLoading = false;

  MedicineService medicineService = MedicineService();

  // Form Controllers
  final TextEditingController _medicineNameController = TextEditingController();
  final TextEditingController _manufacturerController = TextEditingController();
  final TextEditingController _batchNoController = TextEditingController();
  final TextEditingController _usageIndicationsController =
      TextEditingController();
  final TextEditingController _dosageFormController = TextEditingController();
  final TextEditingController _doseController = TextEditingController();

  final TextEditingController _activeIngredientController =
      TextEditingController();
  final TextEditingController _strengthController = TextEditingController();
  final TextEditingController _strengthScaleController =
      TextEditingController();

  final TextEditingController _supplierNameController = TextEditingController();
  final TextEditingController _invoiceNumberController =
      TextEditingController();
  final TextEditingController _purchaseDateController = TextEditingController();
  final TextEditingController _receivedQuantityController =
      TextEditingController();
  final TextEditingController _purchasePricePerUnitController =
      TextEditingController();
  final TextEditingController _totalPurChaseCostController =
      TextEditingController();

  final TextEditingController _stockLocationController =
      TextEditingController();
  final TextEditingController _currentStockQuantityController =
      TextEditingController();
  final TextEditingController _minimumStockLevelController =
      TextEditingController();
  final TextEditingController _maximumStockLevelController =
      TextEditingController();

  final TextEditingController _drugLicenceNumberController =
      TextEditingController();
  final TextEditingController _scheduleCategoryController =
      TextEditingController();

  final TextEditingController _manufactureDateController =
      TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _storageConditionsController =
      TextEditingController();

  final TextEditingController _sellingPricePerUnitController =
      TextEditingController();
  final TextEditingController _discountController = TextEditingController();

  final TextEditingController _taxTypeController = TextEditingController();
  final TextEditingController _taxRateController = TextEditingController();

  @override
  void initState() {
    fetchMedicine();
    fetchMedicines();
    fetchDosageForms();
    fetchDoses();
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

  void fetchMedicine() async {
    try {
      final res = await medicineService
          .getMedicineAccessCode(widget.medicineAccessCode);
      logger.i("Fetched Medicine : $res");

      setState(() {
        _medicine = res[0];
      });
      patchFormValues(res[0]);
    } catch (e) {
      logger.e("Error while fetching medicine: $e");
    }
  }

  void fetchDosageForms() async {
    try {
      final res = await medicineService.getDosageForms();
      logger.i("Fetched Dosage Forms : $res");

      setState(() {
        _dosageForms = res;
      });
    } catch (e) {
      logger.e("Error while fetching dosage forms: $e");
    }
  }

  void fetchDoses() async {
    try {
      final res = await medicineService.getDoses();
      logger.i("Fetched Doses : $res");

      setState(() {
        _doses = res;
      });
    } catch (e) {
      logger.e("Error while fetching doses: $e");
    }
  }

  void patchFormValues(dynamic data) {
    setState(() {
      _medicineNameController.text = data['medicineName'] ?? '';
      _manufacturerController.text = data['manufacturerName'] ?? '';
      _batchNoController.text = data['batchNumber'] ?? '';
      _usageIndicationsController.text = data['usageIndications'] ?? '';
      _dosageFormController.text = data['dosageForm'] ?? '';
      _doseController.text = data['unitOfMeasurement'] ?? '';

      _supplierNameController.text = data['supplierName'] ?? '';
      _invoiceNumberController.text = data['invoiceNumber'] ?? '';
      _purchaseDateController.text = data['purchaseDate'] ?? '';
      _receivedQuantityController.text = data['receivedQuantity'] ?? '';
      _purchasePricePerUnitController.text = data['purchasePricePerUnit'] ?? '';
      _totalPurChaseCostController.text = data['totalPurchaseCost'] ?? '';
      _stockLocationController.text = data['stockLocation'] ?? '';
      _currentStockQuantityController.text = data['currentStockQuantity'] ?? '';
      _minimumStockLevelController.text = data['minimumStockLevel'] ?? '';
      _maximumStockLevelController.text = data['maximumStockLevel'] ?? '';
      _drugLicenceNumberController.text = data['drugLicenseNumber'] ?? '';
      _scheduleCategoryController.text = data['scheduleCategory'] ?? '';
      _manufactureDateController.text = data['manufacturedDate'] ?? '';
      _expiryDateController.text = data['expiryDate'] ?? '';
      _storageConditionsController.text = data['storageConditions'] ?? '';
      _sellingPricePerUnitController.text = data['sellingPricePerUnit'] ?? '';
      _discountController.text = data['discount'] ?? '';

      _compositions = data['compositions'] ?? [];
      _taxes = data['taxDetails'] ?? [];
    });
  }

  void autoFetchManufacturerName(String medicineName) {
    if (medicineName.isEmpty) return;
    setState(() {
      final selectedMedicine =
          _medicines.firstWhere((item) => item['medicineName'] == medicineName);
      logger.d("--Selected Medicine : $selectedMedicine");
      _manufacturerController.text = selectedMedicine['manufacturerName'];
    });
  }

  void _addComposition() {
    final activeIngredient = _activeIngredientController.text.trim();
    final strength = _strengthController.text.trim();
    final strengthScale = _strengthScaleController.text.trim();

    if (activeIngredient.isEmpty || strength.isEmpty) {
      ToastNotification.showToast(
          context: context,
          message: 'Please fill out both Active Ingredient and Strength.');
      return;
    }

    final parsedStrength = num.tryParse(strength);
    if (parsedStrength == null) {
      ToastNotification.showToast(
          context: context, message: 'Strength must be a valid number.');
      return;
    }

    setState(() {
      _compositions.add({
        "activeIngredient": activeIngredient,
        "strength": parsedStrength,
        "strengthScale": strengthScale
      });

      _activeIngredientController.clear();
      _strengthController.clear();
      _strengthScaleController.clear();
    });
  }

  void _calculateTotalCost() {
    final receivedQuantity =
        int.tryParse(_receivedQuantityController.text) ?? 0;
    final purchasePrice =
        double.tryParse(_purchasePricePerUnitController.text) ?? 0.0;
    final totalCost = receivedQuantity * purchasePrice;
    setState(() {
      _totalPurChaseCostController.text = totalCost.toString();
    });
  }

  void _addTax() {
    final taxType = _taxTypeController.text.trim();
    final taxRate = _taxRateController.text.trim();

    if (taxType.isEmpty || taxRate.isEmpty) {
      ToastNotification.showToast(
          context: context,
          message: "Please fill out both Tax Type and Tax Rate.");
      return;
    }

    final parsedTaxRate = num.tryParse(taxRate);
    if (parsedTaxRate == null) {
      ToastNotification.showToast(
          context: context, message: "Tax Rate must be a valid number.");
      return;
    }

    setState(() {
      _taxes.add({"taxType": taxType, "taxRate": parsedTaxRate});
      _taxTypeController.clear();
      _taxRateController.clear();
    });
  }

  Map<String, dynamic> payload() {
    return {
      "medicineName": _medicineNameController.text,
      "manufacturerName": _manufacturerController.text,
      "batchNumber": _batchNoController.text,
      "usageIndications": _usageIndicationsController.text,
      "dosageForm": _dosageFormController.text,
      "unitOfMeasurement": _doseController.text,
      "supplierName": _supplierNameController.text,
      "invoiceNumber": _invoiceNumberController.text,
      "purchaseDate": _purchaseDateController.text.isNotEmpty
          ? _purchaseDateController.text
          : null,
      "receivedQuantity": int.tryParse(_receivedQuantityController.text),
      "purchasePricePerUnit":
          int.tryParse(_purchasePricePerUnitController.text),
      "totalPurchaseCost": int.tryParse(_totalPurChaseCostController.text),
      "stockLocation": _stockLocationController.text,
      "currentStockQuantity":
          int.tryParse(_currentStockQuantityController.text),
      "minimumStockLevel": int.tryParse(_minimumStockLevelController.text),
      "maximumStockLevel": int.tryParse(_maximumStockLevelController.text),
      "drugLicenseNumber": _drugLicenceNumberController.text,
      "scheduleCategory": _scheduleCategoryController.text,
      "manufacturedDate": _manufactureDateController.text.isNotEmpty
          ? _manufactureDateController.text
          : null,
      "expiryDate": _expiryDateController.text.isNotEmpty
          ? _expiryDateController.text
          : null,
      "storageConditions": _storageConditionsController.text,
      "sellingPricePerUnit": int.tryParse(_sellingPricePerUnitController.text),
      "discount": int.tryParse(_discountController.text),
      "taxDetails": _taxes.isEmpty ? null : _taxes,
    };
  }

  void _submitForm() async {
    setState(() {
      isLoading = true;
    });

    final medicinePayload = payload();
    logger.d("--Medicine Payload data : $medicinePayload");

    if (medicinePayload.values
        .every((value) => value == null || value.toString().trim().isEmpty)) {
      logger.w("All fields are empty or null. Exiting the function.");
      ToastNotification.showToast(
          context: context,
          color: Colors.white,
          duration: Duration(seconds: 4),
          message:
              "You not filled any of the field , so we can not proceed to add new medicine.");
      setState(() {
        isLoading = false;
      });
      return;
    }
    // final uuid = Uuid();
    // final newAccessCode = "assaycr-${uuid.v4()}";

    // final newQrCode =
    //     await medicineService.generateQrCodeDataUrl(newAccessCode);

    final Map<String, dynamic> updateMedicine = {
      ...medicinePayload,
      "originalQrCodeData": _medicine["originalQrCodeData"],
      "reLabeledQrCode": _medicine["reLabeledQrCode"],
      "currentQrAccessCode": widget.medicineAccessCode
    };

    logger.i("--updated medicine : $updateMedicine");

    try {
      final res =
          await medicineService.updateMedicine(updateMedicine, _medicine["id"]);
      logger.i("Update medicine Response : $res");
      setState(() {
        isLoading = false;
      });
      ToastNotification.showToast(
          context: context, message: "Medicine Updated Successfully");
      navigateTo(context, DashboardScreen());
    } catch (e) {
      logger.e("--Error while add new medicine : $e");
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _medicineNameController.dispose();
    _manufacturerController.dispose();
    _batchNoController.dispose();
    _usageIndicationsController.dispose();
    _dosageFormController.dispose();
    _doseController.dispose();
    _activeIngredientController.dispose();
    _strengthController.dispose();
    _strengthScaleController.dispose();
    _supplierNameController.dispose();
    _invoiceNumberController.dispose();
    _purchaseDateController.dispose();
    _receivedQuantityController.dispose();
    _purchasePricePerUnitController.dispose();
    _totalPurChaseCostController.dispose();
    _stockLocationController.dispose();
    _currentStockQuantityController.dispose();
    _minimumStockLevelController.dispose();
    _maximumStockLevelController.dispose();
    _drugLicenceNumberController.dispose();
    _scheduleCategoryController.dispose();
    _manufactureDateController.dispose();
    _expiryDateController.dispose();
    _storageConditionsController.dispose();
    _sellingPricePerUnitController.dispose();
    _discountController.dispose();
    _taxTypeController.dispose();
    _taxRateController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _medicines.isEmpty || _dosageForms.isEmpty || _doses.isEmpty
        ? Center(
            child: CircularProgressIndicator(
              color: primaryColor,
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    spacing: 10,
                    children: [
                      Column(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          h2("1. Basic Details"),
                          // Autocomplete<String>(
                          //   optionsBuilder:
                          //       (TextEditingValue textEditingValue) async {
                          //     if (textEditingValue.text.isEmpty) {
                          //       return const Iterable<String>.empty();
                          //     }

                          //     final filteredMedicines = _medicines.where(
                          //         (medicine) {
                          //       final medicineName =
                          //           medicine['medicineName']?.toString() ?? '';
                          //       return medicineName.toLowerCase().contains(
                          //           textEditingValue.text.toLowerCase());
                          //     }).map<String>((medicine) =>
                          //         medicine['medicineName']?.toString() ?? '');

                          //     return filteredMedicines; // Ensuring it's Iterable<String>
                          //   },
                          //   onSelected: (String selectedMedicine) {
                          //     autoFetchManufacturerName(selectedMedicine);
                          //     _medicineNameController.text = selectedMedicine;
                          //   },
                          //   fieldViewBuilder: (BuildContext context,
                          //       TextEditingController textEditingController,
                          //       FocusNode focusNode,
                          //       VoidCallback onFieldSubmitted) {
                          //     return TextField(
                          //       controller: textEditingController,
                          //       focusNode: focusNode,
                          //       onChanged: (value) {
                          //         if (value.isNotEmpty) {
                          //           _medicineNameController.text = value;
                          //         }
                          //       },
                          //       decoration: const InputDecoration(
                          //         labelText: 'Medicine name',
                          //         border: OutlineInputBorder(),
                          //       ),
                          //     );
                          //   },
                          // ),
                          _buildTextField(
                            'Medicine Name',
                            'medicineName',
                            false,
                            keyBoardType: TextInputType.text,
                            controller: _medicineNameController,
                          ),
                          _buildTextField(
                            'Manufacturer',
                            'manufacturer',
                            false,
                            keyBoardType: TextInputType.text,
                            controller: _manufacturerController,
                          ),
                          _buildTextField('Batch No', 'batchNo', false,
                              keyBoardType: TextInputType.text,
                              controller: _batchNoController),
                          _buildTextField(
                              'Usage Indications', 'usageIndications', false,
                              keyBoardType: TextInputType.text,
                              controller: _usageIndicationsController),
                          _buildDropdown('Dosage Form', _dosageForms, false,
                              controller: _dosageFormController),
                          _buildDropdown('Dose', _doses, false,
                              controller: _doseController),
                        ],
                      ),
                      Column(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          h2("2. Compositions"),
                          _buildTextField(
                              'Active Ingredient', 'activeIngredient', false,
                              keyBoardType: TextInputType.text,
                              controller: _activeIngredientController),
                          _buildTextField('Strength', 'strength', false,
                              keyBoardType: TextInputType.number,
                              controller: _strengthController),
                          _buildDropdown('Strength Scale', _doses, false,
                              controller: _strengthScaleController),
                          ElevatedButton(
                            onPressed: _addComposition,
                            child: const Text('Add Composition'),
                          ),
                          _buildCompositionTable(),
                        ],
                      ),
                      Column(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          h2("3. Supply And Purchase Details"),
                          _buildTextField(
                              'Supplier Name', 'supplierName', false,
                              keyBoardType: TextInputType.text,
                              controller: _supplierNameController),
                          _buildTextField('Invoice No', 'invoiceNo', false,
                              keyBoardType: TextInputType.text,
                              controller: _invoiceNumberController),
                          _buildDatePicker('Purchase Date', false,
                              controller: _purchaseDateController),
                          _buildTextField(
                              'Received Quantity', 'receivedQuantity', false,
                              onChanged: (value) => _calculateTotalCost(),
                              keyBoardType: TextInputType.number,
                              controller: _receivedQuantityController),
                          _buildTextField('Purchase Price per Unit',
                              'purchasePricePerUnit', false,
                              onChanged: (value) => _calculateTotalCost(),
                              keyBoardType: TextInputType.number,
                              controller: _purchasePricePerUnitController),
                          _buildTextField(
                              'Total Purchase Cost', 'totalPurchaseCost', false,
                              enabled: false,
                              controller: _totalPurChaseCostController,
                              keyBoardType: TextInputType.number),
                        ],
                      ),
                      Column(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          h2("4. Stock And Invertory Details"),
                          _buildTextField(
                              'Stock Location', 'stockLocation', false,
                              keyBoardType: TextInputType.text,
                              controller: _stockLocationController),
                          _buildTextField('Current Stock Quantity',
                              'currentStockQuantity', false,
                              keyBoardType: TextInputType.number,
                              controller: _currentStockQuantityController),
                          _buildTextField(
                              'Min Stock Level', 'minStockLevel', false,
                              keyBoardType: TextInputType.number,
                              controller: _minimumStockLevelController),
                          _buildTextField(
                              'Max Stock Level', 'maxStockLevel', false,
                              keyBoardType: TextInputType.number,
                              controller: _maximumStockLevelController),
                        ],
                      ),
                      Column(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          h2("5. Regulatory Information"),
                          _buildTextField(
                              'Drug Licence Number', 'drugLicenceNumber', false,
                              keyBoardType: TextInputType.text,
                              controller: _drugLicenceNumberController),
                          _buildTextField(
                              'Schedule Category', 'scheduleCategory', false,
                              keyBoardType: TextInputType.text,
                              controller: _scheduleCategoryController),
                        ],
                      ),
                      Column(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          h2("6. Expiry And Storage Information"),
                          _buildDatePicker('Manufacture Date', false,
                              controller: _manufactureDateController),
                          _buildDatePicker('Expiry Date', false,
                              controller: _expiryDateController),
                          _buildTextField(
                              'Storage Conditions', 'storageConditions', false,
                              keyBoardType: TextInputType.text,
                              controller: _storageConditionsController),
                        ],
                      ),
                      Column(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          h2("7. Sales And Pricing Details"),
                          _buildTextField('Selling Price Per Unit',
                              'sellingPricePerUnit', false,
                              keyBoardType: TextInputType.number,
                              controller: _sellingPricePerUnitController),
                          _buildTextField('Discount (%)', 'discount', false,
                              keyBoardType: TextInputType.number,
                              controller: _discountController),
                        ],
                      ),
                      Column(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          h2("8. Tax Details"),
                          _buildTextField('Tax Type', 'taxType', false,
                              keyBoardType: TextInputType.text,
                              controller: _taxTypeController),
                          _buildTextField('Tax Rate', 'taxRate', false,
                              keyBoardType: TextInputType.number,
                              controller: _taxRateController),
                          ElevatedButton(
                            onPressed: _addTax,
                            child: const Text('Add Tax'),
                          ),
                          _buildTaxTable(),
                        ],
                      ),
                      const SizedBox(height: 20),
                      if (!isLoading)
                        ElevatedButton(
                          onPressed: () {
                            _submitForm();
                          },
                          child: const Text('Submit'),
                        ),
                      if (isLoading) CircularProgressIndicator(),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                )),
          );
  }

  Widget _buildTextField(
    String label,
    String key,
    bool required, {
    required TextInputType keyBoardType,
    TextEditingController? controller,
    bool enabled = true,
    Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyBoardType,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      enabled: enabled,
      onChanged: onChanged,
      // validator: (value) => (required && (value == null || value.isEmpty))
      //     ? 'This field is required'
      //     : null,
      // onSaved: (value) => _formData[key] = value ?? '',
    );
  }

  Widget _buildDropdown(String label, List<dynamic> items, bool required,
      {required TextEditingController controller}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        value: items.any((item) => item["name"] == controller.text)
            ? controller.text
            : null, // Ensure the selected value matches the controller
        items: [
          const DropdownMenuItem<String>(
            value: '', // Placeholder for "select"
            child: Text("--select--"),
          ),
          ...items.map((item) {
            final itemName = item["name"] as String? ?? '';
            return DropdownMenuItem<String>(
              value: itemName,
              child: Text(itemName),
            );
          }),
        ],
        onChanged: (value) => controller.text = value ?? '',
      ),
    );
  }

  Widget _buildDatePicker(String label, bool required,
      {required TextEditingController controller}) {
    return TextFormField(
      readOnly: true,
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            if (picked != null) {
              setState(() {
                controller.text = picked.toIso8601String().split('T')[0];
              });
            }
          },
        ),
      ),
      validator: (value) => (required && (value == null || value.isEmpty))
          ? 'Please select a $label'
          : null,
    );
  }

  Widget _buildCompositionTable() {
    if (_compositions.isEmpty) {
      return const Center(
        child: Text('No data available'),
      );
    }

    return Column(
      children: [
        // Table headers
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('S.No', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Ingredient', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Strength', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Action', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        const Divider(),
        // Table rows
        ..._compositions.asMap().entries.map((entry) {
          final index = entry.key + 1;
          final composition = entry.value;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(index.toString()),
                Text(composition['activeIngredient']),
                Text(
                    '${composition['strength'].toString()} ${composition['strengthScale']}'),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      _compositions.removeAt(entry.key);
                    });
                  },
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildTaxTable() {
    if (_taxes.isEmpty) {
      return const Center(
        child: Text('No data available'),
      );
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('S.No', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Tax Type', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Tax Rate', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Action', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        const Divider(),
        ..._taxes.asMap().entries.map((entry) {
          final index = entry.key + 1;
          final tax = entry.value;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(index.toString()),
                Text(tax['taxType']),
                Text('${tax['taxRate'].toString()}%'),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      _taxes.removeAt(entry.key);
                    });
                  },
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}
