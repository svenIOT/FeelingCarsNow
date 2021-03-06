import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'package:feeling_cars_now/src/bloc/car_bloc.dart';
import 'package:feeling_cars_now/src/bloc/provider.dart';
import 'package:feeling_cars_now/src/widgets/drawer.dart';
import 'package:feeling_cars_now/src/models/car_model.dart';
import 'package:feeling_cars_now/src/user_preferences/user_preferences.dart';

class UserCarsScreen extends StatelessWidget {
  static final String routeName = 'resume';
  final prefs = new UserPreferences();
  @override
  Widget build(BuildContext context) {
    prefs.lastScreen = UserCarsScreen.routeName;
    final userCarsBloc = Provider.carsBloc(context);
    userCarsBloc.loadUserCars(prefs.uid);

    return Scaffold(
      appBar: AppBar(
        title: Text('Mis coches'),
      ),
      drawer: UserDrawer(),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              StreamBuilder(
                stream: userCarsBloc.userCarsStream,
                builder: (BuildContext context,
                        AsyncSnapshot<List<CarModel>> snapshot) =>
                    snapshot.hasData
                        ? GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 0.7,
                                    crossAxisSpacing: 8,
                                    mainAxisSpacing: 8,
                                    crossAxisCount: 2),
                            primary: false,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) => _createCarItem(
                                context, snapshot.data[index], userCarsBloc),
                          )
                        : Center(child: CircularProgressIndicator()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Crea el card de cada Coche
  Widget _createCarItem(BuildContext context, CarModel car, CarsBloc carsBloc) {
    return Card(
      child: InkWell(
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
              subtitle: Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('${car.price} ???'),
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
