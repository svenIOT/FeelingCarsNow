import 'dart:io';
import 'package:rxdart/rxdart.dart';

import 'package:feeling_cars_now/src/services/car_service.dart';
import 'package:feeling_cars_now/src/models/car_model.dart';
import 'package:feeling_cars_now/src/models/filter_model.dart';

class CarsBloc {
  final _carsController = new BehaviorSubject<List<CarModel>>();
  final _featuredCarsController = new BehaviorSubject<List<CarModel>>();
  final _filteredCarsController = new BehaviorSubject<List<CarModel>>();
  final _userCarsController = new BehaviorSubject<List<CarModel>>();
  final _loadingController = new BehaviorSubject<bool>();

  final _carsService = new CarService();

  // Get Streams
  Stream<List<CarModel>> get carsStream => _carsController.stream;
  Stream<List<CarModel>> get featuredCarsStream =>
      _featuredCarsController.stream;
  Stream<List<CarModel>> get filteredCarsStream =>
      _filteredCarsController.stream;
  Stream<List<CarModel>> get userCarsStream => _userCarsController.stream;
  Stream<bool> get loading => _loadingController.stream;

  /// LLama al método del CarService para añadir todos los coches
  /// y los añade al Stream.
  void loadCars() async {
    final cars = await _carsService.loadCars();
    _carsController.sink.add(cars);
  }

  /// LLama al método del CarService para añadir los coches destacados
  /// y los añade al Stream.
  void loadFeaturedCars() async {
    final featuredCars = await _carsService.loadFeaturedCars();
    _featuredCarsController.sink.add(featuredCars);
  }

  /// LLama al método del CarService para añadir los coches según el filtro
  /// y los añade al Stream.
  void loadFilteredCars(Filter filter) async {
    final filteredCars = await _carsService.loadFilteredCars(filter);
    _filteredCarsController.sink.add(filteredCars);
  }

  /// LLama al método del CarService para añadir los coches del usuario por ID
  /// y los añade al Stream.
  void loadUserCars(String userId) async {
    final userCars = await _carsService.loadUserCars(userId);
    _userCarsController.sink.add(userCars);
  }

  /// LLama al método del CarService para añadir un coche.
  ///
  /// Pone el Stream de cargando a true mientras dure la operación.
  void addCar(CarModel car) async {
    _loadingController.sink.add(true);
    await _carsService.createCar(car);
    _loadingController.sink.add(false);
  }

  /// LLama al método del CarService para subir una imagen a cloudinary.
  ///
  /// Pone el Stream de cargando a true mientras dure la operación.
  Future<String> uploadImage(File image) async {
    _loadingController.sink.add(true);
    final imageUrl = await _carsService.uploadImage(image);
    _loadingController.sink.add(false);

    return imageUrl;
  }

  /// LLama al método del CarService para editar un coche.
  ///
  /// Pone el Stream de cargando a true mientras dure la operación.
  void editCar(CarModel car) async {
    _loadingController.sink.add(true);
    await _carsService.editCar(car);
    _loadingController.sink.add(false);
  }

  /// LLama al método del CarService para borrar un coche.
  ///
  /// Pone el Stream de cargando a true mientras dure la operación.
  void deleteCar(String id) async {
    await _carsService.deleteCar(id);
  }

  /// Cierra todos los Streams.
  dispose() {
    _carsController?.close();
    _loadingController?.close();
    _featuredCarsController?.close();
    _filteredCarsController?.close();
    _userCarsController?.close();
  }
}
