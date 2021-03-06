import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'package:feeling_cars_now/src/bloc/car_bloc.dart';
import 'package:feeling_cars_now/src/models/car_model.dart';

class FeaturedCars extends StatefulWidget {
  FeaturedCars(this.featuredCarsBloc);

  final CarsBloc featuredCarsBloc;

  @override
  _FeaturedCarsState createState() => _FeaturedCarsState();
}

class _FeaturedCarsState extends State<FeaturedCars> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.featuredCarsBloc.featuredCarsStream,
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
                        context, snapshot.data[index], widget.featuredCarsBloc),
                  ),
                )
              : Center(child: CircularProgressIndicator()),
    );
  }

  /// Crea el card de cada coche.
  Widget _createFeaturedCarItem(
      BuildContext context, CarModel car, CarsBloc carsBloc) {
    return Card(
      child: InkWell(
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
                subtitle: Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('${car.price} ???'),
                      if (car.featured)
                        Icon(MaterialCommunityIcons.fire,
                            color: Colors.red[700])
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        onTap: () => Navigator.pushNamed(context, 'details', arguments: car),
      ),
    );
  }
}
