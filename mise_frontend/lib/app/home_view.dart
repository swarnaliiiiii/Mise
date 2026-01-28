import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mise_frontend/app/add_expense_view.dart';
import 'package:mise_frontend/app/controller/expenses/list_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;
  final homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A), // Dark background from ref
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
               SizedBox(height: 30.w),
              _buildBalanceCard(),
               SizedBox(height: 30.w),
              _buildTransactionFilters(),
              SizedBox(height: 20.w),
              Expanded(child: _buildTransactionList()),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // 1. Header with Profile and Date
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.menu, color: Colors.grey),
            SizedBox(width: 120.w),
            Text(
              "Home",
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const Icon(Icons.notifications, color: Colors.grey),
      ],
    );
  }

  // 2. Total Balance Section (Current Transaction in your sketch)
  Widget _buildBalanceCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Total Balance", style: TextStyle(color: Colors.grey, fontSize: 14)),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "₦ 75,567.01",
              style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
            ),
            ElevatedButton.icon(
              onPressed: () => Get.to(() => AddExpenseView()), // Navigation trigger
              icon: const Icon(Icons.add, size: 18),
              label: const Text("New expense"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB4F59E), // Mint green from image
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 3. Transaction Tabs (Cash, All, Online from your sketch)
  Widget _buildTransactionFilters() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      _filterChip("Cash"),
      _filterChip("All"),
      _filterChip("Online"),
      ],
    );
  }

  Widget _filterChip(String label) {
  return Obx(() {
    bool isActive = homeController.selectedFilter.value == label;
    return GestureDetector(
      onTap: () => homeController.applyFilter(label),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isActive ? Colors.white12 : Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: isActive ? Colors.white24 : Colors.transparent),
        ),
        child: Text(
          label,
          style: TextStyle(color: isActive ? Colors.white : Colors.grey, fontSize: 14.sp),
        ),
      ),
    );
  });
}

  // 4. List of Transactions
  Widget _buildTransactionList() {
  return Obx(() {
    if (homeController.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
      itemCount: homeController.filteredExpenses.length,
      itemBuilder: (context, index) {
        final expense = homeController.filteredExpenses[index];
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            backgroundColor: Colors.white10,
            child: Icon(_getIcon(expense.category), color: Colors.green, size: 20.r),
          ),
          title: Text(expense.category, style: TextStyle(color: Colors.white, fontSize: 16.sp)),
          subtitle: Text(expense.date, style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
          trailing: Text(
            "₦ ${expense.amount.toStringAsFixed(2)}",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.sp),
          ),
        );
      },
    );
  });
}
  IconData _getIcon(String category) {
  switch (category) {
    case "Food": return Icons.fastfood;
    case "Cash Withdrawal": return Icons.money;
    default: return Icons.category;
  }
}

  // 5. Bottom Navigation Bar (Matching your sketch)
  Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color(0xFF0A0A0A),
      selectedItemColor: const Color(0xFFB4F59E),
      unselectedItemColor: Colors.grey,
      currentIndex: _selectedIndex,
      onTap: (index) => setState(() => _selectedIndex = index),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: "Add"),
        BottomNavigationBarItem(icon: Icon(Icons.auto_awesome), label: "AI"),
        BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: "Shared"),
        BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_outlined), label: "Loan"),
      ],
    );
  }
}