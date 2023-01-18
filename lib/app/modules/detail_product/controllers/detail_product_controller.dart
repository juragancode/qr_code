import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class DetailProductController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoadingDelete = false.obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> updateProduct(Map<String, dynamic> data) async {
    try {
      await firestore.collection("product").doc(data["id"]).update({
        "name": data["name"],
        "qty": data["qty"],
      });

      return {
        "error": false,
        "message": "Berhasil memperbarui produk",
      };
    } catch (e) {
      // error general

      return {
        "error": true,
        "message": "Tidak dapat memperbarui produk",
      };
    }
  }

  Future<Map<String, dynamic>> deleteProduct(String id) async {
    try {
      await firestore.collection("product").doc(id).delete();

      return {
        "error": false,
        "message": "Berhasil menghapus produk",
      };
    } catch (e) {
      // error general

      return {
        "error": true,
        "message": "Tidak dapat menghapus produk",
      };
    }
  }
}
