import 'package:flutter/material.dart';

import 'package:feeling_cars_now/src/bloc/car_bloc.dart';
import 'package:feeling_cars_now/src/models/car_model.dart';

class StandardCars extends StatelessWidget {
  StandardCars(this.carsBloc);

  final CarsBloc carsBloc;

  @override
  Widget build(BuildContext context) {
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
                      _createCarItem(context, snapshot.data[index], carsBloc),
                )
              : Center(child: CircularProgressIndicator()),
    );
  }

  Widget _createCarItem(BuildContext context, CarModel car, CarsBloc carsBloc) {
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
}
