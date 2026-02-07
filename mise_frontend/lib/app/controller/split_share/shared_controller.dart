import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mise_frontend/app/models/share_model.dart';

class SharedController extends GetxController {
  var selectedTab = "Overall".obs;
  var friendsDebts = <FriendDebt>[].obs;
  var isLoading = false.obs;

  // Shared Base URL from .env
  final String baseUrl = dotenv.env['BASE_URL'] ?? '';

  @override
  void onInit() {
    super.onInit();
    fetchSharedDebts();
  }

  // REFACTORED: Removed mock data, now calls backend
  Future<void> fetchSharedDebts() async {
    try {
      isLoading(true);
      // Assuming you create a /shared-debts endpoint in your FastAPI
      final response = await Dio().get("$baseUrl/shared-debts"); 
      
      if (response.statusCode == 200) {
        var list = (response.data as List)
            .map((e) => FriendDebt.fromJson(e))
            .toList();
        friendsDebts.assignAll(list);
      }
    } catch (e) {
      print("Shared Fetch Error: $e");
    } finally {
      isLoading(false);
    }
  }

  List<FriendDebt> get filteredDebts {
    if (selectedTab.value == "I owe") {
      return friendsDebts.where((d) => d.isOwedToMe == false).toList();
    } else if (selectedTab.value == "Owes me") {
      return friendsDebts.where((d) => d.isOwedToMe == true).toList();
    }
    return friendsDebts;
  }

  void changeTab(String tab) => selectedTab.value = tab;
}