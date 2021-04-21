import 'dart:io';
import 'package:flutter/material.dart';

import 'package:feeling_cars_now/src/bloc/car_bloc.dart';
import 'package:feeling_cars_now/src/bloc/provider.dart';
import 'package:feeling_cars_now/src/models/car_model.dart';
import 'package:feeling_cars_now/src/utils/utils.dart' as utils;
import 'package:feeling_cars_now/src/utils/constants.dart' as Constants;
import 'dropdown_custom.dart';

class CarForm extends StatefulWidget {
  @override
  _CarFormState createState() => _CarFormState();
}

class _CarFormState extends State<CarForm> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  CarsBloc carsBloc;
  CarModel car = new CarModel();
  bool _isSaving = false;
  File photo;

  @override
  Widget build(BuildContext context) {
    carsBloc = Provider.carsBloc(context);

    // Por defecto los coches no están destacados
    car.featured = false;
    // TODO: validaciones
    // TODO: agregar dinámicamente el usuario que crea el coche
    car.userId = "DhMd9XzjbMUkROQ2j83xMaOwB9b2";

    // Si se le pasa un coche desde el padre lo guarda en car (es editar coche)
    final CarModel argumentCar = ModalRoute.of(context).settings.arguments;
    if (argumentCar != null) car = argumentCar;

    return Form(
      key: formKey,
      child: Column(
        children: <Widget>[
          _showImage(),
          _carYear(),
          _categoryAndFuelDropdownButton(car),
          _carBrand(),
          _carModel(),
          _carPower(),
          _carKm(),
          _carPrice(),
          _createSaveButton(),
        ],
      ),
    );
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

  Widget _carYear() {
    return TextFormField(
      initialValue: car.year.toString() ?? "1984",
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Año del coche',
      ),
      onSaved: (value) => car.year = int.tryParse(value),
      validator: (value) => utils.isNumber(value)
          ? null
          : 'Ingrese un año válido de 4 dígitos númericos',
    );
  }

  Widget _categoryAndFuelDropdownButton(CarModel _car) {
    return Container(
      padding: EdgeInsets.only(top: 15.0),
      child: Column(
        children: [
          DropdownCustom(
            hintText: "Homologación...",
            items: Constants.categoryDropdownItems,
            car: _car,
          ),
          SizedBox(height: 15.0),
          DropdownCustom(
            hintText: "Combustible...",
            items: Constants.fuelDropdownItems,
            car: _car,
          ),
        ],
      ),
    );
  }

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

  Widget _carModel() {
    return TextFormField(
      initialValue: car.model,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Modelo',
      ),
      onSaved: (value) => car.model = value,
      validator: (value) =>
          value.length < 2 ? 'Ingrese el modelo del coche' : null,
    );
  }

  Widget _carPower() {
    return TextFormField(
      initialValue: car.power.toString() ?? "0",
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Potencia',
      ),
      onSaved: (value) => car.power = int.tryParse(value),
      validator: (value) => utils.isNumber(value)
          ? null
          : 'Ingrese la potencia en caballos del coche',
    );
  }

  Widget _carKm() {
    return TextFormField(
      initialValue: car.km.toString() ?? "0",
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Kilometros',
      ),
      onSaved: (value) => car.km = int.tryParse(value),
      validator: (value) => utils.isNumber(value)
          ? null
          : 'Ingrese solo números para los kilometros',
    );
  }

  Widget _carPrice() {
    return TextFormField(
      initialValue: car.price.toString() ?? "0",
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Precio',
      ),
      onSaved: (value) => car.price = int.tryParse(value),
      validator: (value) =>
          utils.isNumber(value) ? null : 'Ingrese solo números para el precio',
    );
  }

  Widget _createSaveButton() {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      color: Theme.of(context).primaryColor,
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

    // Si hay foto (es != null) hay que subirla a cloudinary
    if (photo != null) car.photoUrl = await carsBloc.uploadImage(photo);

    // Si el coche no tiene ID lo crea
    car.id == null ? carsBloc.addCar(car) : carsBloc.editCar(car);

    setState(() => _isSaving = false);
    utils.showSnackBar(context, 'Registro guardado correctamente');
    Navigator.pop(context);
  }
}
