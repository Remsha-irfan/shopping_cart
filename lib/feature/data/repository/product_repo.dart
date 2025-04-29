import 'package:shopping_cart/core/error.dart';
import 'package:shopping_cart/feature/data/model/product_model.dart';

import 'package:dartz/dartz.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<ProductModel>>> getAllProducts();
}
