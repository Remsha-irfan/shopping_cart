import 'package:dartz/dartz.dart';
import 'package:shopping_cart/core/error/error.dart';
import 'package:shopping_cart/feature/data/data_source/cart_local_datasource.dart';
import 'package:shopping_cart/feature/data/model/product_model.dart';
import 'package:shopping_cart/feature/data/repository/cart_repo.dart';

class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource localDataSource;

  CartRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<ProductModel>>> getCartItems() async {
    try {
      final result = await localDataSource.getCartItems();
      return Right(result);
    } catch (e) {
      return Left(
        DataParsingFailure('Failed to load cart items: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> saveCartItem(ProductModel product) async {
    try {
      await localDataSource.saveCartItem(product);
      return const Right(null);
    } catch (e) {
      return Left(GeneralFailure('Failed to save cart item: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCartItem(int id) async {
    try {
      await localDataSource.deleteCartItem(id);
      return const Right(null);
    } catch (e) {
      return Left(
        GeneralFailure('Failed to delete cart item: ${e.toString()}'),
      );
    }
  }
}
