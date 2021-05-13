import 'package:flutter/material.dart';

/// Comprueba si el String es un número.
bool isNumber(String value) {
  if (value.isEmpty) return false;

  return num.tryParse(value) == null ? false : true;
}

/// Obtiene el tamaño del dispositivo según el context.
Size getDeviceSize(BuildContext context) => MediaQuery.of(context).size;

/// Muestra una alerta con un mensaje
void showAlert(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Error'),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('De acuedo'),
        ),
      ],
    ),
  );
}

/// Muestra una alerta con 2 opciones. Devuelve true si la opción es OK.
bool showAlertDialog(BuildContext context, String title, String body) {
  bool response = false;

  Widget cancelButton = ElevatedButton(
    style: ElevatedButton.styleFrom(primary: Theme.of(context).primaryColor),
    child: Text("Cancelar"),
    onPressed: () => Navigator.of(context).pop(),
  );
  Widget continueButton = ElevatedButton(
    style: ElevatedButton.styleFrom(primary: Colors.red[700]),
    child: Text("Borrar"),
    onPressed: () {
      response = true;
      Navigator.of(context).pop();
    },
  );

  showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: <Widget>[
        cancelButton,
        continueButton,
      ],
    ),
  );
  return response;
}

/// Muestra un snackbar con un mensaje.
void showSnackBar(BuildContext context, String message) {
  final snackbar = SnackBar(
    content: Text(message),
    duration: Duration(milliseconds: 1750),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}
