import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:feeling_cars_now/src/bloc/car_bloc.dart';
import 'package:feeling_cars_now/src/bloc/provider.dart';
import 'package:feeling_cars_now/src/models/car_model.dart';
import 'package:feeling_cars_now/src/widgets/car_form.dart';

class EditCarPage extends StatefulWidget {
  @override
  _EditCarPageState createState() => _EditCarPageState();
}

class _EditCarPageState extends State<EditCarPage> {
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
          child: CarForm(),
        ),
      ),
      floatingActionButton: _createFloatingActionButton(context),
    );
  }

  Widget _createFloatingActionButton(BuildContext context) =>
      FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
        onPressed: () => Navigator.pushNamed(context, 'car'),
      );

  void showSnackBar(String message) {
    final snackbar = SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: 1750),
    );

    scaffoldKey.currentState.showSnackBar(snackbar);
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
    final pickedFile = await ImagePicker().getImage(
      source: source,
    );

    photo = File(pickedFile.path);

    if (photo != null) return car.photoUrl == null;
  }
}
