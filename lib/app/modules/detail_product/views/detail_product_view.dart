import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:get/get.dart';
import 'package:qr_code/app/data/models/product_model.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../controllers/detail_product_controller.dart';

class DetailProductView extends GetView<DetailProductController> {
  final ProductModel product = Get.arguments;
  final TextEditingController codeC = TextEditingController();
  final TextEditingController nameC = TextEditingController();
  final TextEditingController qtyC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    codeC.text = product.code;
    nameC.text = product.name;
    qtyC.text = "${product.qty}";
    // qtyC.text = product.qty.toString();

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Product'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // kalau Container() hanya berisi ukuran lebih baik gunakan SizedBox()
              SizedBox(
                height: 250,
                width: 250,
                child: QrImage(
                  data: "21231232445",
                  size: 250.0,
                  version: QrVersions.auto,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          TextField(
            controller: codeC,
            autocorrect: false,
            keyboardType: TextInputType.number,
            readOnly: true,
            maxLength: 10,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: "product code",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: 5),
          TextField(
            controller: nameC,
            autocorrect: false,
            // keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: "product name",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: 25),
          TextField(
            controller: qtyC,
            autocorrect: false,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: "product quantity",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: 25),
          ElevatedButton(
            onPressed: () async {
              if (controller.isLoading.isFalse) {
                if (nameC.text.isNotEmpty && qtyC.text.isNotEmpty) {
                  controller.isLoading(true);
                  Map<String, dynamic> hasil = await controller.updateProduct({
                    "id": product.productId,
                    "name": nameC.text,
                    "qty": int.tryParse(qtyC.text) ?? 0,
                  });
                  controller.isLoading(false);

                  Get.back();

                  Get.snackbar(
                    hasil["error"] == true ? "Error" : "Success",
                    hasil["message"],
                    duration: Duration(seconds: 2),
                  );
                } else {
                  Get.snackbar(
                    "Error",
                    "Semua data wajib diisi.",
                    duration: Duration(seconds: 2),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Obx(
              () => Text(controller.isLoading.isFalse
                  ? "Update Produk"
                  : "Loading..."),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.defaultDialog(
                title: "Peringatan",
                middleText: "Kamu yakin ingin menghapus produk?",
                actions: [
                  OutlinedButton(
                    onPressed: () async {
                      controller.isLoadingDelete(true);
                      // Untuk test delay loading indicator
                      // await Future.delayed(Duration(seconds: 2));
                      Map<String, dynamic> hasil =
                          await controller.deleteProduct(product.productId);
                      controller.isLoadingDelete(false);

                      Get.back(); // tutup dialog
                      Get.back(); // kembali ke page all product

                      Get.snackbar(
                        hasil["error"] == true ? "Error" : "Success",
                        hasil["message"],
                        duration: Duration(seconds: 2),
                      );
                    },
                    child: Obx(
                      () => controller.isLoadingDelete.isFalse
                          ? Text("Hapus")
                          : Container(
                              height: 30,
                              width: 40,
                              child: SpinKitThreeBounce(
                                color: Colors.blue,
                                size: 20.0,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(width: 5),
                  ElevatedButton(
                    onPressed: () => Get.back(),
                    child: Text("Batal"),
                  ),
                ],
              );
            },
            child: Text(
              "Hapus Produk",
              style: TextStyle(
                  // color: Colors.redAccent,
                  ),
            ),
          )
        ],
      ),
    );
  }
}
