import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:mise_frontend/app/models/expense_models.dart';

class HomeController extends GetxController {
  var allExpenses = <Expense>[].obs;
  var filteredExpenses = <Expense>[].obs;
  var isLoading = true.obs;
  var selectedFilter = "All".obs;

  @override
  void onInit() {
    fetchExpenses();
    super.onInit();
  }

  Future<void> fetchExpenses() async {
    try {
      isLoading(true);
      // In your main.py, you can add a GET /expenses endpoint if not already there
      final response = await Dio().get("http://localhost:8000/retrieve"); 
      if (response.statusCode == 200) {
        var list = (response.data as List).map((e) => Expense.fromJson(e)).toList();
        allExpenses.assignAll(list);
        applyFilter("All");
      }
    } finally {
      isLoading(false);
    }
  }

  void applyFilter(String filter) {
    selectedFilter.value = filter;
    
    if (filter == "All") {
      filteredExpenses.assignAll(allExpenses);
    } 
    else if (filter == "Cash") {
      // Filter for transactions manually entered (e.g., Food, Cash Withdrawal, etc.)
      // and exclude those that would be considered "Online"
      filteredExpenses.assignAll(
        allExpenses.where((e) => 
          e.category == "Cash Withdrawal" || 
          e.category == "Food" || 
          e.category == "Other"
        ).toList()
      );
    } 
    else if (filter == "Online") {
      // Assuming 'Online' transactions have a specific category or flag
      filteredExpenses.assignAll(
        allExpenses.where((e) => e.category == "Airtime/Data").toList()
      );
    }
  }
}