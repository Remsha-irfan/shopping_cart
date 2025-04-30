import 'package:dartz/dartz.dart';
import 'package:shopping_cart/core/error/error.dart';
import 'package:shopping_cart/feature/data/model/product_model.dart';
import 'package:shopping_cart/feature/data/repository/product_repo.dart';

class GetAllProductsUseCase {
  final ProductRepository repository;

  GetAllProductsUseCase(this.repository);

  Future<Either<Failure, List<ProductModel>>> call() async {
    return await repository.getAllProducts();
  }
}
