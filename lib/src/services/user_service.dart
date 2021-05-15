import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:feeling_cars_now/src/user_preferences/user_preferences.dart';

class Userservice {
  final String _firebaseKey =
      "AIzaSyBLa-a3pyn7cQBfFQYt6J4lEFY3dIDIW3w"; //TODO: hidde .env
  final _prefs = new UserPreferences();

  /// Envía una petición POST de acceso con el email y contraseña. Guarda el uid,
  /// token y email en el storage del dispositivo.
  ///
  /// Devuelve OK y el token o KO con el mensaje de error.
  Future<Map<String, dynamic>> login(String email, String password) async {
    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firebaseKey';
    final resp = await http.post(Uri.parse(url), body: json.encode(authData));

    Map<String, dynamic> decodedResp = json.decode(resp.body);

    if (decodedResp.containsKey('idToken') &&
        decodedResp.containsKey('localId')) {
      _prefs.token = decodedResp['idToken'];
      _prefs.uid = decodedResp['localId'];
      _prefs.email = decodedResp['email'];
      return {'ok': true, 'token': decodedResp['idToken']};
    } else {
      return {'ok': false, 'message': decodedResp['error']['message']};
    }
  }

  /// Envía una petición POST de creación de usuario con el email y contraseña.
  ///
  /// Devuelve OK y el token o KO con el mensaje de error.
  Future<Map<String, dynamic>> newUser(String email, String password) async {
    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseKey';
    final resp = await http.post(Uri.parse(url), body: json.encode(authData));

    Map<String, dynamic> decodedResp = json.decode(resp.body);

    if (decodedResp.containsKey('idToken')) {
      return {'ok': true, 'token': decodedResp['idToken']};
    } else {
      return {'ok': false, 'message': decodedResp['error']['message']};
    }
  }
}
