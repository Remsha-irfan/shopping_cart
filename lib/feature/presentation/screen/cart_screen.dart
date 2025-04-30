import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shopping_cart/core/common_widget/custom_text.dart';
import 'package:shopping_cart/core/common_widget/custom_text_style.dart';
import 'package:shopping_cart/core/common_widget/sized_box.dart';
import 'package:shopping_cart/core/constant/colors.dart';
import 'package:shopping_cart/feature/presentation/getx_controller/cart_controller.dart';

class CartScreen extends StatelessWidget {
  final cartController = Get.find<CartController>();
  final ScrollController _scrollController = ScrollController();

  CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: "Your Cart",
          style: CustomTextStyles.Inter(
            fontWeight: FontWeight.bold,
            color: AppColors.blackColor,
          ),
        ),
      ),
      body: Obx(() {
        if (cartController.productList.isEmpty) {
          return Center(
            child: CustomText(
              text: "Cart is Empty",
              style: CustomTextStyles.Inter(
                fontSize: 40.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.blackColor,
              ),
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: cartController.productList.length,
                itemBuilder: (context, index) {
                  final item = cartController.productList[index];
                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text('\$ ${item.price} x ${item.cartQuantity}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed:
                              () => cartController.decreaseQuantity(item),
                          icon: Icon(Icons.remove),
                        ),
                        IconButton(
                          onPressed:
                              () => cartController.increaseQuantity(item),
                          icon: Icon(Icons.add),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text:
                          "Total: \$ ${cartController.total.value.toStringAsFixed(2)}",
                      style: CustomTextStyles.Inter(
                        fontSize: 40.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.blackColor,
                      ),
                    ),

                    if (cartController.discount.value > 0) ...[
                      CustomText(
                        text:
                            "Discount Amount: \$ ${cartController.discount.value.toStringAsFixed(2)}",
                        style: CustomTextStyles.Inter(
                          fontSize: 35.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.redColor,
                        ),
                      ),
                      CustomText(
                        text:
                            "After Discount: \$ ${(cartController.total.value - cartController.discount.value).toStringAsFixed(2)}",
                        style: CustomTextStyles.Inter(
                          fontSize: 35.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.greenColor,
                        ),
                      ),
                    ],

                    08.sbh,
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          try {
                            cartController.placeOrder();
                          } catch (e) {
                            Get.snackbar(
                              "Error",
                              "Something went wrong while placing order.",
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.appColor,
                          padding: EdgeInsets.symmetric(
                            horizontal: 62.w,
                            vertical: 15.h,
                          ),
                        ),
                        child: CustomText(
                          text: "Place Order",
                          style: CustomTextStyles.Inter(
                            fontSize: 40.sp,
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
