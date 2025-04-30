import 'package:hive/hive.dart';
import 'package:shopping_cart/feature/data/model/product_model.dart';

class CartLocalDataSource {
  final Box<ProductModel> _cartBox;

  CartLocalDataSource(this._cartBox);

  // Save item to cart
  Future<void> saveCartItem(ProductModel product) async {
    // Get the current product from Hive (if exists)
    ProductModel? existingProduct = _cartBox.get(product.id);

    if (existingProduct != null) {
      // Update the quantity if product already exists
      existingProduct.quantity = product.quantity;
      await _cartBox.put(
        product.id,
        existingProduct,
      ); // Overwrite the existing product with updated quantity
    } else {
      // Add new product if it doesn't exist
      await _cartBox.put(product.id, product);
    }
  }

  // Get cart items from Hive
  Future<List<ProductModel>> getCartItems() async {
    return _cartBox.values.toList();
  }

  // Delete cart item by ID
  Future<void> deleteCartItem(int id) async {
    await _cartBox.delete(id);
  }
}
