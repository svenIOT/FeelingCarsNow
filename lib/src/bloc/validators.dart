import 'dart:async';
import 'package:flutter/material.dart';

import 'package:feeling_cars_now/src/utils/utils.dart' as utils;

class Validators {
  final validateEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);

    regExp.hasMatch(email)
        ? sink.add(email)
        : sink.addError('No es un email válido');
  });

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
    handleData: (password, sink) => password.length >= 8
        ? sink.add(password)
        : sink.addError('La contraseña debe contener 8 carácteres'),
  );

  /// Valida un campo númerico según el máximo establecido por la aplicación como valor
  /// permitido.
  static dynamic validateNumbericField(
          {@required String value,
          @required int maxAllowedNumber,
          int minAllowedNumber = 1,
          @required String errorText}) =>
      utils.isNumber(value) &&
              !(int.parse(value) < minAllowedNumber) &&
              !(int.parse(value) > maxAllowedNumber)
          ? null
          : errorText;

  /// Valida un campo de texto con como mínimo con 2 carácteres (eliminando
  /// espacios).
  static dynamic validateTextField(String value, String errorText) =>
      value.trim().length < 2 ? errorText : null;
}
