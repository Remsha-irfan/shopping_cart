import 'package:get/get.dart';
import 'package:shopping_cart/core/error.dart';
import 'package:shopping_cart/feature/data/data_source/cart_local_datasource.dart';
import '../../data/model/product_model.dart';

// class CartController extends GetxController {
//  final RxList<ProductModel> cartItems = <ProductModel>[].obs;
// final RxBool isLoading = false.obs;
// final RxString errorMessage = ''.obs;
// final RxDouble scrollPosition = 0.0.obs;

// final RxDouble total = 0.0.obs;
// final RxDouble discount = 0.0.obs;

//   final CartLocalDataSource cartLocalDataSource;

//   CartController({required this.cartLocalDataSource});

//   @override
//   void onInit() {
//     super.onInit();
//     loadCartItems();
//   }

//   // Load cart items from local database
//   void loadCartItems() async {
//     try {
//       isLoading.value = true;
//       cartItems.value = await cartLocalDataSource.getCartItems();
//     } catch (e) {
//       errorMessage.value = handleFailure(e);
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // // Add item to cart
//   // void addToCart(ProductModel product) {
//   //   try {
//   //     bool exists = cartItems.any((item) => item.id == product.id);
//   //     if (exists) {
//   //       // Update quantity if already in cart
//   //       ProductModel existingProduct = cartItems.firstWhere(
//   //         (item) => item.id == product.id,
//   //       );
//   //       existingProduct.quantity += 1;
//   //       cartLocalDataSource.saveCartItem(existingProduct);
//   //     } else {
//   //       // Add new product
//   //       product.quantity = 1;
//   //       cartLocalDataSource.saveCartItem(product);
//   //       cartItems.add(product);
//   //     }
//   //   } catch (e) {
//   //     errorMessage.value = handleFailure(e);
//   //   }
//   // }
//   void addToCart(ProductModel product) {
//     try {
//       bool exists = cartItems.any((item) => item.id == product.id);
//       if (exists) {
//         // Update quantity if already in cart
//         ProductModel existingProduct = cartItems.firstWhere(
//           (item) => item.id == product.id,
//         );
//         existingProduct.quantity += 1; // Update quantity
//         cartLocalDataSource.saveCartItem(existingProduct);
//       } else {
//         // Add new product
//         product.quantity = 1; // Set initial quantity to 1
//         cartLocalDataSource.saveCartItem(product);
//         cartItems.add(product);
//       }
//     } catch (e) {
//       errorMessage.value = handleFailure(e);
//     }
//   }

//   // Remove item from cart
//   void removeFromCart(ProductModel product) {
//     try {
//       cartItems.remove(product);
//       cartLocalDataSource.deleteCartItem(product.id);
//     } catch (e) {
//       errorMessage.value = handleFailure(e);
//     }
//   }

//   // Increase quantity
//   void increaseQuantity(ProductModel product) {
//     try {
//       product.quantity += 1;
//       cartLocalDataSource.saveCartItem(product);
//       loadCartItems(); // Reload the cart items to reflect changes
//     } catch (e) {
//       errorMessage.value = handleFailure(e);
//     }
//   }

//   // Decrease quantity
//   void decreaseQuantity(ProductModel product) {
//     try {
//       if (product.quantity > 1) {
//         product.quantity -= 1;
//         cartLocalDataSource.saveCartItem(product);
//         loadCartItems(); // Reload the cart items to reflect changes
//       }
//     } catch (e) {
//       errorMessage.value = handleFailure(e);
//     }
//   }

//   // Calculate total price
//   double get total {
//     return cartItems.fold(
//       0,
//       (total, item) => total + (item.price * item.quantity),
//     );
//   }

//   // Calculate discount if total exceeds 500
//   double get discount {
//     return total > 500 ? total * 0.10 : 0.0;
//   }

//   // Place an order (dummy implementation)
//   void placeOrder() {
//     try {
//       // You can add API call or order logic here
//       cartItems.clear();
//       cartLocalDataSource.saveCartItem(
//         ProductModel(
//           id: -1,
//           name: "Dummy Product",
//           price: 0,
//           quantity: 0,
//           description: "",
//         ),
//       );
//     } catch (e) {
//       errorMessage.value = handleFailure(e);
//     }
//   }

//   String handleFailure(Object e) {
//     if (e is Failure) {
//       // If it's a Failure (GeneralFailure, DataParsingFailure, etc.), return the message.
//       return e.message;
//     } else if (e is Exception) {
//       // If it's a general exception, return a generic message for exception types.
//       return "An unexpected error occurred";
//     } else {
//       // For other types of errors (non-Exception errors), return a different message.
//       return "An unknown error occurred";
//     }
//   }
// }

class CartController extends GetxController {
  final RxList<ProductModel> cartItems = <ProductModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxDouble scrollPosition = 0.0.obs;

  final RxDouble total = 0.0.obs;
  final RxDouble discount = 0.0.obs;

  final CartLocalDataSource cartLocalDataSource;

  CartController({required this.cartLocalDataSource});

  @override
  void onInit() {
    super.onInit();
    loadCartItems();
    ever(cartItems, (_) => _calculateTotals()); // auto update total/discount
  }

  // Load cart items from local database
  void loadCartItems() async {
    try {
      isLoading.value = true;
      cartItems.value = await cartLocalDataSource.getCartItems();
      _calculateTotals();
    } catch (e) {
      errorMessage.value = handleFailure(e);
    } finally {
      isLoading.value = false;
    }
  }

  void _calculateTotals() {
    double tempTotal = 0.0;
    for (var item in cartItems) {
      tempTotal += item.price * item.quantity;
    }
    total.value = tempTotal;
    discount.value = tempTotal > 500 ? tempTotal * 0.10 : 0.0;
  }

  void addToCart(ProductModel product) {
    try {
      bool exists = cartItems.any((item) => item.id == product.id);
      if (exists) {
        ProductModel existingProduct = cartItems.firstWhere(
          (item) => item.id == product.id,
        );
        existingProduct.quantity += 1;
        cartLocalDataSource.saveCartItem(existingProduct);
      } else {
        product.quantity = 1;
        cartLocalDataSource.saveCartItem(product);
        cartItems.add(product);
      }
      cartItems.refresh();
      _calculateTotals();
    } catch (e) {
      errorMessage.value = handleFailure(e);
    }
  }

  void removeFromCart(ProductModel product) {
    try {
      cartItems.remove(product);
      cartLocalDataSource.deleteCartItem(product.id);
      _calculateTotals();
    } catch (e) {
      errorMessage.value = handleFailure(e);
    }
  }

  void increaseQuantity(ProductModel product) {
    try {
      product.quantity += 1;
      cartLocalDataSource.saveCartItem(product);
      cartItems.refresh();
      _calculateTotals();
    } catch (e) {
      errorMessage.value = handleFailure(e);
    }
  }

  void decreaseQuantity(ProductModel product) {
    try {
      if (product.quantity > 1) {
        product.quantity -= 1;
        cartLocalDataSource.saveCartItem(product);
      } else {
        cartItems.removeWhere((item) => item.id == product.id);
        cartLocalDataSource.deleteCartItem(product.id);
      }
      cartItems.refresh();
      _calculateTotals();
    } catch (e) {
      errorMessage.value = handleFailure(e);
    }
  }

  void placeOrder() {
    try {
      for (var item in cartItems) {
        cartLocalDataSource.deleteCartItem(item.id);
      }
      cartItems.clear();
      _calculateTotals();
    } catch (e) {
      errorMessage.value = handleFailure(e);
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
