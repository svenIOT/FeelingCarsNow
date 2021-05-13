import 'dart:async';
import 'package:rxdart/rxdart.dart';

import 'package:feeling_cars_now/src/bloc/validators.dart';

class LoginBloc with Validators {
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  // Recuperar los datos del Stream
  Stream<String> get emailStream =>
      _emailController.stream.transform(validateEmail);
  Stream<String> get passwordStream =>
      _passwordController.stream.transform(validatePassword);

  Stream<bool> get formValidStream =>
      Rx.combineLatest2(emailStream, passwordStream, (e, p) => true);

  // Insertar valores al Stream
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  // Obtener el último valor insertado a los streams
  String get email => _emailController.value;
  String get password => _passwordController.value;

  /// Cierra todos Streams
  dispose() {
    _emailController?.close();
    _passwordController?.close();
  }
}
