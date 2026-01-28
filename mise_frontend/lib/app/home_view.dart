import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

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
              onPressed: () {},
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
        _filterChip("All", isActive: true),
        _filterChip("Online"),
      ],
    );
  }

  Widget _filterChip(String label, {bool isActive = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? Colors.white12 : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isActive ? Colors.white24 : Colors.transparent),
      ),
      child: Text(
        label,
        style: TextStyle(color: isActive ? Colors.white : Colors.grey),
      ),
    );
  }

  // 4. List of Transactions
  Widget _buildTransactionList() {
    return ListView(
      children: const [
        Text("Recent expenses", style: TextStyle(color: Colors.grey, fontSize: 14)),
        SizedBox(height: 15),
        // Placeholder items
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(backgroundColor: Colors.white10, child: Icon(Icons.fastfood, color: Colors.green)),
          title: Text("Food", style: TextStyle(color: Colors.white)),
          subtitle: Text("10 Oct, 2023", style: TextStyle(color: Colors.grey)),
          trailing: Text("₦ 75,567.01", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ],
    );
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