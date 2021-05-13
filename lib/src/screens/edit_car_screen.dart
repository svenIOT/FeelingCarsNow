import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:feeling_cars_now/src/bloc/car_bloc.dart';
import 'package:feeling_cars_now/src/bloc/provider.dart';
import 'package:feeling_cars_now/src/models/car_model.dart';
import 'package:feeling_cars_now/src/widgets/car_form.dart';

class EditCarScreen extends StatefulWidget {
  @override
  _EditCarScreenState createState() => _EditCarScreenState();
}

class _EditCarScreenState extends State<EditCarScreen> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  CarsBloc carsBloc;
  CarModel car = new CarModel();
  File photo;

  @override
  Widget build(BuildContext context) {
    carsBloc = Provider.carsBloc(context);

    // Si se le pasa un coche desde el padre lo guarda en car (es editar coche)
    final CarModel argumentCar = ModalRoute.of(context).settings.arguments;
    if (argumentCar != null) car = argumentCar;

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Coche'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: _selectGaleryImage,
          ),
          SizedBox(width: 10.0),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: _shootPhoto,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: CarForm(
            formKey: formKey,
            car: car,
            carsBloc: carsBloc,
            photo: photo,
          ),
        ),
      ),
    );
  }

  /// Abre la galería para seleccionar una imagen.
  _selectGaleryImage() async {
    _processImage(ImageSource.gallery);
  }

  /// Abre la cámara principal para realizar una foto.
  _shootPhoto() async {
    _processImage(ImageSource.camera);
  }

  /// Coge la imagen seleccionada y la asigna a una variable para posteriormente
  /// subirla a cloudinary.
  _processImage(ImageSource source) async {
    final pickedFile = await ImagePicker.pickImage(
      source: source,
    );

    // Si hay foto seleccionada la asigna en photo y redibuja
    if (pickedFile != null) {
      photo = File(pickedFile.path);
      setState(() {});
    }

    // Elimina la foto actual para añadir la seleccionada
    if (photo != null) return car.photoUrl = null;
  }
}
