import 'package:get/get.dart';

import 'package:qr_code/app/modules/add_product/bindings/add_product_binding.dart';
import 'package:qr_code/app/modules/add_product/views/add_product_view.dart';
import 'package:qr_code/app/modules/detail_product/bindings/detail_product_binding.dart';
import 'package:qr_code/app/modules/detail_product/views/detail_product_view.dart';
import 'package:qr_code/app/modules/home/bindings/home_binding.dart';
import 'package:qr_code/app/modules/home/views/home_view.dart';
import 'package:qr_code/app/modules/login/bindings/login_binding.dart';
import 'package:qr_code/app/modules/login/views/login_view.dart';
import 'package:qr_code/app/modules/products/bindings/products_binding.dart';
import 'package:qr_code/app/modules/products/views/products_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static final routes = [
    GetPage(
      name: _Paths.home,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.login,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.addProduct,
      page: () => AddProductView(),
      binding: AddProductBinding(),
    ),
    GetPage(
      name: _Paths.products,
      page: () => ProductsView(),
      binding: ProductsBinding(),
    ),
    GetPage(
      name: _Paths.detailProduct,
      page: () => DetailProductView(),
      binding: DetailProductBinding(),
    ),
  ];
}
