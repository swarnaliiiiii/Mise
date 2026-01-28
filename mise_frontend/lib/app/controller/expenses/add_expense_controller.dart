import 'package:get/get.dart';

class AddExpenseController extends GetxController {
  // Observable variables
  var selectedCategory = "Food".obs;
  var selectedDate = "Choose date".obs;
  var amount = "".obs;

  final List<Map<String, dynamic>> categories = [
    {"name": "Food", "icon": "assets/icons/food.png"}, // Use Icons.fastfood if no assets
    {"name": "Airtime/Data", "icon": "assets/icons/phone.png"},
    {"name": "Cash Withdrawal", "icon": "assets/icons/cash.png"},
    {"name": "Other", "icon": "assets/icons/other.png"},
  ];

  void setCategory(String category) => selectedCategory.value = category;
  
  void setDate(String date) => selectedDate.value = date;
}