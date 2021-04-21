import 'package:flutter/material.dart';

bool isNumber(String value) {
  if (value.isEmpty) return false;

  return num.tryParse(value) == null ? false : true;
}

Size getDeviceSize(BuildContext context) => MediaQuery.of(context).size;

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

void showSnackBar(BuildContext context, String message) {
  final snackbar = SnackBar(
    content: Text(message),
    duration: Duration(milliseconds: 1750),
  );

  // Deprecated: scaffoldKey.currentState.showSnackBar(snackbar);
  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}
