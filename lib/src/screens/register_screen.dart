import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'package:feeling_cars_now/src/bloc/login_bloc.dart';
import 'package:feeling_cars_now/src/bloc/provider.dart';
import 'package:feeling_cars_now/src/services/user_service.dart';
import 'package:feeling_cars_now/src/utils/utils.dart' as utils;

class RegisterScreen extends StatelessWidget {
  final userService = new Userservice();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _createBackground(context, size),
          _loginForm(context, size),
        ],
      ),
    );
  }

  /// Contiene el formulario de login.
  Widget _loginForm(BuildContext context, Size size) {
    final loginBloc = Provider.of(context);

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SafeArea(child: Container(height: 200.0)),
          Container(
            width: size.width * 0.85,
            margin: EdgeInsets.symmetric(vertical: 30.0),
            padding: EdgeInsets.symmetric(vertical: 30.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 3.0,
                  offset: Offset(0.0, 0.5),
                  spreadRadius: 3.0,
                ),
              ],
            ),
            child: Column(
              children: <Widget>[
                Icon(
                  MaterialCommunityIcons.account_supervisor_circle,
                  size: 80,
                  color: Theme.of(context).primaryColor,
                ),
                Text('Crear cuenta', style: TextStyle(fontSize: 20.0)),
                SizedBox(height: 60.0),
                _createEmail(loginBloc),
                SizedBox(height: 30.0),
                _createPassword(loginBloc),
                SizedBox(height: 30.0),
                _createButton(loginBloc)
              ],
            ),
          ),
          _loginWithAExistingAccount(context),
          SizedBox(height: 100.0)
        ],
      ),
    );
  }

  /// Crea campo de texto del email.
  Widget _createEmail(LoginBloc bloc) => StreamBuilder(
        stream: bloc.emailStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                icon: Icon(Entypo.email, color: Theme.of(context).primaryColor),
                labelText: 'Correo electrónico',
                hintText: 'ejemplo@correo.com',
                errorText: snapshot.error,
              ),
              onChanged: (value) => bloc.changeEmail(value),
            ),
          );
        },
      );

  /// Crea el campo de texto de la contraseña.
  Widget _createPassword(LoginBloc bloc) => StreamBuilder(
        stream: bloc.passwordStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                icon: Icon(MaterialCommunityIcons.textbox_password,
                    color: Theme.of(context).primaryColor),
                labelText: 'Contraseña',
                hintText: 'Contraseña',
                errorText: snapshot.error,
              ),
              onChanged: (value) => bloc.changePassword(value),
            ),
          );
        },
      );

  /// Crea el botón de registrar.
  Widget _createButton(LoginBloc bloc) => StreamBuilder(
        stream: bloc.formValidStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return ElevatedButton(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
              child: Text('Registrar'),
            ),
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).primaryColor,
            ),
            onPressed: snapshot.hasData ? () => _register(context, bloc) : null,
          );
        },
      );

  /// LLama al userService y crea un nuevo usuario con email y contraseña.
  ///
  /// Si hubo un error al registrar lanza un mensaje de error.
  void _register(BuildContext context, LoginBloc bloc) async {
    final info = await userService.newUser(bloc.email, bloc.password);

    return (info['ok'])
        ? _successfulRegiser(context)
        : utils.showAlert(context,
            'Ya existe una cuenta con ese email,\ninfo: ' + info['message']);
  }

  /// Muestra un snackbar y redirige al login cuando el usuario se creó.
  void _successfulRegiser(BuildContext context) {
    utils.showSnackBar(context, 'Usuario creado correctamente');
    Navigator.pushReplacementNamed(context, 'login');
  }

  /// Crea el fondo de la cabecera
  Widget _createBackground(BuildContext context, Size size) => Container(
        height: size.height * 0.4,
        width: double.infinity,
        child: Image(
          image: AssetImage('assets/img/logo-nocircles.png'),
          fit: BoxFit.fill,
        ),
      );

  /// Muestra el botón que redirige al formulario para hacer login.
  Widget _loginWithAExistingAccount(BuildContext context) => ElevatedButton(
        style: ElevatedButton.styleFrom(primary: Colors.white30, elevation: 0),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Text(
            '¿Ya tienes cuenta? Accede ',
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16.0,
                color: Colors.black),
          ),
          Text("aquí",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: Theme.of(context).primaryColor))
        ]),
        onPressed: () => Navigator.pushReplacementNamed(context, 'login'),
      );
}
