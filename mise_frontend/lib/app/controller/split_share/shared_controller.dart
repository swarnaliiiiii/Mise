import 'package:get/get.dart';
import 'package:mise_frontend/app/models/share_model.dart';

class SharedController extends GetxController {
  var selectedTab = "Overall".obs;
  var friendsDebts = <FriendDebt>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchSharedDebts();
  }

  void fetchSharedDebts() {
    // Mock data based on your image
    var data = [
      FriendDebt(
          name: "Peter",
          date: "11 March 2022",
          amount: 154.68,
          isOwedToMe: false,
          imageUrl: ""),
      FriendDebt(
          name: "Victor",
          date: "10 March 2022",
          amount: 260.68,
          isOwedToMe: true,
          imageUrl: ""),
      FriendDebt(
          name: "Camila",
          date: "09 March 2022",
          amount: 13.20,
          isOwedToMe: false,
          imageUrl: ""),
      FriendDebt(
          name: "Alex",
          date: "05 March 2022",
          amount: 15.99,
          isOwedToMe: true,
          imageUrl: ""),
      FriendDebt(
          name: "Samantha",
          date: "01 March 2022",
          amount: 45.00,
          isOwedToMe: false,
          imageUrl: ""),
      FriendDebt(
          name: "John",
          date: "28 February 2022",
          amount: 120.75,
          isOwedToMe: true,
          imageUrl: ""),
      FriendDebt(
          name: "Emily",
          date: "25 February 2022",
          amount: 32.40,
          isOwedToMe: false,
          imageUrl: ""),
      FriendDebt(
          name: "Michael",
          date: "20 February 2022",
          amount: 75.25,
          isOwedToMe: true,
          imageUrl: ""),
    ];
    friendsDebts.assignAll(data);
  }

  List<FriendDebt> get filteredDebts {
  if (selectedTab.value == "I owe") {
    // Show only cases where isOwedToMe is FALSE (you owe them)
    return friendsDebts.where((d) => d.isOwedToMe == false).toList();
  } else if (selectedTab.value == "Owes me") {
    // Show only cases where isOwedToMe is TRUE (they owe you)
    return friendsDebts.where((d) => d.isOwedToMe == true).toList();
  }
  return friendsDebts; // "Overall"
}

  void changeTab(String tab) => selectedTab.value = tab;
}
