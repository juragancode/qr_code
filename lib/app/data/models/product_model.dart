class ProductModel {
  ProductModel({
    required this.code,
    required this.name,
    required this.productId,
    required this.qty,
  });

  String code;
  String name;
  String productId;
  int qty;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        code: json["code"] ?? "",
        name: json["name"] ?? "",
        productId: json["product_id"] ?? "",
        qty: json["qty"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
        "product_id": productId,
        "qty": qty,
      };
}
