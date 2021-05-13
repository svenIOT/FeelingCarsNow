// To parse this JSON data, do final carModel = carModelFromJson(jsonString);

import 'dart:convert';

CarModel carModelFromJson(String str) => CarModel.fromJson(json.decode(str));

String carModelToJson(CarModel data) => json.encode(data.toJson());

class CarModel {
  CarModel(
      {this.id,
      this.brand,
      this.category,
      this.featured = false, // Por defecto los coches no están destacados
      this.fuel,
      this.km,
      this.price,
      this.power,
      this.model,
      this.userId,
      this.year,
      this.photoUrl,
      this.description,
      this.location});

  String id;
  String brand;
  String category;
  bool featured;
  String fuel;
  int km;
  int price;
  int power;
  String model;
  String userId;
  int year;
  String photoUrl;
  String description;
  String location;

  factory CarModel.fromJson(Map<String, dynamic> json) => CarModel(
      id: json["id"],
      brand: json["brand"],
      category: json["category"],
      featured: json["featured"],
      fuel: json["fuel"],
      km: json["km"],
      power: json["power"],
      price: json["price"],
      model: json["model"],
      userId: json["userID"],
      year: json["year"],
      photoUrl: json["photoUrl"],
      description: json["description"],
      location: json["location"]);

  Map<String, dynamic> toJson() => {
        //"id": id, evitar duplicado de ID
        "brand": brand,
        "category": category,
        "featured": featured,
        "fuel": fuel,
        "km": km,
        "power": power,
        "price": price,
        "model": model,
        "userID": userId,
        "photoUrl": photoUrl,
        "description": description,
        "location": location
      };
}
