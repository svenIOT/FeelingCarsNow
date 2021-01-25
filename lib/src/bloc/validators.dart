import 'dart:async';

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
}
