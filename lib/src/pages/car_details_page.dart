import 'dart:io';
import 'package:flutter/material.dart';

import 'package:feeling_cars_now/src/bloc/car_bloc.dart';
import 'package:feeling_cars_now/src/bloc/provider.dart';
import 'package:feeling_cars_now/src/models/car_model.dart';

class CarDetailsPage extends StatefulWidget {
  @override
  _CarDetailsPageState createState() => _CarDetailsPageState();
}

class _CarDetailsPageState extends State<CarDetailsPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  CarsBloc carsBloc;
  CarModel car = new CarModel();
  File photo;

  @override
  Widget build(BuildContext context) {
    carsBloc = Provider.carsBloc(context);
    final CarModel argumentCar = ModalRoute.of(context).settings.arguments;
    if (argumentCar != null) car = argumentCar;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Detalles'),
        actions: <Widget>[
          // TODO: si el usuario es el propietario del anuncio habilitar botón editar
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                _showCarImage(),
                _carBrand(),
                _carPrice(),
                _createMessageButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _carBrand() {
    return Container();
  }

  Widget _carPrice() {
    return Container();
  }

  Widget _createMessageButton() {
    return FloatingActionButton(
      child: Icon(Icons.messenger),
      tooltip: 'Inicia una conversación con el vendedor',
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: _submit,
    );
  }

  void _submit() async {}

  _showCarImage() => car.photoUrl != null
      ? Container(
          margin: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          child: FadeInImage(
            image: NetworkImage(car.photoUrl),
            placeholder: AssetImage('assets/img/jar-loading.gif'),
            height: 300.0,
            fit: BoxFit.cover,
          ),
        )
      : Container(
          margin: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          child: Image(
            // Si la foto.path es null escoje la imagen de assets
            image: AssetImage(photo?.path ?? 'assets/img/no-image.png'),
            height: 300.0,
            fit: BoxFit.cover,
          ),
        );
}
