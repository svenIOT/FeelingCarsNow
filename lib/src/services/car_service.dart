import 'dart:convert';
import 'dart:io';

import 'package:feeling_cars_now/src/models/car_model.dart';
import 'package:feeling_cars_now/src/models/filter_model.dart';
import 'package:feeling_cars_now/src/user_preferences/user_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';

class CarService {
  final _url =
      'https://flutter-varios-db270-default-rtdb.europe-west1.firebasedatabase.app';
  final _prefs = new UserPreferences();

  Future<bool> createCar(CarModel car) async {
    final url = '$_url/cars.json?auth=${_prefs.token}';

    final response = await http.post(Uri.parse(url), body: carModelToJson(car));

    json.decode(response.body);

    return true;
  }

  Future<bool> editCar(CarModel car) async {
    final url = '$_url/cars/${car.id}.json?auth=${_prefs.token}';

    final response = await http.put(Uri.parse(url), body: carModelToJson(car));

    json.decode(response.body);

    return true;
  }

  Future<List<CarModel>> loadCars() async {
    final url = '$_url/cars.json?auth=${_prefs.token}';

    final response = await http.get(Uri.parse(url));

    final List<CarModel> cars = [];
    final Map<String, dynamic> decodedData = json.decode(response.body);

    if (decodedData == null || decodedData['error'] != null) return [];

    decodedData.forEach((key, car) {
      final tempCar = CarModel.fromJson(car);
      tempCar.id = key;

      cars.add(tempCar);
    });

    return cars;
  }

  Future<List<CarModel>> loadFeaturedCars() async {
    final List<CarModel> cars = await loadCars();

    final List<CarModel> featuredCars =
        cars.where((car) => car.featured).toList();

    return featuredCars;
  }

  Future<List<CarModel>> loadFilteredCars(Filter filter) async {
    final List<CarModel> cars = await loadCars();
    List<CarModel> filteredKmCars = [];
    List<CarModel> filteredPowerCars = [];
    List<CarModel> filteredCategoryCars = [];
    List<CarModel> filteredSearchWordsCars = [];

    // Si no hay filtros devuelve todos los coches
    if (filter.searchWords.isEmpty &&
            filter.category == null &&
            filter.fuel == null &&
            filter.kmSince == 0 &&
            filter.kmUntil == 999999 ||
        filter.kmUntil == 0 && filter.powerSince == 0 ||
        filter.powerUntil == 0 && filter.powerUntil == 9999) return cars;

    // Filtrar por palabras clave
    if (filter.searchWords.isNotEmpty) {
      filteredSearchWordsCars = cars.where((car) {
        final String searchWords = filter.searchWords;
        return car.brand.toLowerCase().contains(searchWords.toLowerCase()) ||
            car.model.toLowerCase().contains(searchWords.toLowerCase());
      }).toList();
    }
    // TODO: awful things
    // Filtrar por kilómetros y potencia
    //if (filter.kmSince != null || filter.kmUntil != null) {
    /* if (filter.kmUntil != 0) {
      filteredKmCars = cars.where((car) {
        return car.km >= filter.kmSince && car.km <= filter.kmUntil;
      }).toList();
    } */
    //}
    //if (filter.powerSince != null || filter.powerUntil != null) {
    /* if (filter.powerSince != 0 || filter.powerUntil != 0) {
      filteredPowerCars = cars.where((car) {
        return car.power >= filter.powerSince && car.km <= filter.powerUntil;
      }).toList();
    } */
    //}
    // Filtrar por categoría y combustible

    List<CarModel> filteredCars = [
      ...filteredSearchWordsCars,
      ...filteredCategoryCars,
      ...filteredPowerCars,
      ...filteredKmCars
    ];
    return filteredCars;
  }

  Future<bool> deleteCar(String id) async {
    final url = '$_url/cars/$id.json?auth=${_prefs.token}';
    await http.delete(Uri.parse(url));

    return true;
  }

  Future<String> uploadImage(File image) async {
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/dy9jm2gzn/image/upload?upload_preset=jximwwvv');
    final mimeType = mime(image.path).split('/');

    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file = await http.MultipartFile.fromPath('file', image.path,
        contentType: MediaType(mimeType[0], mimeType[1]));

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('Hubo un error ${resp.body}');
      return null;
    }

    final respData = json.decode(resp.body);
    return respData['secure_url'];
  }
}
