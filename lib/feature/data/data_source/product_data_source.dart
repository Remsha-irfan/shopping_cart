// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
// import 'package:flutter/services.dart';
// import 'package:shopping_cart/feature/data/model/product_model.dart';
// import 'package:path_provider/path_provider.dart';

// class ProductRemoteDataSource {
//   // Load products from the assets JSON file
//   Future<List<ProductModel>> loadProductsFromJson() async {
//     final String response = await rootBundle.loadString('assets/products.json');
//     final List<dynamic> data = json.decode(response);
//     return data.map((item) => ProductModel.fromJson(item)).toList();
//   }
// }
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:shopping_cart/feature/data/model/product_model.dart';

class ProductRemoteDataSource {
  // Load products from the assets JSON file and save them to Hive
  Future<List<ProductModel>> loadProductsFromJson() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/products.json',
      );
      final List<dynamic> data = json.decode(response);

      // Convert the data into ProductModel objects
      List<ProductModel> products =
          data.map((item) => ProductModel.fromJson(item)).toList();

      // Save the loaded products to Hive
      await saveProductsToHive(products);

      return products; // Return the loaded products
    } catch (e) {
      throw Exception('Error loading products from JSON: $e');
    }
  }

  // Saving to Hive
  Future<void> saveProductsToHive(List<ProductModel> products) async {
    try {
      var productBox = await Hive.openBox<ProductModel>('products');
      for (var product in products) {
        await productBox.put(
          product.id,
          product,
        ); // Save each product by its ID
      }
    } catch (e) {
      throw Exception('Error saving products to Hive: $e');
    }
  }

  // Loading from Hive
  Future<List<ProductModel>> loadProductsFromHive() async {
    try {
      var productBox = await Hive.openBox<ProductModel>('products');
      return productBox.values.toList(); // Return all stored products
    } catch (e) {
      throw Exception('Error loading products from Hive: $e');
    }
  }
}
