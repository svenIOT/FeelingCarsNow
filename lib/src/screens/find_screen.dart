import 'package:feeling_cars_now/src/bloc/car_bloc.dart';
import 'package:feeling_cars_now/src/models/car_model.dart';
import 'package:flutter/material.dart';

import 'package:feeling_cars_now/src/models/filter_model.dart';
import 'package:feeling_cars_now/src/bloc/provider.dart';

class FindScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Filter filter = ModalRoute.of(context).settings.arguments;

    final findCarsBloc = Provider.carsBloc(context);
    findCarsBloc.loadFilteredCars(filter);

    return Scaffold(
      appBar: AppBar(
        title: Text('Resultados'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              StreamBuilder(
                  stream: findCarsBloc.filteredCarsStream,
                  builder: (BuildContext context,
                          AsyncSnapshot<List<CarModel>> snapshot) =>
                      snapshot.hasData
                          ? GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: 0.8,
                                      crossAxisSpacing: 8,
                                      mainAxisSpacing: 8,
                                      crossAxisCount: 2),
                              primary: false,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) => _createCarItem(
                                  context, snapshot.data[index], findCarsBloc),
                            )
                          : Center(child: CircularProgressIndicator())),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createCarItem(BuildContext context, CarModel car, CarsBloc carsBloc) {
    return Card(
      child: Column(
        children: <Widget>[
          (car.photoUrl == null)
              ? Image(
                  image: AssetImage('assets/img/no-image.png'),
                  height: 150.0,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
              : FadeInImage(
                  placeholder: AssetImage('assets/img/jar-loading.gif'),
                  image: NetworkImage(car.photoUrl),
                  height: 150.0,
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
}
