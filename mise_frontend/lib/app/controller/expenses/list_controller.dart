import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:mise_frontend/app/models/expense_models.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HomeController extends GetxController {
  var allExpenses = <Expense>[].obs;
  var filteredExpenses = <Expense>[].obs;
  var isLoading = true.obs;
  var selectedFilter = "All".obs;

  // Shared Base URL from .env
  final String baseUrl = dotenv.env['BASE_URL'] ?? '';

  @override
  void onInit() {
    fetchExpenses();
    super.onInit();
  }

  // REFACTORED: Now used by VoiceController to refresh state
  Future<void> fetchExpenses() async {
    try {
      isLoading(true);
      final response = await Dio().get("$baseUrl/retrieve"); 
      if (response.statusCode == 200) {
        var list = (response.data as List).map((e) => Expense.fromJson(e)).toList();
        allExpenses.assignAll(list);
        applyFilter(selectedFilter.value); // Re-apply current filter after refresh
      }
    } catch (e) {
      print("Home Fetch Error: $e");
    } finally {
      isLoading(false);
    }
  }

  void applyFilter(String filter) {
    selectedFilter.value = filter;
    if (filter == "All") {
      filteredExpenses.assignAll(allExpenses);
    } else if (filter == "Cash") {
      filteredExpenses.assignAll(
        allExpenses.where((e) => 
          ["Cash Withdrawal", "Food", "Other"].contains(e.category)
        ).toList()
      );
    } else if (filter == "Online") {
      filteredExpenses.assignAll(
        allExpenses.where((e) => e.category == "Airtime/Data").toList()
      );
    }
  }
}