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
      this.ownerEmail,
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
  String userId;
  String ownerEmail;
  String brand;
  String model;
  String category;
  String fuel;
  String photoUrl;
  String location;
  String description;
  int km;
  int price;
  int power;
  int year;
  bool featured;

  /// Mapea los datos de un json a un CarModel
  factory CarModel.fromJson(Map<String, dynamic> json) => CarModel(
      id: json["id"],
      brand: json["brand"],
      ownerEmail: json["ownerEmail"],
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

  /// Construye un json con los datos del CarModel.
  Map<String, dynamic> toJson() => {
        //"id": id, evitar duplicado de ID
        "brand": brand,
        "ownerEmail": ownerEmail,
        "category": category,
        "featured": featured,
        "fuel": fuel,
        "km": km,
        "power": power,
        "price": price,
        "model": model,
        "userID": userId,
        "year": year,
        "photoUrl": photoUrl,
        "description": description,
        "location": location
      };
}
