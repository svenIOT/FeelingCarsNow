import 'package:flutter/material.dart';

import 'package:feeling_cars_now/src/models/filter_model.dart';

class FindPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Filter filter = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Resultados'),
      ),
      body: Container(),
    );
  }
}
