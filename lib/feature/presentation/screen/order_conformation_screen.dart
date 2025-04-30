import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shopping_cart/core/common_widget/custom_text.dart';
import 'package:shopping_cart/core/common_widget/custom_text_style.dart';
import 'package:shopping_cart/core/common_widget/sized_box.dart';
import 'package:shopping_cart/core/constant/colors.dart';

class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Order Placed"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, size: 270.sp, color: AppColors.greenColor),
            20.sbh,
            CustomText(
              text: "Thanks for your order!",
              style: CustomTextStyles.Inter(
                fontSize: 50.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.blackColor,
              ),
            ),
            180.sbh,
            ElevatedButton(
              onPressed: () {
                Get.offAllNamed('/');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.appColor,
                padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 12.h),
              ),
              child: CustomText(
                text: "Go to Home",
                style: CustomTextStyles.Inter(
                  fontSize: 50.sp,
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
