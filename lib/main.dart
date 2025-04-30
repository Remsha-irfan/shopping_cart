import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shopping_cart/core/routes/app_pages.dart';
import 'package:shopping_cart/core/routes/app_routes.dart';
import 'package:shopping_cart/feature/data/data_source/cart_local_datasource.dart';
import 'package:shopping_cart/feature/data/data_source/product_data_source.dart';
import 'package:shopping_cart/feature/data/model/product_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shopping_cart/feature/domain/repository_impl/cart_impl.dart/cart_repo_impl.dart';
import 'package:shopping_cart/feature/domain/repository_impl/product_repo_impl/product_repo_impl.dart';
import 'package:shopping_cart/feature/domain/usecase/get_all_product_usecase.dart';
import 'package:shopping_cart/feature/presentation/getx_controller/cart_controller.dart';
import 'package:shopping_cart/feature/presentation/getx_controller/product_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ProductModelAdapter());
  Box<ProductModel> cartBox = await Hive.openBox<ProductModel>('cartBox');

  final productRemoteDataSource = ProductRemoteDataSource();
  final productRepo = ProductRepositoryImpl(productRemoteDataSource);
  final cartLocalDataSource = CartLocalDataSource(cartBox);
  final getAllProductsUseCase = GetAllProductsUseCase(productRepo);
  final cartRepo = CartRepositoryImpl(cartLocalDataSource);

  Get.put(ProductController(getAllProductsUseCase));
  Get.put(CartController(cartRepository: cartRepo));
  runApp(DevicePreview(enabled: !kReleaseMode, builder: (context) => MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return ScreenUtilInit(
      designSize: Size(1050, 2408),
      minTextAdapt: true,
      splitScreenMode: true,
      child: GetMaterialApp(
        title: 'Shopping Cart',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        // home: ProductListScreen(),
        initialRoute: AppRoutes.home,
        getPages: AppPages.routes,
      ),
    );
  }
}
