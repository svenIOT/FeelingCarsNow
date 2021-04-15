import 'package:flutter/material.dart';

import 'package:feeling_cars_now/src/bloc/provider.dart';
import 'package:feeling_cars_now/src/widgets/drawer.dart';
import 'package:feeling_cars_now/src/widgets/search_elements.dart';
import 'package:feeling_cars_now/src/widgets/text_header.dart';
import 'package:feeling_cars_now/src/widgets/featured_cars.dart';
import 'package:feeling_cars_now/src/widgets/standard_cars.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final featuredCarsBloc = Provider.carsBloc(context);
    featuredCarsBloc.loadFeaturedCars();

    final carsBloc = Provider.carsBloc(context);
    carsBloc.loadCars();

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      drawer: UserDrawer(),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Elementos de búsqueda y filtros
              SearchElements(),
              // Lista de coches destacados
              TextHeader('Coches destacados:'),
              FeaturedCars(featuredCarsBloc),
              SizedBox(height: 10.0),
              // Lista de coches genérica
              TextHeader('Coches a la venta:'),
              StandardCars(carsBloc),
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
        backgroundColor: Colors.deepPurple,
        onPressed: () => Navigator.pushNamed(context, 'car'),
      );
}
