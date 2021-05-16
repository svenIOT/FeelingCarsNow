import 'package:flutter/material.dart';

import 'package:feeling_cars_now/src/widgets/text_header.dart';

class ContactScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String ownerEmail = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Contacto'),
      ),
      body: Container(
        child: Center(
          child: TextHeader('Email del propietario:\n\n $ownerEmail'),
        ),
      ),
    );
  }
}
