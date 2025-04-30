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
