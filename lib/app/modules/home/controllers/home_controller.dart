import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:qr_code/app/data/models/product_model.dart'; // alias agar tidak bentrok element yang diambil dari package

class HomeController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  RxList<ProductModel> allProducts = List<ProductModel>.empty().obs;

  void downloadCatalog() async {
    final pdf = pw.Document();

    // nama collection di FirebaseFirestore product
    var getData = await firestore.collection("product").get();

    // reset allProducts -> untuk mengatasi duplikat
    allProducts([]);

    // isi data allProducts from database
    for (var element in getData.docs) {
      allProducts.add(
        ProductModel.fromJson(
          element.data(),
        ),
      );
    }
    // font
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          // Isi Data
          List<pw.TableRow> allData = List.generate(
            allProducts.length,
            (index) {
              ProductModel product = allProducts[index];
              return pw.TableRow(
                children: [
                  // No
                  pw.Padding(
                    padding: pw.EdgeInsets.all(20),
                    child: pw.Text(
                      "${index + 1}",
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                  // Code Product
                  pw.Padding(
                    padding: pw.EdgeInsets.all(20),
                    child: pw.Text(
                      product.code,
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                  // Name Product
                  pw.Padding(
                    padding: pw.EdgeInsets.all(20),
                    child: pw.Text(
                      product.name,
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                  // qty
                  pw.Padding(
                    padding: pw.EdgeInsets.all(20),
                    child: pw.Text(
                      '${product.qty}',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                  // QR Code
                  pw.Padding(
                    padding: pw.EdgeInsets.all(20),
                    child: pw.BarcodeWidget(
                      color: PdfColor.fromHex("#000000"),
                      barcode: pw.Barcode.qrCode(),
                      data: product.code,
                      height: 50,
                      width: 50,
                    ),
                  ),
                ],
              );
            },
          );

          return [
            pw.Center(
              child: pw.Text(
                "Product Catalog",
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Table(
              border: pw.TableBorder.all(
                color: PdfColor.fromHex("#000000"),
                width: 2,
              ),
              children: [
                pw.TableRow(
                  children: [
                    // No
                    pw.Padding(
                      padding: pw.EdgeInsets.all(20),
                      child: pw.Text(
                        "No",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    // Code Product
                    pw.Padding(
                      padding: pw.EdgeInsets.all(20),
                      child: pw.Text(
                        "Product Code",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    // Name Product
                    pw.Padding(
                      padding: pw.EdgeInsets.all(20),
                      child: pw.Text(
                        "Name",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    // qty
                    pw.Padding(
                      padding: pw.EdgeInsets.all(20),
                      child: pw.Text(
                        "Quantity",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    // QR Code
                    pw.Padding(
                      padding: pw.EdgeInsets.all(20),
                      child: pw.Text(
                        "QR Code",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                // Isi Data
                ...allData,
              ],
            ),
          ];
        },
      ),
    );

    // Save
    Uint8List bytes = await pdf.save();

    // Create file kosong in directory
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/catalog-QR-Code.pdf');

    // memasukan data bytes -> file kosong
    await file.writeAsBytes(bytes);

    //open PDF
    await OpenFile.open(file.path);
  }

  Future<Map<String, dynamic>> getProductById(String codeBarang) async {
    try {
      var hasil = await firestore
          .collection("product")
          .where("code", isEqualTo: codeBarang)
          .get();

      if (hasil.docs.isEmpty) {
        return {
          "error": true,
          "message": "Tidak ada product ini di database.",
        };
      }

      Map<String, dynamic> data = hasil.docs.first.data();

      return {
        "error": false,
        "message": "Berhasil mendapatkan detail product dari product code ini.",
        "data": ProductModel.fromJson(data),
      };
    } catch (e) {
      return {
        "error": true,
        "message": "Tidak mendapatkan detail product dari product code ini.",
      };
    }
  }
}
