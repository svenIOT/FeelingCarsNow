import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:feeling_cars_now/src/bloc/car_bloc.dart';
import 'package:feeling_cars_now/src/bloc/provider.dart';
import 'package:feeling_cars_now/src/models/car_model.dart';
import 'package:feeling_cars_now/src/utils/utils.dart' as utils;

class EditCarPage extends StatefulWidget {
  @override
  _EditCarPageState createState() => _EditCarPageState();
}

class _EditCarPageState extends State<EditCarPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  CarsBloc carsBloc;
  CarModel car = new CarModel();
  bool _isSaving = false;
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
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                _showImage(),
                _carBrand(),
                _carPrice(),
                _createSaveButton(),
              ],
            ),
          ),
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

  Widget _carBrand() {
    return TextFormField(
      initialValue: car.brand,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Marca',
      ),
      onSaved: (value) => car.brand = value,
      validator: (value) =>
          value.length < 3 ? 'Ingrese la marca del coche' : null,
    );
  }

  Widget _carPrice() {
    return TextFormField(
      initialValue: car.price.toString() ?? 0.0,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Precio',
      ),
      onSaved: (value) => car.price = int.parse(value),
      validator: (value) =>
          utils.isNumber(value) ? null : 'Ingrese solo números para el precio',
    );
  }

  Widget _createSaveButton() {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      color: Colors.deepPurple,
      textColor: Colors.white,
      icon: Icon(Icons.save),
      label: Text('Guardar'),
      onPressed: (_isSaving) ? null : _submit,
    );
  }

  void _submit() async {
    if (!formKey.currentState.validate()) return;

    formKey.currentState.save();

    setState(() => _isSaving = true);

    // Si la foto es != null es que tengo que subir la foto
    if (photo != null) car.photoUrl = await carsBloc.uploadImage(photo);

    // Si el coche no tiene ID lo crea
    car.id == null ? carsBloc.addCar(car) : carsBloc.editCar(car);

    setState(() => _isSaving = false);
    showSnackBar('Registro guardado correctamente');
    Navigator.pop(context);
  }

  void showSnackBar(String message) {
    final snackbar = SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: 1750),
    );

    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  _showImage() => car.photoUrl != null
      ? FadeInImage(
          image: NetworkImage(car.photoUrl),
          placeholder: AssetImage('assets/jar-loading.gif'),
          height: 300.0,
          fit: BoxFit.cover,
        )
      : Image(
          // Si la foto.path es null escoje la imagen de assets
          image: AssetImage(photo?.path ?? 'assets/no-image.png'),
          height: 300.0,
          fit: BoxFit.cover,
        );

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
