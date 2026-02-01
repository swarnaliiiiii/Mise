import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mise_frontend/app/controller/split_share/shared_controller.dart';

class SharedView extends StatelessWidget {
  final controller = Get.put(SharedController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: CustomScrollView(
        slivers: [
          // 1. The Pinned Static Header
          SliverPersistentHeader(
            pinned: true,
            delegate: _SharedHeaderDelegate(controller: controller),
          ),

          // 2. The Scrolling Friends List
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            sliver: Obx(() => SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final friend = controller.filteredDebts[index];
                      return _buildFriendCard(friend);
                    },
                    childCount: controller.filteredDebts.length,
                  ),
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildFriendCard(dynamic friend) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(12.w),
        leading: CircleAvatar(
          radius: 25.r,
          backgroundColor: Colors.white24,
          child: const Icon(Icons.person, color: Colors.white70),
        ),
        title: Text(friend.name,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        subtitle: Text(friend.date,
            style: TextStyle(color: Colors.white38, fontSize: 12.sp)),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(friend.isOwedToMe ? "owes you" : "you owe",
                style: TextStyle(color: Colors.white38, fontSize: 10.sp)),
            Text(
              "${friend.isOwedToMe ? '+' : '-'}\$${friend.amount.toStringAsFixed(2)}",
              style: TextStyle(
                color: friend.isOwedToMe ? const Color(0xFFB4F59E) : Colors.redAccent,
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// This class defines the Sticky Header (Green Summary + Tabs)
class _SharedHeaderDelegate extends SliverPersistentHeaderDelegate {
  final SharedController controller;

  _SharedHeaderDelegate({required this.controller});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: const Color(0xFF0A0A0A), // Prevents content from showing behind header
      child: Column(
        children: [
          // The Mint Green Summary Section (Acts like an AppBar + Summary)
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 50.h, bottom: 24.h, left: 24.w, right: 24.w),
            decoration: BoxDecoration(
              color: const Color(0xFFB4F59E),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30.r),
                bottomRight: Radius.circular(30.r),
              ),
            ),
            child: Column(
              children: [
                const Text("Friends", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
                SizedBox(height: 20.h),
                Text("Total Balance", style: TextStyle(color: Colors.black54, fontSize: 14.sp)),
                SizedBox(height: 8.h),
                Text(
                  "-\$154.68",
                  style: TextStyle(color: Colors.black, fontSize: 36.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _headerAction(Icons.payment, "Pay"),
                    _headerAction(Icons.notifications_active, "Remind"),
                    _headerAction(Icons.share, "Share"),
                  ],
                )
              ],
            ),
          ),
          
          // The Tab Switcher (Pinned right below the green section)
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
            child: _buildTabSwitcher(),
          ),
        ],
      ),
    );
  }

  Widget _headerAction(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.white.withOpacity(0.5),
          child: Icon(icon, color: Colors.black),
        ),
        SizedBox(height: 4.h),
        Text(label, style: TextStyle(color: Colors.black, fontSize: 12.sp)),
      ],
    );
  }

  Widget _buildTabSwitcher() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: Obx(() => Row(
            children: ["Overall", "I owe", "Owes me"].map((tab) {
              bool isSelected = controller.selectedTab.value == tab;
              return Expanded(
                child: GestureDetector(
                  onTap: () => controller.changeTab(tab),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFB4F59E) : Colors.transparent,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Center(
                      child: Text(
                        tab,
                        style: TextStyle(
                          color: isSelected ? Colors.black : Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          )),
    );
  }

  @override
  double get maxExtent => 380.h; // The height when fully visible

  @override
  double get minExtent => 380.h; // Keep it same as max to remain static

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}