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

  /// Crea un coche a partir del modelo -> json, haciendo petición POST.
  ///
  /// Devuelve true (Future)
  Future<bool> createCar(CarModel car) async {
    final url = '$_url/cars.json?auth=${_prefs.token}';

    final response = await http.post(Uri.parse(url), body: carModelToJson(car));

    json.decode(response.body);

    return true;
  }

  /// Edita un coche a partir del modelo -> json, haciendo petición PUT.
  ///
  /// Devuelve true (Future)
  Future<bool> editCar(CarModel car) async {
    final url = '$_url/cars/${car.id}.json?auth=${_prefs.token}';

    final response = await http.put(Uri.parse(url), body: carModelToJson(car));

    json.decode(response.body);

    return true;
  }

  /// Carga todos los coches en una lista.
  ///
  /// Si hay errores devuelve una lista vacia (Future)
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

  /// Carga todos los coches y filtra los que están destacados.
  ///
  /// Devuelve una lista (Future)
  Future<List<CarModel>> loadFeaturedCars() async {
    final List<CarModel> cars = await loadCars();

    final List<CarModel> featuredCars =
        cars.where((car) => car.featured).toList();

    return featuredCars;
  }

  /// Carga todos los coches y los filtra según el modelo.
  ///
  /// Devuelve una lista (Future)
  Future<List<CarModel>> loadFilteredCars(Filter filter) async {
    final List<CarModel> cars = await loadCars();
    List<CarModel> filteredCars = [];

    // Si no hay filtros devuelve todos los coches
    if (_filterIsEmpty(filter)) return cars;

    // Filtrar por palabras clave
    if (filter.searchWords.isNotEmpty) {
      filteredCars = _filterBySearchWords(cars, filter.searchWords);
    }
    // TODO:
    // Filtrar por kilómetros
    /* if (filter.kmSince != null || filter.kmUntil != null) {
      if (filter.kmSince != 0 ||
          filter.kmUntil != 0 ||
          filter.kmUntil != 999999) {
        filteredCars = [..._filterByKm(cars, filter)];
      }
    } */
    //Filtrar por potencia
    /* if (filter.powerSince != null || filter.powerUntil != null) {
      if (filter.powerSince != 0 || filter.powerUntil != 0) {
        filteredCars = [..._filterByPower(cars, filter)];
      }
    } */
    // Filtrar por categoría y combustible

    return filteredCars;
  }

  /// Borra el coche por id.
  ///
  /// Devuelve true (Future)
  Future<bool> deleteCar(String id) async {
    final url = '$_url/cars/$id.json?auth=${_prefs.token}';
    await http.delete(Uri.parse(url));

    return true;
  }

  /// Sube la imagen a cloudinary.
  ///
  /// Devuelve la url de la imagen subida a cloudinary o null si hubo un error (Future).
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

  /// Comprueba si los valores del filtro son usados o están por defecto.
  bool _filterIsEmpty(Filter filter) => filter.searchWords.isEmpty &&
              filter.category == null &&
              filter.fuel == null &&
              filter.kmSince == 0 &&
              filter.kmUntil == 0 ||
          filter.kmUntil == 999999 &&
              filter.powerSince == 0 &&
              filter.powerUntil == 0 ||
          filter.powerUntil == 9999 &&
              filter.priceSince == 0 &&
              filter.priceUntil == 0 ||
          filter.priceUntil == 9999
      ? true
      : false;

  /// Filtra los coches de la lista por marca o modelo.
  ///
  /// Devuelve una lista.
  List<CarModel> _filterBySearchWords(List<CarModel> cars, String searchWords) {
    return cars
        .where((car) =>
            car.brand.toLowerCase().contains(searchWords.toLowerCase()) ||
            car.model.toLowerCase().contains(searchWords.toLowerCase()))
        .toList();
  }

  /// Filtra los coches de la lista por kilómetros. Si los kilometros máximos son 0, no hay máximo
  /// y si los kilómetros mínimos son mayores que los máximos, no hay mímino.
  ///
  /// Devuelve una lista.
  List<CarModel> _filterByKm(List<CarModel> cars, Filter filter) =>
      cars.where((car) {
        if (filter.kmUntil == 0) filter.kmUntil = 999999;
        if (filter.kmSince > filter.kmUntil) filter.kmSince = 0;
        return car.km >= filter.kmSince && car.km <= filter.kmUntil;
      }).toList();
}

/// Filtra los coches de la lista por potencia. Si la potencia máxima es 0, no hay máximo
/// y si la potencia mínima es mayor que el máximo, no hay mímino.
///
/// Devuelve una lista.
List<CarModel> _filterByPower(List<CarModel> cars, Filter filter) =>
    cars.where((car) {
      if (filter.powerUntil == 0) filter.powerUntil = 9999;
      if (filter.powerSince > filter.powerUntil) filter.powerSince = 0;
      return car.power >= filter.powerSince && car.power <= filter.powerUntil;
    }).toList();
