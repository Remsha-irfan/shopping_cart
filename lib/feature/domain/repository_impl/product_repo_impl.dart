// // lib/feature/data/repository/product_repository_impl.dart
// import 'package:dartz/dartz.dart';
// import 'package:shopping_cart/core/error.dart';
// import 'package:shopping_cart/feature/data/data_source/product_data_source.dart';
// import 'package:shopping_cart/feature/data/model/product_model.dart';
// import 'package:shopping_cart/feature/data/repository/product_repo.dart';

// class ProductRepositoryImpl implements ProductRepository {
//   final ProductRemoteDataSource remoteDataSource;

//   ProductRepositoryImpl(this.remoteDataSource);

//   @override
//   Future<Either<Failure, List<ProductModel>>> getAllProducts() async {
//     try {
//       final products = await remoteDataSource.loadProductsFromJson();
//       return Right(products);
//     } catch (e) {
//       return Left(DataParsingFailure("Failed to parse product data"));
//     }
//   }

// }
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
      // Load products from local storage (Hive) or fetch from remote
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
      return Left(
        DataParsingFailure("Failed to parse product data"),
      ); // Return failure if there's an error
    }
  }
}
