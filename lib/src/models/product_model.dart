// To parse this JSON data, do final productModel = productModelFromJson(jsonString);

import 'dart:convert';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  ProductModel({
    this.id,
    this.title = '',
    this.value = 0.0,
    this.available = true,
    this.photoUrl,
  });

  String id;
  String title;
  double value;
  bool available;
  String photoUrl;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        title: json["title"],
        value: json["value"],
        available: json["available"],
        photoUrl: json["photoUrl"],
      );

  Map<String, dynamic> toJson() => {
        //"id": id, evitar duplicado de ID
        "title": title,
        "value": value,
        "available": available,
        "photoUrl": photoUrl,
      };
}
