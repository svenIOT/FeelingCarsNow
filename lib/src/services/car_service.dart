import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';

import 'package:feeling_cars_now/src/models/car_model.dart';
import 'package:feeling_cars_now/src/models/filter_model.dart';
import 'package:feeling_cars_now/src/user_preferences/user_preferences.dart';

class CarService {
  final _url =
      'https://flutter-varios-db270-default-rtdb.europe-west1.firebasedatabase.app';
  final _prefs = new UserPreferences();

  /// Crea un coche a partir del modelo -> json, haciendo petición POST.
  ///
  /// Devuelve true (Future).
  Future<bool> createCar(CarModel car) async {
    final url = '$_url/cars.json?auth=${_prefs.token}';

    final response = await http.post(Uri.parse(url), body: carModelToJson(car));

    json.decode(response.body);

    return true;
  }

  /// Edita un coche a partir del modelo -> json, haciendo petición PUT.
  ///
  /// Devuelve true (Future).
  Future<bool> editCar(CarModel car) async {
    final url = '$_url/cars/${car.id}.json?auth=${_prefs.token}';

    final response = await http.put(Uri.parse(url), body: carModelToJson(car));

    json.decode(response.body);

    return true;
  }

  /// Carga todos los coches en una lista.
  ///
  /// Si hay errores devuelve una lista vacia (Future).
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
  /// Devuelve una lista (Future).
  Future<List<CarModel>> loadFeaturedCars() async {
    final List<CarModel> cars = await loadCars();

    final List<CarModel> featuredCars =
        cars.where((car) => car.featured).toList();

    return featuredCars;
  }

  /// Carga todos los coches y los filtra según los filtros seleccionados.
  ///
  /// Devuelve una lista (Future).
  Future<List<CarModel>> loadFilteredCars(Filter filter) async {
    final List<CarModel> cars = await loadCars();
    filter.filteredCars = cars;

    // Si no hay filtros devuelve todos los coches
    if (_filterIsEmpty(filter)) return cars;

    Set<Map<String, dynamic>> selectedFilterActions = {
      {
        "searchWord": filter.searchWordFilterExist(),
        "action": filter.filterBySearchWords(),
      },
      {
        "category": filter.categoryFilterExist(),
        "action": filter.filterByCategory(),
      },
      {
        "fuel": filter.fuelFilterExist(),
        "action": filter.filterByFuel(),
      },
      {
        "km": filter.kmFilterExist(),
        "action": filter.filterByKm(),
      },
      {
        "power": filter.powerFilterExist(),
        "action": filter.filterByPower(),
      },
      {
        "price": filter.priceFilterExist(),
        "action": filter.filterByPrice(),
      },
    };

    selectedFilterActions.forEach((element) {
      if (element.containsValue(true))
        filter.filteredCars = [...element.values.last];
    });

    return filter.filteredCars;
  }

  /// Carga todos los coches y los filtra según el ID de usuario.
  ///
  /// Devuelve una lista (Future).
  Future<List<CarModel>> loadUserCars(String _userId) async {
    final List<CarModel> cars = await loadCars();
    List<CarModel> userCars = [];

    userCars = cars.where((car) => car.userId == _userId).toList();

    return userCars;
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
  bool _filterIsEmpty(Filter filter) => !filter.searchWordFilterExist() &&
          !filter.categoryFilterExist() &&
          !filter.fuelFilterExist() &&
          !filter.kmFilterExist() &&
          !filter.powerFilterExist() &&
          !filter.priceFilterExist()
      ? true
      : false;
}
