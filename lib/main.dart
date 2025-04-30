import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shopping_cart/feature/data/data_source/cart_local_datasource.dart';
import 'package:shopping_cart/feature/data/data_source/product_data_source.dart';
import 'package:shopping_cart/feature/data/model/product_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shopping_cart/feature/domain/repository_impl/product_repo_impl.dart';
import 'package:shopping_cart/feature/domain/usecase/get_all_product_usecase.dart';
import 'package:shopping_cart/feature/presentation/getx_controller/cart_controller.dart';
import 'package:shopping_cart/feature/presentation/getx_controller/product_controller.dart';
import 'package:shopping_cart/feature/presentation/screen/cart_screen.dart';
import 'package:shopping_cart/feature/presentation/screen/order_conformation_screen.dart';
import 'package:shopping_cart/feature/presentation/screen/product_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ProductModelAdapter());

  Box<ProductModel> cartBox = await Hive.openBox<ProductModel>('cartBox');

  final productRemoteDataSource = ProductRemoteDataSource();
  final productRepo = ProductRepositoryImpl(productRemoteDataSource);
  final getAllProductsUseCase = GetAllProductsUseCase(productRepo);

  Get.put(ProductController(getAllProductsUseCase));
  Get.put(CartController(cartLocalDataSource: CartLocalDataSource(cartBox)));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(1050, 2408),
      minTextAdapt: true,
      splitScreenMode: true,
      child: GetMaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        // home: ProductListScreen(),
        initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: () => ProductListScreen()),
          GetPage(name: '/cart', page: () => CartScreen()),
          GetPage(name: '/confirmation', page: () => OrderConfirmationScreen()),
        ],
      ),
    );
  }
}
