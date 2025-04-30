import 'dart:developer';
import 'package:get/get.dart';
import 'package:shopping_cart/core/error/error.dart';
import 'package:shopping_cart/feature/data/data_source/cart_local_datasource.dart';
import 'package:shopping_cart/feature/domain/usecase/get_all_product_usecase.dart';
import 'package:shopping_cart/feature/presentation/getx_controller/product_controller.dart';
import '../../data/model/product_model.dart';

class CartController extends GetxController {
  final RxList<ProductModel> productList = <ProductModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxDouble scrollPosition = 0.0.obs;

  final RxDouble total = 0.0.obs;
  final RxDouble discount = 0.0.obs;

  final CartLocalDataSource cartLocalDataSource;
  final GetAllProductsUseCase getAllProductsUseCase;

  CartController({
    required this.cartLocalDataSource,
    required this.getAllProductsUseCase,
  });

  @override
  void onInit() {
    super.onInit();
    loadCartItems();
    ever(productList, (_) => _calculateTotals()); // auto update total/discount
  }

  // Load cart items from local database
  void loadCartItems() async {
    try {
      isLoading.value = true;

      var items = await cartLocalDataSource.getCartItems();

      productList.value = items;

      _calculateTotals();
    } catch (e) {
      errorMessage.value = handleFailure(e);
    } finally {
      isLoading.value = false;
    }
  }

  void _calculateTotals() {
    double tempTotal = 0.0;
    for (var item in productList) {
      tempTotal += item.price * item.cartQuantity;
    }
    total.value = tempTotal;
    discount.value = tempTotal > 500 ? tempTotal * 0.10 : 0.0;
  }

  // void addToCart(ProductModel product) {
  //   try {
  //     bool exists = productList.any((item) => item.id == product.id);
  //     if (exists) {
  //       ProductModel existingProduct = productList.firstWhere(
  //         (item) => item.id == product.id,
  //       );
  //       existingProduct.quantity += 1;
  //       cartLocalDataSource.saveCartItem(existingProduct);
  //     } else {
  //       product.quantity = 1;
  //       cartLocalDataSource.saveCartItem(product);
  //       productList.add(product);
  //     }
  //     productList.refresh();
  //     _calculateTotals();
  //   } catch (e) {
  //     errorMessage.value = handleFailure(e);
  //   }
  // }

  void addToCart(ProductModel product) {
    try {
      bool exists = productList.any((item) => item.id == product.id);
      if (exists) {
        ProductModel existingProduct = productList.firstWhere(
          (item) => item.id == product.id,
        );
        existingProduct.cartQuantity += 1;
        cartLocalDataSource.saveCartItem(existingProduct);
      } else {
        product.cartQuantity = 1;
        cartLocalDataSource.saveCartItem(product);
        productList.add(product);
      }
      productList.refresh();
      _calculateTotals();
    } catch (e) {
      errorMessage.value = handleFailure(e);
    }
  }

  void removeFromCart(ProductModel product) {
    try {
      productList.remove(product);
      cartLocalDataSource.deleteCartItem(product.id);
      _calculateTotals();
    } catch (e) {
      errorMessage.value = handleFailure(e);
    }
  }

  void increaseQuantity(ProductModel product) {
    try {
      product.cartQuantity += 1;
      cartLocalDataSource.saveCartItem(product);
      productList.refresh();
      _calculateTotals();
    } catch (e) {
      errorMessage.value = handleFailure(e);
    }
  }

  void decreaseQuantity(ProductModel product) {
    try {
      if (product.cartQuantity > 1) {
        product.cartQuantity -= 1;

        cartLocalDataSource.saveCartItem(product);
      } else {
        productList.removeWhere((item) => item.id == product.id);
        cartLocalDataSource.deleteCartItem(product.id);
      }
      productList.refresh();
      _calculateTotals();
    } catch (e) {
      errorMessage.value = handleFailure(e);
    }
  }

  // void placeOrder() {
  //   try {
  //     for (var item in cartItems) {
  //       cartLocalDataSource.deleteCartItem(item.id);
  //     }
  //     cartItems.clear();
  //     _calculateTotals();
  //   } catch (e) {
  //     errorMessage.value = handleFailure(e);
  //   }
  // }

  //

  void placeOrder() async {
    try {
      isLoading.value = true;

      for (var item in productList) {
        // 🔄 Reduce stock quantity by cart quantity
        item.quantity -= item.cartQuantity;

        log(
          "🛒 Product: ${item.name}, Stock after purchase: ${item.quantity}, Purchased: ${item.cartQuantity}",
        );

        // Reset cartQuantity after purchase
        item.cartQuantity = 0;

        // ✅ Update local DB with new stock
        await cartLocalDataSource.saveCartItem(item);

        // 🗑️ Remove product from cart (optional: you could filter by cartQuantity == 0 later)
        await cartLocalDataSource.deleteCartItem(item.id);

        log("✅ ${item.name} updated & removed from cart");
      }

      // 🧹 Clear cart list and totals
      productList.clear();
      _calculateTotals();

      Get.find<ProductController>().loadProducts();

      // ✅ Navigate to confirmation screen
      Get.offNamed('/confirmation');
    } catch (e) {
      errorMessage.value = handleFailure(e);
    } finally {
      isLoading.value = false;
    }
  }

  String handleFailure(Object e) {
    if (e is Failure) {
      return e.message;
    } else if (e is Exception) {
      return "An unexpected error occurred";
    } else {
      return "An unknown error occurred";
    }
  }
}
