import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;

class AddExpenseController extends GetxController {
  // 1. Observable variables for the UI
  var selectedCategory = "Food".obs;
  var selectedDateString = "Choose date".obs;
  var selectedDate = DateTime.now().obs;
  var isLoading = false.obs;
  var isShared = false.obs;

  // Static list for the category picker
  final List<Map<String, dynamic>> categories = [
    {"name": "Food", "icon": Icons.fastfood},
    {"name": "Airtime/Data", "icon": Icons.phone_android},
    {"name": "Cash Withdrawal", "icon": Icons.money},
    {"name": "Other", "icon": Icons.more_horiz},
  ];

  // 2. Methods for UI Interaction
  void setCategory(String category) => selectedCategory.value = category;

  Future<void> pickDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFB4F59E), // Mint green from design
              onPrimary: Colors.black,
              surface: Color(0xFF1A1A1A),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      selectedDate.value = picked;
      // Formatting for display: e.g., 10 Oct, 2023
      selectedDateString.value = "${picked.day} ${_getMonth(picked.month)}, ${picked.year}";
    }
  }

  // 3. API Integration: Calling @app.post("/expense")
  Future<void> saveExpense(String amountText) async {
    if (amountText.isEmpty) {
      Get.snackbar("Error", "Please enter an amount",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    try {
      final dioClient = dio.Dio();
      // Use 10.0.2.2 for Android Emulator or your local IP for physical devices
      const String url = "http://localhost:8000/expense";

      final response = await dioClient.post(url, data: {
        "amount": double.parse(amountText),
        "category": selectedCategory.value,
        "date": selectedDate.value.toIso8601String().split('T')[0], // Backend expects YYYY-MM-DD
        "is_shared": isShared.value,
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back(); // Close the page
        Get.snackbar("Success", "Expense added to database!",
            snackPosition: SnackPosition.BOTTOM, backgroundColor: const Color(0xFFB4F59E), colorText: Colors.black);
      }
    } catch (e) {
      Get.snackbar("Error", "Check backend connection: $e",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  String _getMonth(int month) {
    const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    return months[month - 1];
  }
}