import 'dart:io';
import 'package:rxdart/rxdart.dart';

import 'package:feeling_cars_now/src/services/car_service.dart';
import 'package:feeling_cars_now/src/models/car_model.dart';
import 'package:feeling_cars_now/src/models/filter_model.dart';

class CarsBloc {
  final _carsController = new BehaviorSubject<List<CarModel>>();
  final _featuredCarsController = new BehaviorSubject<List<CarModel>>();
  final _filteredCarsController = new BehaviorSubject<List<CarModel>>();
  final _loadingController = new BehaviorSubject<bool>();

  final _carsService = new CarService();

  Stream<List<CarModel>> get carsStream => _carsController.stream;
  Stream<List<CarModel>> get featuredCarsStream =>
      _featuredCarsController.stream;
  Stream<List<CarModel>> get filteredCarsStream =>
      _filteredCarsController.stream;
  Stream<bool> get loading => _loadingController.stream;

  void loadCars() async {
    final cars = await _carsService.loadCars();
    _carsController.sink.add(cars);
  }

  void loadFeaturedCars() async {
    final featuredCars = await _carsService.loadFeaturedCars();
    _featuredCarsController.sink.add(featuredCars);
  }

  void loadFilteredCars(Filter filter) async {
    final filteredCars = await _carsService.loadFilteredCars(filter);
    _filteredCarsController.sink.add(filteredCars);
  }

  void addCar(CarModel car) async {
    _loadingController.sink.add(true);
    await _carsService.createCar(car);
    _loadingController.sink.add(false);
  }

  Future<String> uploadImage(File image) async {
    _loadingController.sink.add(true);
    final imageUrl = await _carsService.uploadImage(image);
    _loadingController.sink.add(false);

    return imageUrl;
  }

  void editCar(CarModel car) async {
    _loadingController.sink.add(true);
    await _carsService.editCar(car);
    _loadingController.sink.add(false);
  }

  void deleteCar(String id) async {
    await _carsService.deleteCar(id);
  }

  dispose() {
    _carsController?.close();
    _loadingController?.close();
    _featuredCarsController?.close();
    _filteredCarsController?.close();
  }
}
