import 'package:dartz/dartz.dart';
import 'package:shopping_cart/core/error.dart';
import 'package:shopping_cart/feature/data/data_source/product_data_source.dart';
import 'package:shopping_cart/feature/data/model/product_model.dart';
import 'package:shopping_cart/feature/data/repository/product_repo.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<ProductModel>>> getAllProducts() async {
    try {
      final products = await remoteDataSource.loadProductsFromJson();
      return Right(products);
    } catch (e) {
      if (e.toString().contains('Unable to load asset')) {
        return Left(FileNotFoundFailure("Product file not found"));
      }
      return Left(DataParsingFailure("Failed to parse product data"));
    }
  }
}
