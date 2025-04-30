import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shopping_cart/core/common_widget/custom_text.dart';
import 'package:shopping_cart/core/common_widget/custom_text_style.dart';
import 'package:shopping_cart/core/common_widget/sized_box.dart';
import 'package:shopping_cart/core/constant/colors.dart';
import 'package:shopping_cart/feature/presentation/getx_controller/product_controller.dart';
import 'package:shopping_cart/feature/presentation/getx_controller/cart_controller.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productController = Get.find<ProductController>();
    final cartController = Get.find<CartController>();

    return Scaffold(
      appBar: AppBar(
        title: Text("All Products"),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () => Get.toNamed('/cart'),
          ),
        ],
      ),
      body: Obx(() {
        if (productController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (productController.errorMessage.isNotEmpty) {
          return Center(child: Text(productController.errorMessage.value));
        }

        return ListView.separated(
          padding: EdgeInsets.all(12.w),
          itemCount: productController.productList.length,
          separatorBuilder: (_, __) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            final product = productController.productList[index];
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Icon(
                        Icons.shopping_bag,
                        size: 110.sp,
                        color: AppColors.appColor,
                      ),
                    ),
                    12.sbw,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: product.name,
                            style: CustomTextStyles.Inter(
                              fontSize: 30.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.blackColor,
                            ),
                          ),

                          4.sbh,
                          CustomText(
                            text: product.description,
                            style: CustomTextStyles.Inter(
                              fontSize: 23.sp,
                              color: AppColors.greyColor,
                            ),
                          ),

                          8.sbh,
                          CustomText(
                            text: "\$${product.price.toStringAsFixed(2)} ",
                            style: CustomTextStyles.Inter(
                              fontSize: 23.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.greenColor,
                            ),
                          ),
                          CustomText(
                            text: "Remaining ${product.quantity}",
                            style: CustomTextStyles.Inter(
                              fontSize: 23.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.greenColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    8.sbw,
                    ElevatedButton(
                      onPressed: () {
                        cartController.addToCart(product);
                        Get.snackbar(
                          "Cart",
                          "${product.name} added to cart!",
                          snackPosition: SnackPosition.BOTTOM,
                          duration: Duration(seconds: 2),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.appColor,
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                        // textStyle: TextStyle(fontSize: 25.sp),
                      ),
                      child: CustomText(
                        text: "Add",
                        style: CustomTextStyles.Inter(
                          fontSize: 30.sp,
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
