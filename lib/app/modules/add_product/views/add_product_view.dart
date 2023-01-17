import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/add_product_controller.dart';

class AddProductView extends GetView<AddProductController> {
  final TextEditingController codeC = TextEditingController();
  final TextEditingController nameC = TextEditingController();
  final TextEditingController qtyC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: codeC,
            autocorrect: false,
            keyboardType: TextInputType.number,
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
                if (codeC.text.isNotEmpty &&
                    nameC.text.isNotEmpty &&
                    qtyC.text.isNotEmpty) {
                  controller.isLoading(true);
                  Map<String, dynamic> hasil = await controller.addProduct({
                    "code": codeC.text,
                    "name": nameC.text,
                    "qty": int.tryParse(qtyC.text) ?? 0,
                  });
                  controller.isLoading(false);

                  Get.back();

                  Get.snackbar(hasil["error"] == true ? "Error" : "Success",
                      hasil["message"]);
                } else {
                  Get.snackbar("Error", "Email dan password wajib diisi.");
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
              () => Text(
                  controller.isLoading.isFalse ? "Add Product" : "Loading..."),
            ),
          ),
        ],
      ),
    );
  }
}
