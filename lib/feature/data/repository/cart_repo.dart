import 'package:dartz/dartz.dart';
import 'package:shopping_cart/core/error.dart';
import 'package:shopping_cart/feature/data/model/product_model.dart';

abstract class CartRepository {
  Future<Either<Failure, List<ProductModel>>> getCartItems();
  Future<Either<Failure, void>> saveCartItem(ProductModel product);
  Future<Either<Failure, void>> deleteCartItem(int id);
}
