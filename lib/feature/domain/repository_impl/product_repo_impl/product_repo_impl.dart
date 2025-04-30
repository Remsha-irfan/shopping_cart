import 'package:dartz/dartz.dart';
import 'package:shopping_cart/core/error/error.dart';
import 'package:shopping_cart/feature/data/data_source/product_data_source.dart';
import 'package:shopping_cart/feature/data/model/product_model.dart';
import 'package:shopping_cart/feature/data/repository/product_repo.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource productRemoteDataSource;

  ProductRepositoryImpl(this.productRemoteDataSource);

  @override
  Future<Either<Failure, List<ProductModel>>> getAllProducts() async {
    try {
      final List<ProductModel> products =
          await productRemoteDataSource.loadProductsFromHive();
      if (products.isEmpty) {
        // If no products are found in Hive, load from remote source (assets JSON)
        final List<ProductModel> remoteProducts =
            await productRemoteDataSource.loadProductsFromJson();
        return Right(remoteProducts); // Return fetched products
      }
      return Right(products); // Return products from Hive if available
    } catch (e) {
      return Left(DataParsingFailure("Failed to parse product data"));
    }
  }
}
