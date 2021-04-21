import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:feeling_cars_now/src/utils/constants.dart' as Constants;
import 'package:feeling_cars_now/src/widgets/multiselect_custom.dart';

class SearchAndFiltersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Búsqueda y filtros'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 30.0),
          child: Column(
            children: <Widget>[
              // Barra de búsqueda
              _createSearchInput(context),
              SizedBox(height: 20.0),
              // filtros
              _createFilters(context),
              SizedBox(height: 20.0),
              // Botones
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _createResetButton(context),
                  _createApllyButton(context),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _createSearchInput(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).primaryColor,
          width: 2,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: TextField(
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: 'Buscar...',
          contentPadding: const EdgeInsets.all(10),
        ),
      ),
    );
  }

  Widget _createFilters(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          MultiselectCustom(
            title: 'Homologación',
            dataSource: Constants.multiselectCategory,
          ),
          SizedBox(height: 20.0),
          MultiselectCustom(
            title: 'Combustible',
            dataSource: Constants.multiselectFuel,
          ),
          SizedBox(height: 20.0),
          _kmPicker(context),
          SizedBox(height: 10.0),
          _powerPicker(context),
        ],
      ),
    );
  }

  Widget _createApllyButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30.0),
      child: ElevatedButton(
        child: Text('Aplicar'),
        style: ElevatedButton.styleFrom(
          primary: Theme.of(context).primaryColor,
        ),
        onPressed: () {
          // Navegar a una nueva página con los resultados
          Navigator.pushNamed(
              context, 'find'); // TODO: arguments: filtros y texto
        },
      ),
    );
  }

  Widget _createResetButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30.0),
      child: ElevatedButton(
        child: Icon(Icons.restore),
        style: ElevatedButton.styleFrom(
          primary: Theme.of(context).primaryColor,
        ),
        onPressed: () {
          // TODO: Reset campos
        },
      ),
    );
  }

  Widget _kmPicker(BuildContext context) {
    return Row(
      children: [
        MaterialButton(
          child: Text(
            "Kilometros desde...",
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          color: Colors.grey[200],
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (BuildContext builder) {
                  return Container(
                    height: MediaQuery.of(context).copyWith().size.height / 3,
                    child: CupertinoPicker(
                      itemExtent: 50,
                      onSelectedItemChanged: (index) {
                        print(index);
                      },
                      children: Constants.carKilometersValues,
                    ),
                  );
                });
          },
        ),
        SizedBox(width: 10.0),
        MaterialButton(
          child: Text(
            "Kilometros hasta...",
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          color: Colors.grey[200],
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (BuildContext builder) {
                  return Container(
                    height: MediaQuery.of(context).copyWith().size.height / 3,
                    child: CupertinoPicker(
                      itemExtent: 50,
                      onSelectedItemChanged: (index) {
                        print(index);
                      },
                      children: Constants.carKilometersValues,
                    ),
                  );
                });
          },
        ),
      ],
    );
  }

  Widget _powerPicker(BuildContext context) {
    return Row(
      children: [
        MaterialButton(
          child: Text(
            "Potencia desde...    ",
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          color: Colors.grey[200],
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (BuildContext builder) {
                  return Container(
                    height: MediaQuery.of(context).copyWith().size.height / 3,
                    child: CupertinoPicker(
                      itemExtent: 50,
                      onSelectedItemChanged: (index) {
                        print(index);
                      },
                      children: Constants.carPowerValues,
                    ),
                  );
                });
          },
        ),
        SizedBox(width: 10.0),
        MaterialButton(
          child: Text(
            "Potencia hasta...    ",
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          color: Colors.grey[200],
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (BuildContext builder) {
                  return Container(
                    height: MediaQuery.of(context).copyWith().size.height / 3,
                    child: CupertinoPicker(
                      itemExtent: 50,
                      onSelectedItemChanged: (index) {
                        print(index);
                      },
                      children: Constants.carPowerValues,
                    ),
                  );
                });
          },
        ),
      ],
    );
  }
}
