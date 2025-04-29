import 'package:get/get.dart';
import 'package:shopping_cart/feature/data/model/product_model.dart';
import 'package:shopping_cart/feature/domain/usecase/get_all_product_usecase.dart';

class ProductController extends GetxController {
  final GetAllProductsUseCase getAllProductsUseCase;

  var productList = <ProductModel>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  ProductController(this.getAllProductsUseCase);

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  void loadProducts() async {
    isLoading.value = true;
    final result = await getAllProductsUseCase();

    result.fold(
      (failure) {
        errorMessage.value = failure.message;
        isLoading.value = false;
      },
      (products) {
        productList.value = products;
        isLoading.value = false;
      },
    );
  }
}
