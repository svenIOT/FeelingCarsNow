import 'package:flutter/material.dart';

/// Comprueba si el String es un número.
bool isNumber(String value) {
  if (value.isEmpty) return false;

  return num.tryParse(value) == null ? false : true;
}

/// Obtiene el tamaño del dispositivo según el context.
Size getDeviceSize(BuildContext context) => MediaQuery.of(context).size;

/// Obtiene el color principal según las preferencias de usuario almacenadas en el storage.
Color getActualColor(BuildContext context, bool secondaryColor) {
  return (secondaryColor) ? Colors.grey[700] : Theme.of(context).primaryColor;
}

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

/// Muestra una alerta con 2 opciones.
///
/// Recibe los textos (mensaje y botones) y la función a realizar al seleccionar continuar.
void showAlertDialog(
    {@required BuildContext context,
    @required String title,
    @required String body,
    String cancelButtonText,
    String proceedButtonText,
    @required Function() onProceedPressed}) {
  Widget cancelButton = ElevatedButton(
    style: ElevatedButton.styleFrom(primary: Theme.of(context).primaryColor),
    child: Text(cancelButtonText ?? "Cancelar"),
    onPressed: () => Navigator.of(context).pop(),
  );
  Widget continueButton = ElevatedButton(
    style: ElevatedButton.styleFrom(primary: Colors.red[700]),
    child: Text(proceedButtonText ?? "Continuar"),
    onPressed: onProceedPressed,
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
}

/// Muestra un snackbar con un mensaje.
void showSnackBar(BuildContext context, String message) {
  final snackbar = SnackBar(
    content: Text(message),
    duration: Duration(seconds: 3),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}
