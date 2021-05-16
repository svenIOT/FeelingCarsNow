import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'package:feeling_cars_now/src/bloc/car_bloc.dart';
import 'package:feeling_cars_now/src/bloc/provider.dart';
import 'package:feeling_cars_now/src/models/car_model.dart';
import 'package:feeling_cars_now/src/widgets/text_header.dart';
import 'package:feeling_cars_now/src/utils/utils.dart' as utils;
import 'package:feeling_cars_now/src/user_preferences/user_preferences.dart';

class CarDetailsScreen extends StatefulWidget {
  @override
  _CarDetailsScreenState createState() => _CarDetailsScreenState();
}

class _CarDetailsScreenState extends State<CarDetailsScreen> {
  CarsBloc carsBloc;
  CarModel car = new CarModel();
  final _prefs = new UserPreferences();

  @override
  Widget build(BuildContext context) {
    carsBloc = Provider.carsBloc(context);
    final CarModel argumentCar = ModalRoute.of(context).settings.arguments;
    if (argumentCar != null) car = argumentCar;

    // Estilos iconos y texto
    final _iconSize = 35.0;
    final _iconTextStyle =
        TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0);

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles'),
        // Si el usuario es el propietario puede editar
        actions: _ownerActions(),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              _showCarImage(),
              Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextHeader('${car.brand} ${car.model} - ${car.year}'),
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: <Widget>[
                            _createIcon(
                                icon:
                                    MaterialCommunityIcons.format_list_bulleted,
                                color: Theme.of(context).primaryColor,
                                iconSize: _iconSize,
                                iconTextStyle: _iconTextStyle,
                                text: '${car.category}'),
                            SizedBox(height: 20.0),
                            _createIcon(
                              icon: MaterialCommunityIcons.fuel,
                              color: Theme.of(context).primaryColor,
                              iconSize: _iconSize,
                              iconTextStyle: _iconTextStyle,
                              text: '${car.fuel}',
                            ),
                            SizedBox(height: 20.0),
                            _createIcon(
                              icon: MaterialCommunityIcons.calendar,
                              color: Theme.of(context).primaryColor,
                              iconSize: _iconSize,
                              iconTextStyle: _iconTextStyle,
                              text: '${car.year}',
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            _createIcon(
                              icon: Ionicons.md_speedometer,
                              iconSize: _iconSize,
                              iconTextStyle: _iconTextStyle,
                              text: '${car.power} cv',
                            ),
                            SizedBox(height: 20.0),
                            _createIcon(
                              icon: Entypo.location,
                              color: Theme.of(context).primaryColor,
                              iconSize: _iconSize,
                              iconTextStyle: _iconTextStyle,
                              text: '${car.location}',
                            ),
                            SizedBox(height: 20.0),
                            _createIcon(
                              icon: Ionicons.ios_car,
                              color: Theme.of(context).primaryColor,
                              iconSize: _iconSize,
                              iconTextStyle: _iconTextStyle,
                              text: '${car.km} Km',
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Entypo.price_tag),
                        TextHeader('${car.price} €'),
                      ],
                    ),
                    Divider(),
                    if (car.description != null)
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          '${car.description}',
                          textAlign: TextAlign.justify,
                        ),
                      )
                  ],
                ),
              ),
              SizedBox(height: 80.0), // SafeArea para el floatingActionButton
            ],
          ),
        ),
      ),
      floatingActionButton: _createMessageButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  /// Crea un botón para contactar con el vendedor. Si el usuario actual
  /// es el propietario oculta el botón.
  Widget _createMessageButton() {
    bool _isVisible = false;
    if (car.userId != _prefs.uid) _isVisible = true;

    return Visibility(
      visible: _isVisible,
      child: Container(
        height: 40.0,
        width: 150.0,
        child: FloatingActionButton(
          child: Row(
            children: <Widget>[
              SizedBox(width: 20.0),
              Expanded(child: Text('Contactar')),
              Icon(Icons.messenger),
              SizedBox(width: 15.0),
            ],
          ),
          tooltip: 'Inicia una conversación con el vendedor',
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: _newChat,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
        ),
      ),
    );
  }

  /// Muestra los datos de contacto del vendedor.
  void _newChat() {}

  /// Muestra la imagen que corresponda, desde los assets si no existe o
  /// está cagando, o desde cloudinary.
  Widget _showCarImage() => car.photoUrl != null
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
            image: AssetImage('assets/img/no-image.png'),
            height: 300.0,
            fit: BoxFit.cover,
          ),
        );

  /// Crea un ícono y descripción de un dato del coche.
  Widget _createIcon(
          {IconData icon,
          double iconSize,
          TextStyle iconTextStyle,
          Color color,
          String text}) =>
      Column(
        children: <Widget>[
          Icon(
            icon,
            color: color ?? Colors.red[900],
            size: iconSize,
          ),
          SizedBox(height: 5.0),
          Text(
            text ?? "Sin especificar",
            style: iconTextStyle,
          )
        ],
      );

  /// Si es el propietario del anuncio, devuelve una lista con las acciones del Appbar (editar, eliminar).
  List<Widget> _ownerActions() {
    final List<Widget> actions = [];

    if (car.userId == _prefs.uid) {
      actions.add(IconButton(
        icon: Icon(Entypo.edit),
        onPressed: () => Navigator.pushNamed(context, 'car', arguments: car),
      ));
      actions.add(SizedBox(width: 10.0));
      actions.add(IconButton(
        icon: Icon(AntDesign.delete),
        onPressed: () => utils.showAlertDialog(
            context: context,
            title: '¡Atención!',
            body:
                'Si continua se eliminará de forma permanente el anuncio y no será visible para otros usuarios.',
            onProceedPressed: _deleteCar),
      ));
    }
    return actions;
  }

  /// Borra el coche actual, muestra un snackbar al usuario y vuelve a la pantalla anterior.
  void _deleteCar() {
    carsBloc.deleteCar(car.id);
    Navigator.of(context).popUntil((route) => route.isFirst);
    utils.showSnackBar(context, 'Anuncio borrado...');
  }
}
