// To parse this JSON data, do final carModel = carModelFromJson(jsonString);

import 'dart:convert';

CarModel carModelFromJson(String str) => CarModel.fromJson(json.decode(str));

String carModelToJson(CarModel data) => json.encode(data.toJson());

class CarModel {
  CarModel({
    this.id,
    this.brand,
    this.category,
    this.fuel,
    this.km,
    this.price,
    this.model,
    this.userId,
    this.year,
    this.photoUrl,
  });

  String id;
  String brand;
  String category;
  String fuel;
  int km;
  int price;
  String model;
  String userId;
  int year;
  String photoUrl;

  factory CarModel.fromJson(Map<String, dynamic> json) => CarModel(
        id: json["id"],
        brand: json["brand"],
        category: json["category"],
        fuel: json["fuel"],
        km: json["km"],
        price: json["price"],
        model: json["model"],
        userId: json["userID"],
        year: json["year"],
        photoUrl: json["photoUrl"],
      );

  Map<String, dynamic> toJson() => {
        //"id": id, evitar duplicado de ID
        "brand": brand,
        "category": category,
        "fuel": fuel,
        "km": km,
        "price": price,
        "model": model,
        "userID": userId,
        "photoUrl": photoUrl
      };
}
