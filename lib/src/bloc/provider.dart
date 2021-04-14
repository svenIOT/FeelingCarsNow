import 'package:flutter/material.dart';

import 'car_bloc.dart';
import 'package:feeling_cars_now/src/bloc/login_bloc.dart';

class Provider extends InheritedWidget {
  final loginBloc = new LoginBloc();
  final _carsBloc = new CarsBloc();

  static Provider _instance;

  // Singleton para la persistencia con 1 única instancia
  factory Provider({Key key, Widget child}) {
    if (_instance == null) {
      _instance = new Provider._internal(key: key, child: child);
    }
    return _instance;
  }

  // Constructor privado
  Provider._internal({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;

  static LoginBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>().loginBloc;
  }

  static CarsBloc carsBloc(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>()._carsBloc;
  }
}
