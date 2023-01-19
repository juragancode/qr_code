import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'package:get/get.dart';
import 'package:qr_code/app/controllers/auth_controller.dart';
import 'package:qr_code/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final AuthController authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
      ),
      body: GridView.builder(
        itemCount: 4,
        padding: EdgeInsets.all(20),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
        ),
        itemBuilder: (context, index) {
          late String title;
          late IconData icon;
          late VoidCallback onTap;

          switch (index) {
            case 0:
              title = "Add Product";
              icon = Icons.post_add_sharp;
              onTap = () => Get.toNamed(Routes.addProduct);
              break;
            case 1:
              title = "Product";
              icon = Icons.list_alt_sharp;
              onTap = () => Get.toNamed(Routes.products);
              break;
            case 2:
              title = "QR Code";
              icon = Icons.qr_code_2_sharp;
              onTap = () async {
                // scan QR Code
                String barcode = await FlutterBarcodeScanner.scanBarcode(
                  "#FF0000",
                  "Kembali",
                  true,
                  ScanMode.QR,
                );

                // Get data dari firebase search by product code
                Map<String, dynamic> hasil =
                    await controller.getProductById(barcode);
                if (hasil["error"] == false) {
                  Get.toNamed(Routes.detailProduct, arguments: hasil["data"]);
                } else {
                  Get.snackbar(
                    "error",
                    hasil["message"],
                    duration: Duration(seconds: 2),
                  );
                }
              };
              break;
            case 3:
              title = "Catalog";
              icon = Icons.document_scanner_outlined;
              onTap = () {
                controller.downloadCatalog();
              };
              break;
            default:
          }

          return Material(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: Icon(
                      icon,
                      size: 60,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(title),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Map<String, dynamic> hasil = await authC.logout();
          if (hasil["error"] == false) {
            Get.offAllNamed(Routes.login);
          }
        },
        child: Icon(Icons.logout_sharp),
      ),
    );
  }
}
