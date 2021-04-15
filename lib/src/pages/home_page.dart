import 'package:flutter/material.dart';

import 'package:feeling_cars_now/src/bloc/car_bloc.dart';
import 'package:feeling_cars_now/src/bloc/provider.dart';
import 'package:feeling_cars_now/src/models/car_model.dart';
import 'package:feeling_cars_now/src/widgets/drawer.dart';
import 'package:feeling_cars_now/src/widgets/search_elements.dart';
import 'package:feeling_cars_now/src/widgets/text_header.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final _height = MediaQuery.of(context).size.height;
    //final _width = MediaQuery.of(context).size.width;

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
                _createFeaturedList(),
                SizedBox(height: 10.0),
                // Lista de coches genérica
                TextHeader('Coches a la venta:'),
                _createList(carsBloc),
              ],
            ),
          ),
        ),
        floatingActionButton: _createFloatingActionButton(context));
  }

  Widget _createList(CarsBloc carsBloc) {
    return StreamBuilder(
      stream: carsBloc.carsStream,
      builder: (BuildContext context, AsyncSnapshot<List<CarModel>> snapshot) =>
          snapshot.hasData
              ? ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) =>
                      _createItem(context, snapshot.data[index], carsBloc))
              : Center(child: CircularProgressIndicator()),
    );
  }

  Widget _createFloatingActionButton(BuildContext context) =>
      FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
        onPressed: () => Navigator.pushNamed(context, 'car'),
      );

  Widget _createItem(BuildContext context, CarModel car, CarsBloc carsBloc) {
    return Card(
      child: Column(
        children: <Widget>[
          (car.photoUrl == null)
              ? Image(
                  image: AssetImage('assets/no-image.png'),
                  height: 250.0,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
              : FadeInImage(
                  placeholder: AssetImage('assets/jar-loading.gif'),
                  image: NetworkImage(car.photoUrl),
                  height: 250.0,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
          ListTile(
            title: Text('${car.brand} - ${car.model}'),
            subtitle: Text('${car.price} €'),
            onTap: () =>
                Navigator.pushNamed(context, 'details', arguments: car),
          ),
        ],
      ),
    );
  }

  Widget _createFeaturedList() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      height: 150.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Container(
            width: 150.0,
            color: Colors.red,
          ),
          Container(
            width: 150.0,
            color: Colors.blue,
          ),
          Container(
            width: 150.0,
            color: Colors.green,
          ),
          Container(
            width: 150.0,
            color: Colors.yellow,
          ),
          Container(
            width: 100.0,
            color: Colors.orange,
          ),
        ],
      ),
    );
  }
}
