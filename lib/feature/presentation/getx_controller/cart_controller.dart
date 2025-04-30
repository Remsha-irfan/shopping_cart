import 'dart:developer';
import 'package:get/get.dart';
import 'package:shopping_cart/core/error/error.dart';
import 'package:shopping_cart/feature/data/data_source/cart_local_datasource.dart';
import 'package:shopping_cart/feature/data/repository/cart_repo.dart';
import 'package:shopping_cart/feature/presentation/getx_controller/product_controller.dart';
import '../../data/model/product_model.dart';

class CartController extends GetxController {
  final RxList<ProductModel> productList = <ProductModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final RxDouble total = 0.0.obs;
  final RxDouble discount = 0.0.obs;

  // final CartLocalDataSource cartLocalDataSource;
  final CartRepository cartRepository;
  CartController({required this.cartRepository});

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

      // var items = await cartLocalDataSource.getCartItems();

      // productList.value = items;
      final result = await cartRepository.getCartItems();
      result.fold(
        (failure) => errorMessage.value = failure.message,
        (items) => productList.value = items,
      );

      _calculateTotals();
    } catch (e) {
      errorMessage.value = GeneralFailure(e.toString()).message;
    } finally {
      isLoading.value = false;
    }
  }

  // calculate discount
  void _calculateTotals() {
    double tempTotal = 0.0;
    for (var item in productList) {
      tempTotal += item.price * item.cartQuantity;
    }
    total.value = tempTotal;
    discount.value = tempTotal > 500 ? tempTotal * 0.10 : 0.0;
  }

  // add item into the cart
  void addToCart(ProductModel product) {
    try {
      bool exists = productList.any((item) => item.id == product.id);
      if (exists) {
        ProductModel existingProduct = productList.firstWhere(
          (item) => item.id == product.id,
        );
        existingProduct.cartQuantity += 1;
        cartRepository.saveCartItem(existingProduct);
      } else {
        product.cartQuantity = 1;
        cartRepository.saveCartItem(product);
        productList.add(product);
      }
      productList.refresh();
      _calculateTotals();
    } catch (e) {
      errorMessage.value = GeneralFailure(e.toString()).message;
    }
  }

  // remove item from the cart
  void removeFromCart(ProductModel product) {
    try {
      productList.remove(product);
      cartRepository.deleteCartItem(product.id);
      _calculateTotals();
    } catch (e) {
      errorMessage.value = GeneralFailure(e.toString()).message;
    }
  }

  void increaseQuantity(ProductModel product) {
    try {
      if (product.cartQuantity < product.quantity) {
        product.cartQuantity += 1;
        cartRepository.saveCartItem(product);
        productList.refresh();
        _calculateTotals();
      } else {
        errorMessage.value = "Maximum stock reached";

        Get.snackbar(
          "Stock Limit",
          "You can't add more than available stock",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      errorMessage.value = GeneralFailure(e.toString()).message;
    }
  }

  void decreaseQuantity(ProductModel product) {
    try {
      if (product.cartQuantity > 1) {
        product.cartQuantity -= 1;

        cartRepository.saveCartItem(product);
      } else {
        productList.removeWhere((item) => item.id == product.id);
        cartRepository.deleteCartItem(product.id);
      }
      productList.refresh();
      _calculateTotals();
    } catch (e) {
      errorMessage.value = GeneralFailure(e.toString()).message;
    }
  }

  void placeOrder() async {
    try {
      isLoading.value = true;

      for (var item in productList) {
        // 🔄 Reduce stock quantity by cart quantity
        item.quantity -= item.cartQuantity;

        log(
          "🛒 Product: ${item.name}, Stock after purchase: ${item.quantity}, Purchased: ${item.cartQuantity}",
        );

        item.cartQuantity = 0;

        await cartRepository.saveCartItem(item);

        await cartRepository.deleteCartItem(item.id);

        log(" ${item.name} updated & removed from cart");
      }

      productList.clear();
      _calculateTotals();

      Get.find<ProductController>().loadProducts();

      //  Navigate to confirmation screen
      Get.offAllNamed('/confirmation');
    } catch (e) {
      errorMessage.value = GeneralFailure(e.toString()).message;
    } finally {
      isLoading.value = false;
    }
  }
}
