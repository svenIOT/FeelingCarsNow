import 'package:flutter/material.dart';

import 'package:feeling_cars_now/src/utils/utils.dart' as utils;
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
              _createSearchInput(),
              SizedBox(height: 20.0),
              // filtros
              _createFilters(),
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

  Widget _createSearchInput() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.deepPurple,
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

  Widget _createFilters() {
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
          // TODO:
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
          primary: Colors.deepPurple,
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
          primary: Colors.deepPurple,
        ),
        onPressed: () {
          // TODO: Reset campos
        },
      ),
    );
  }
}
