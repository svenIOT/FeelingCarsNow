import 'package:flutter/material.dart';

import 'package:feeling_cars_now/src/bloc/car_bloc.dart';
import 'package:feeling_cars_now/src/models/car_model.dart';

class FeaturedCars extends StatelessWidget {
  FeaturedCars(this.featuredCarsBloc);

  final CarsBloc featuredCarsBloc;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: featuredCarsBloc.featuredCarsStream,
      builder: (BuildContext context, AsyncSnapshot<List<CarModel>> snapshot) =>
          snapshot.hasData
              ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  height: 280.0,
                  child: ListView.builder(
                    primary: false,
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) => _createFeaturedCarItem(
                        context, snapshot.data[index], featuredCarsBloc),
                  ),
                )
              : Center(child: CircularProgressIndicator()),
    );
  }

  Widget _createFeaturedCarItem(
      BuildContext context, CarModel car, CarsBloc carsBloc) {
    return Card(
      child: Column(
        children: <Widget>[
          (car.photoUrl == null)
              ? Image(
                  image: AssetImage('assets/img/no-image.png'),
                  height: 180.0,
                  width: 180.0,
                  fit: BoxFit.cover,
                )
              : FadeInImage(
                  placeholder: AssetImage('assets/img/jar-loading.gif'),
                  image: NetworkImage(car.photoUrl),
                  height: 180.0,
                  width: 180.0,
                  fit: BoxFit.cover,
                ),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 180.0, maxHeight: 180.0),
            child: ListTile(
              title: Text('${car.brand} - ${car.model}'),
              subtitle: Text('${car.price} €'),
              onTap: () =>
                  Navigator.pushNamed(context, 'details', arguments: car),
            ),
          ),
        ],
      ),
    );
  }
}
