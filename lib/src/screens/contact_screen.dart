import 'package:flutter/material.dart';

import 'package:feeling_cars_now/src/models/car_model.dart';
import 'package:feeling_cars_now/src/widgets/email_sender.dart';

class ContactScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CarModel argumentCar = ModalRoute.of(context).settings.arguments;

    return EmailSender(
      title: 'Contactar vendedor',
      recipent: argumentCar.ownerEmail,
      subject: 'Feeling Cars Now - ${argumentCar.brand} ${argumentCar.model}',
      body:
          '¡Hola! estoy interesado en tu anuncio ${argumentCar.brand} ${argumentCar.model} y me gustaría obtener más información.',
    );
  }
}
