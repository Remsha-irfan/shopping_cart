// import 'package:hive/hive.dart';
// import 'package:shopping_cart/feature/data/model/product_model.dart';

// class CartLocalDataSource {
//   final Box<ProductModel> productBox;

//   CartLocalDataSource(this.productBox);

//   Future<List<ProductModel>> getCartItems() async {
//     return productBox.values.toList();
//   }

//   Future<void> saveCartItem(ProductModel product) async {
//     await productBox.put(product.id, product);
//   }

//   Future<void> deleteCartItem(int id) async {
//     await productBox.delete(id);
//   }
// }
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shopping_cart/feature/data/model/product_model.dart';

class ProductRemoteDataSource {
  Future<List<ProductModel>> loadProductsFromJson() async {
    final String response = await rootBundle.loadString('assets/products.json');
    final List<dynamic> data = json.decode(response);
    return data.map((item) => ProductModel.fromJson(item)).toList();
  }
}
