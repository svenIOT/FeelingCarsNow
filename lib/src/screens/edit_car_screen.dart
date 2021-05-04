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

  _selectGaleryImage() async {
    setState(() {
      _processImage(ImageSource.gallery);
    });
  }

  _shootPhoto() async {
    setState(() {
      _processImage(ImageSource.camera);
    });
  }

  _processImage(ImageSource source) async {
    final pickedFile = await ImagePicker.pickImage(
      source: source,
    );

    // Si hay foto seleccionada la asigna en photo
    if (pickedFile != null) photo = File(pickedFile.path);

    // Elimina la foto del modelo para añadir posteriormente la seleccionada
    if (photo != null) return car.photoUrl == null;
  }
}
