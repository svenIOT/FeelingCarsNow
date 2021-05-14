import 'package:flutter/material.dart';

import 'package:feeling_cars_now/src/bloc/provider.dart';
import 'package:feeling_cars_now/src/widgets/drawer.dart';
import 'package:feeling_cars_now/src/widgets/text_header.dart';
import 'package:feeling_cars_now/src/widgets/featured_cars.dart';
import 'package:feeling_cars_now/src/widgets/standard_cars.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final featuredCarsBloc = Provider.carsBloc(context);
    featuredCarsBloc.loadFeaturedCars();

    final carsBloc = Provider.carsBloc(context);
    carsBloc.loadCars();

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => Navigator.pushNamed(context, 'search'),
          ),
        ],
      ),
      drawer: UserDrawer(),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Lista de coches destacados
              TextHeader('Coches destacados:'),
              FeaturedCars(featuredCarsBloc),
              SizedBox(height: 10.0),
              // Lista de coches genérica
              TextHeader('Coches a la venta:'),
              StandardCars(carsBloc),
              SizedBox(height: 60.0)
            ],
          ),
        ),
      ),
      floatingActionButton: _createFloatingActionButton(context),
    );
  }

  Widget _createFloatingActionButton(BuildContext context) =>
      FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () => Navigator.pushNamed(context, 'car'),
      );
}
