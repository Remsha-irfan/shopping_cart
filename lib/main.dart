import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_cart/feature/data/data_source/product_data_source.dart';
import 'package:shopping_cart/feature/data/model/product_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shopping_cart/feature/domain/repository_impl/product_repo_impl.dart';
import 'package:shopping_cart/feature/domain/usecase/get_all_product_usecase.dart';
import 'package:shopping_cart/feature/presentation/getx_controller/product_controller.dart';
import 'package:shopping_cart/feature/presentation/screen/product_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ProductModelAdapter());

  await Hive.openBox<ProductModel>('cartBox');

  final productRemoteDataSource = ProductRemoteDataSource();
  final productRepo = ProductRepositoryImpl(productRemoteDataSource);
  final getAllProductsUseCase = GetAllProductsUseCase(productRepo);

  Get.put(ProductController(getAllProductsUseCase));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: ProductListScreen(),
    );
  }
}
