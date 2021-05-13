import 'dart:io';
import 'package:flutter/material.dart';

import 'package:feeling_cars_now/src/bloc/car_bloc.dart';
import 'package:feeling_cars_now/src/bloc/provider.dart';
import 'package:feeling_cars_now/src/models/car_model.dart';
import 'package:feeling_cars_now/src/utils/utils.dart' as utils;
import 'package:feeling_cars_now/src/user_preferences/user_preferences.dart';
import 'package:feeling_cars_now/src/constants/dropdown_items_constants.dart'
    as dropdownItemsConstants;
import 'dropdown_custom.dart';

class CarForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  CarsBloc carsBloc;
  CarModel car;
  File photo;

  CarForm({
    @required this.formKey,
    @required this.carsBloc,
    @required this.car,
    @required this.photo,
  });

  @override
  _CarFormState createState() => _CarFormState();
}

class _CarFormState extends State<CarForm> {
  bool _isSaving = false;
  final _prefs = new UserPreferences();

  @override
  Widget build(BuildContext context) {
    widget.carsBloc = Provider.carsBloc(context);

    // Agregar el usuario que crea el coche, si es null agrega el user test
    widget.car.userId = _prefs.uid ?? "DhMd9XzjbMUkROQ2j83xMaOwB9b2";

    return Form(
      key: widget.formKey,
      child: Column(
        children: <Widget>[
          _showImage(),
          _carYear(),
          _categoryAndFuelDropdownButton(widget.car),
          _carBrand(),
          _carModel(),
          _carLocation(),
          _carPower(),
          _carKm(),
          _carPrice(),
          _carDescription(),
          SizedBox(height: 20.0),
          _createSaveButton(),
        ],
      ),
    );
  }

  /// Muestra la imagen que corresponda, desde los assets si no existe o
  /// está cagando, o desde cloudinary.
  _showImage() => widget.car.photoUrl != null
      ? FadeInImage(
          image: NetworkImage(widget.car.photoUrl),
          placeholder: AssetImage('assets/img/jar-loading.gif'),
          height: 300.0,
          fit: BoxFit.cover,
        )
      : Image(
          image: widget.photo?.path != null
              ? FileImage(widget.photo)
              : AssetImage('assets/img/no-image.png'),
          height: 300.0,
          fit: BoxFit.cover,
        );

  /// Crea el campo de texto del año del coche.
  Widget _carYear() => TextFormField(
        initialValue: widget.car.year?.toString(),
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: 'Año del coche',
        ),
        onSaved: (value) => widget.car.year = int.tryParse(value),
        validator: (value) => utils.isNumber(value)
            ? null
            : 'Ingrese un año válido de 4 dígitos númericos',
      );

  /// Crea los desplegables del tipo de homologación y el combustible.
  Widget _categoryAndFuelDropdownButton(CarModel _car) => Container(
        padding: EdgeInsets.only(top: 15.0),
        child: Column(
          children: [
            DropdownCustom(
              hintText: _car.category ?? "Homologación...",
              items: dropdownItemsConstants.categoryDropdownItems,
              car: _car,
            ),
            SizedBox(height: 20.0),
            DropdownCustom(
              hintText: _car.fuel ?? "Combustible...",
              items: dropdownItemsConstants.fuelDropdownItems,
              car: _car,
            ),
          ],
        ),
      );

  /// Crea el campo de texto de la marca del coche.
  Widget _carBrand() => TextFormField(
        initialValue: widget.car.brand,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          labelText: 'Marca',
        ),
        onSaved: (value) => widget.car.brand = value,
        validator: (value) =>
            value.length < 2 ? 'Ingrese la marca del coche' : null,
      );

  /// Crea el campo de texto del modelo del coche.
  Widget _carModel() => TextFormField(
        initialValue: widget.car.model,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          labelText: 'Modelo',
        ),
        onSaved: (value) => widget.car.model = value,
        validator: (value) =>
            value.length < 2 ? 'Ingrese el modelo del coche' : null,
      );

  /// Crea el campo de texto de la localización del coche.
  Widget _carLocation() => TextFormField(
        initialValue: widget.car.location,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          labelText: 'Ubicación',
        ),
        onSaved: (value) => widget.car.location = value,
        validator: (value) => value.length < 2
            ? 'Ingrese la provincia donde se encuentra el coche'
            : null,
      );

  /// Crea el campo de texto de la potencia del coche.
  Widget _carPower() => TextFormField(
        initialValue: widget.car.power?.toString(),
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          labelText: 'Potencia',
        ),
        onSaved: (value) => widget.car.power = int.tryParse(value),
        validator: (value) => utils.isNumber(value)
            ? null
            : 'Ingrese la potencia en caballos del coche, ej: 150',
      );

  /// Crea el campo de texto de los kilómetros que tiene el coche.
  Widget _carKm() => TextFormField(
        initialValue: widget.car.km?.toString(),
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: 'Kilometros',
        ),
        onSaved: (value) => widget.car.km = int.tryParse(value),
        validator: (value) =>
            utils.isNumber(value) ? null : 'Ingrese los kilometros, ej: 100000',
      );

  /// Crea el campo de texto del precio del coche.
  Widget _carPrice() => TextFormField(
        initialValue: widget.car.price?.toString(),
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: 'Precio',
        ),
        onSaved: (value) => widget.car.price = int.tryParse(value),
        validator: (value) => utils.isNumber(value)
            ? null
            : 'Ingrese solo números para el precio, ej: 12000',
      );

  /// Crea el campo de texto ampliado de la descripción (campo opcional).
  Widget _carDescription() => TextFormField(
        initialValue: widget.car.description,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          labelText: 'Descripción',
        ),
        maxLines: 9,
        onSaved: (value) => widget.car.description = value,
        validator: (value) => value.length > 600
            ? 'Texto demasiado largo, máximo 600 carácteres, hay: ${value.length}'
            : null,
      );

  /// Crea el botón para guardar.
  Widget _createSaveButton() => ElevatedButton.icon(
        style:
            ElevatedButton.styleFrom(primary: Theme.of(context).primaryColor),
        icon: Icon(Icons.save),
        label: Text('Guardar'),
        onPressed: (_isSaving) ? null : _submit,
      );

  /// Valida que el formulario cumpla los requisitos, guarda el estado y realiza
  /// una creación o edición según corresponda.
  void _submit() async {
    if (!widget.formKey.currentState.validate()) return;

    widget.formKey.currentState.save();

    setState(() => _isSaving = true);

    // Si hay foto (es != null) hay que subirla a cloudinary
    if (widget.photo != null)
      widget.car.photoUrl = await widget.carsBloc.uploadImage(widget.photo);

    // Comprobar si hay que crear o editar
    widget.car.id == null
        ? widget.carsBloc.addCar(widget.car)
        : widget.carsBloc.editCar(widget.car);

    setState(() => _isSaving = false);
    utils.showSnackBar(context, 'Coche guardado correctamente');
    Navigator.pop(context);
  }
}
