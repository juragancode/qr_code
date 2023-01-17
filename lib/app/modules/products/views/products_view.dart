import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code/app/data/models/product_model.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../routes/app_pages.dart';
import '../controllers/products_controller.dart';

class ProductsView extends GetView<ProductsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: controller.streamProduct(),
        builder: (context, snapProduct) {
          if (snapProduct.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapProduct.data!.docs.isEmpty) {
            return Center(
              child: Text("Tidak ada produk."),
            );
          }

          List<ProductModel> allProduct = [];

          for (var element in snapProduct.data!.docs) {
            allProduct.add(ProductModel.fromJson(element.data()));
          }
          return Padding(
            padding: const EdgeInsets.all(20),
            child: ListView.builder(
              itemCount: allProduct.length,
              itemBuilder: (BuildContext context, int index) {
                ProductModel product = allProduct[index];
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.only(bottom: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: InkWell(
                    onTap: () {
                      Get.toNamed(Routes.detailProduct);
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 100,
                      padding: EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.code,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8),
                                Text(product.name),
                                SizedBox(height: 4),
                                Text("Jumlah : ${product.qty}"),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 80,
                            width: 80,
                            child: QrImage(
                              data: "21231232445",
                              size: 200.0,
                              version: QrVersions.auto,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
