import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'package:feeling_cars_now/src/bloc/car_bloc.dart';
import 'package:feeling_cars_now/src/models/car_model.dart';

class StandardCars extends StatefulWidget {
  StandardCars(this.carsBloc);

  final CarsBloc carsBloc;

  @override
  _StandardCarsState createState() => _StandardCarsState();
}

class _StandardCarsState extends State<StandardCars> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.carsBloc.carsStream,
      builder: (BuildContext context, AsyncSnapshot<List<CarModel>> snapshot) =>
          snapshot.hasData
              ? ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) => _createCarItem(
                      context, snapshot.data[index], widget.carsBloc),
                )
              : Center(child: CircularProgressIndicator()),
    );
  }

  /// Crea el card de cada coche.
  Widget _createCarItem(BuildContext context, CarModel car, CarsBloc carsBloc) {
    return Card(
      child: InkWell(
        child: Column(
          children: <Widget>[
            (car.photoUrl == null)
                ? Image(
                    image: AssetImage('assets/img/no-image.png'),
                    height: 250.0,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : FadeInImage(
                    placeholder: AssetImage('assets/img/jar-loading.gif'),
                    image: NetworkImage(car.photoUrl),
                    height: 250.0,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
            ListTile(
              title: Text('${car.brand} - ${car.model}'),
              subtitle: Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('${car.price} €'),
                    if (car.featured)
                      Icon(MaterialCommunityIcons.fire, color: Colors.red[700])
                  ],
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
