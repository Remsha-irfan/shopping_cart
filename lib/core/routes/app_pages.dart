import 'package:get/get.dart';
import 'package:shopping_cart/feature/presentation/screen/cart_screen.dart';
import 'package:shopping_cart/feature/presentation/screen/order_conformation_screen.dart';
import 'package:shopping_cart/feature/presentation/screen/product_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(name: AppRoutes.home, page: () => ProductListScreen()),
    GetPage(name: AppRoutes.cart, page: () => CartScreen()),
    GetPage(
      name: AppRoutes.confirmation,
      page: () => OrderConfirmationScreen(),
    ),
  ];
}
