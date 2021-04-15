import 'package:flutter/material.dart';

bool isNumber(String value) {
  if (value.isEmpty) return false;

  return num.tryParse(value) == null ? false : true;
}

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
