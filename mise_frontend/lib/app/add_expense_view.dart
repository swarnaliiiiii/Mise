import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mise_frontend/app/controller/expenses/add_expense_controller.dart';

class AddExpenseView extends StatelessWidget {
  AddExpenseView({super.key});

  final controller = Get.put(AddExpenseController());
  // Controller for the amount input field
  final TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: _buildAppBar(),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Enter expense details.",
              style: TextStyle(color: Colors.grey, fontSize: 14.sp),
            ),
            SizedBox(height: 20.h),
            _buildAmountInput(),
            SizedBox(height: 24.h),
            Expanded(child: _buildCategoryList()),
            _buildDatePicker(context),
            SizedBox(height: 20.h),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leadingWidth: 80.w,
      leading: const Center(
        child: Text("TA", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      title: Text(
        "New expense",
        style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
        )
      ],
    );
  }

  Widget _buildAmountInput() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white10),
      ),
      child: TextField(
        controller: amountController, // Attached controller
        keyboardType: TextInputType.number,
        style: TextStyle(color: Colors.white, fontSize: 18.sp),
        decoration: InputDecoration(
          icon: Text("₦", style: TextStyle(color: Colors.grey, fontSize: 18.sp)),
          hintText: "Enter amount",
          hintStyle: const TextStyle(color: Colors.white24),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildCategoryList() {
    return ListView.separated(
      itemCount: controller.categories.length,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final cat = controller.categories[index];
        return Obx(() => GestureDetector(
              onTap: () => controller.setCategory(cat['name']),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.02),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: controller.selectedCategory.value == cat['name']
                        ? const Color(0xFFB4F59E)
                        : Colors.white10,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.category, color: Colors.green, size: 20),
                    SizedBox(width: 15.w),
                    Text(
                      cat['name'],
                      style: TextStyle(color: Colors.white, fontSize: 16.sp),
                    ),
                    const Spacer(),
                    Container(
                      height: 18.r,
                      width: 18.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey),
                      ),
                      child: controller.selectedCategory.value == cat['name']
                          ? Center(
                              child: Container(
                                width: 10.r,
                                height: 10.r,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFB4F59E),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            )
                          : null,
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return Obx(() => GestureDetector(
          onTap: () => controller.pickDate(context), // Logic to open calendar
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  controller.selectedDateString.value, // Observable date string
                  style: const TextStyle(color: Colors.grey),
                ),
                Icon(Icons.calendar_today, color: Colors.grey, size: 20.r),
              ],
            ),
          ),
        ));
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 55.h,
      child: Obx(() => ElevatedButton(
            // Disable button while loading to prevent double-submit
            onPressed: controller.isLoading.value
                ? null
                : () => controller.saveExpense(amountController.text),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB4F59E),
              disabledBackgroundColor: Colors.grey.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: controller.isLoading.value
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.black,
                    ),
                  )
                : Text(
                    "Save expense",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
          )),
    );
  }
}