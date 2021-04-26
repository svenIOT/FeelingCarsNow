import 'dart:io';
import 'package:flutter/material.dart';

import 'package:feeling_cars_now/src/bloc/car_bloc.dart';
import 'package:feeling_cars_now/src/bloc/provider.dart';
import 'package:feeling_cars_now/src/models/car_model.dart';
import 'package:feeling_cars_now/src/utils/utils.dart' as utils;
import 'package:feeling_cars_now/src/constants/dropdown_items_constants.dart'
    as DropdownItemsConstants;
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

  @override
  Widget build(BuildContext context) {
    widget.carsBloc = Provider.carsBloc(context);

    // Por defecto los coches no están destacados
    widget.car.featured = false;
    // TODO: validaciones
    // TODO: agregar dinámicamente el usuario que crea el coche
    widget.car.userId = "DhMd9XzjbMUkROQ2j83xMaOwB9b2";

    return Form(
      key: widget.formKey,
      child: Column(
        children: <Widget>[
          _showImage(),
          _carYear(),
          _categoryAndFuelDropdownButton(widget.car),
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

  _showImage() => widget.car.photoUrl != null
      ? FadeInImage(
          image: NetworkImage(widget.car.photoUrl),
          placeholder: AssetImage('assets/img/jar-loading.gif'),
          height: 300.0,
          fit: BoxFit.cover,
        )
      : Image(
          // Si la foto.path es null escoje la imagen de assets
          image: AssetImage(widget.photo?.path ?? 'assets/img/no-image.png'),
          height: 300.0,
          fit: BoxFit.cover,
        );

  Widget _carYear() {
    return TextFormField(
      initialValue: widget.car.year.toString() ?? "1984",
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Año del coche',
      ),
      onSaved: (value) => widget.car.year = int.tryParse(value),
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
            items: DropdownItemsConstants.categoryDropdownItems,
            car: _car,
          ),
          SizedBox(height: 15.0),
          DropdownCustom(
            hintText: "Combustible...",
            items: DropdownItemsConstants.fuelDropdownItems,
            car: _car,
          ),
        ],
      ),
    );
  }

  Widget _carBrand() {
    return TextFormField(
      initialValue: widget.car.brand,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Marca',
      ),
      onSaved: (value) => widget.car.brand = value,
      validator: (value) =>
          value.length < 3 ? 'Ingrese la marca del coche' : null,
    );
  }

  Widget _carModel() {
    return TextFormField(
      initialValue: widget.car.model,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Modelo',
      ),
      onSaved: (value) => widget.car.model = value,
      validator: (value) =>
          value.length < 2 ? 'Ingrese el modelo del coche' : null,
    );
  }

  Widget _carPower() {
    return TextFormField(
      initialValue: widget.car.power.toString() ?? "0",
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Potencia',
      ),
      onSaved: (value) => widget.car.power = int.tryParse(value),
      validator: (value) => utils.isNumber(value)
          ? null
          : 'Ingrese la potencia en caballos del coche',
    );
  }

  Widget _carKm() {
    return TextFormField(
      initialValue: widget.car.km.toString() ?? "0",
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Kilometros',
      ),
      onSaved: (value) => widget.car.km = int.tryParse(value),
      validator: (value) => utils.isNumber(value)
          ? null
          : 'Ingrese solo números para los kilometros',
    );
  }

  Widget _carPrice() {
    return TextFormField(
      initialValue: widget.car.price.toString() ?? "0",
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Precio',
      ),
      onSaved: (value) => widget.car.price = int.tryParse(value),
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
    if (!widget.formKey.currentState.validate()) return;

    widget.formKey.currentState.save();

    setState(() => _isSaving = true);

    // Si hay foto (es != null) hay que subirla a cloudinary
    if (widget.photo != null)
      widget.car.photoUrl = await widget.carsBloc.uploadImage(widget.photo);

    // Si el coche no tiene ID lo crea
    widget.car.id == null
        ? widget.carsBloc.addCar(widget.car)
        : widget.carsBloc.editCar(widget.car);

    setState(() => _isSaving = false);
    utils.showSnackBar(context, 'Registro guardado correctamente');
    Navigator.pop(context);
  }
}
