import 'dart:io';
import 'package:rxdart/rxdart.dart';

import 'package:feeling_cars_now/src/providers/car_provider.dart';
import 'package:feeling_cars_now/src/models/car_model.dart';

class CarsBloc {
  final _carsController = new BehaviorSubject<List<CarModel>>();
  final _featuredCarsController = new BehaviorSubject<List<CarModel>>();
  final _loadingController = new BehaviorSubject<bool>();

  final _carsProvider = new CarProvider();

  Stream<List<CarModel>> get carsStream => _carsController.stream;
  Stream<List<CarModel>> get featuredCarsStream =>
      _featuredCarsController.stream;
  Stream<bool> get loading => _loadingController.stream;

  void loadCars() async {
    final cars = await _carsProvider.loadCars();
    _carsController.sink.add(cars);
  }

  void loadFeaturedCars() async {
    final featuredCars = await _carsProvider.loadFeaturedCars();
    _featuredCarsController.sink.add(featuredCars);
  }

  void addCar(CarModel car) async {
    _loadingController.sink.add(true);
    await _carsProvider.createCar(car);
    _loadingController.sink.add(false);
  }

  Future<String> uploadImage(File image) async {
    _loadingController.sink.add(true);
    final imageUrl = await _carsProvider.uploadImage(image);
    _loadingController.sink.add(false);

    return imageUrl;
  }

  void editCar(CarModel car) async {
    _loadingController.sink.add(true);
    await _carsProvider.editCar(car);
    _loadingController.sink.add(false);
  }

  void deleteCar(String id) async {
    await _carsProvider.deleteCar(id);
  }

  dispose() {
    _carsController?.close();
    _loadingController?.close();
    _featuredCarsController?.close();
  }
}
