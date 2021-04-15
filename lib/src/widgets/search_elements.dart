import 'package:flutter/material.dart';

class SearchElements extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    return Container(
      height: _height / 4.5,
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
      child: Column(
        children: <Widget>[
          // Barra de búsqueda
          _createSearchInput(),
          SizedBox(height: 8.0),
          // filtros
          _createFilters(),
          // Botón
          _createButton(),
        ],
      ),
    );
  }

  Widget _createSearchInput() {
    return Container(
      height: 40.0,
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
      height: 40.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Container(
            width: 80.0,
            color: Colors.red,
          ),
          Container(
            width: 80.0,
            color: Colors.blue,
          ),
          Container(
            width: 80.0,
            color: Colors.green,
          ),
          Container(
            width: 80.0,
            color: Colors.yellow,
          ),
          Container(
            width: 80.0,
            color: Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _createButton() {
    return Container(
      child: ElevatedButton(
        child: Text('Aplicar'),
        style: ElevatedButton.styleFrom(
          primary: Colors.deepPurple,
        ),
        onPressed: () {
          print('Pressed');
        },
      ),
    );
  }
}
