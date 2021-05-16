import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import 'package:feeling_cars_now/src/utils/utils.dart';
import 'package:feeling_cars_now/src/bloc/auth_bloc.dart';
import 'package:feeling_cars_now/src/bloc/login_bloc.dart';
import 'package:feeling_cars_now/src/services/user_service.dart';
import 'package:feeling_cars_now/src/utils/utils.dart' as utils;
import 'package:feeling_cars_now/src/bloc/provider.dart' as myProvider;
import 'package:feeling_cars_now/src/user_preferences/user_preferences.dart';

class LoginScreen extends StatelessWidget {
  static final String routeName = 'login';
  final prefs = new UserPreferences();
  final _userService = new Userservice();

  @override
  Widget build(BuildContext context) {
    prefs.lastScreen = LoginScreen.routeName;
    final size = utils.getDeviceSize(context);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          _createBackground(context, size),
          _loginForm(context, size),
        ],
      ),
    );
  }

  Widget _loginForm(BuildContext context, Size size) {
    final bloc = myProvider.Provider.of(context);
    final googleAuthBloc = Provider.of<AuthBloc>(context);

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
                  Icons.account_circle,
                  size: 80,
                  color: Theme.of(context).primaryColor,
                ),
                Text('Datos de acceso', style: TextStyle(fontSize: 20.0)),
                SizedBox(height: 60.0),
                _createEmail(bloc),
                SizedBox(height: 30.0),
                _createPassword(bloc),
                SizedBox(height: 30.0),
                _createLoginButton(bloc),
                SizedBox(height: 30.0),
                SignInButton(Buttons.Google,
                    text: 'Inicia sesión con Google',
                    onPressed: () async =>
                        await googleAuthBloc.loginWithGoogle()
                            ? Navigator.pushReplacementNamed(context, 'home')
                            : null),
              ],
            ),
          ),
          _registerNewAccount(context),
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
                icon: Icon(Icons.alternate_email,
                    color: Theme.of(context).primaryColor),
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
                icon: Icon(Icons.lock_outline,
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

  /// Crea el botón de acceder.
  Widget _createLoginButton(LoginBloc bloc) => StreamBuilder(
        stream: bloc.formValidStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return ElevatedButton(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
              child: Text('Acceder'),
            ),
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).primaryColor,
            ),
            onPressed: snapshot.hasData ? () => _login(context, bloc) : null,
          );
        },
      );

  /// LLama al userService y comprueba que existe el usuario.
  ///
  /// Si hace login accede, sino muestra mensaje de error.
  _login(BuildContext context, LoginBloc bloc) async {
    Map info = await _userService.login(bloc.email, bloc.password);

    return (info['ok'])
        ? Navigator.pushReplacementNamed(context, 'home')
        : showAlert(
            context, 'Email o contraseña no válido,\ninfo: ' + info['message']);
  }

  /// Crea el fondo de la cabecera
  Widget _createBackground(BuildContext context, Size size) => Container(
        height: size.height * 0.4,
        width: double.infinity,
        child: Image(
          image: AssetImage('assets/img/logo.png'),
          fit: BoxFit.fill,
        ),
      );

  /// Muestra el botón que redirige al formulario para registrar usuarios.
  Widget _registerNewAccount(BuildContext context) => ElevatedButton(
        style: ElevatedButton.styleFrom(primary: Colors.white30, elevation: 0),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Text(
            '¿No tienes cuenta? Crea una ',
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
        onPressed: () => Navigator.pushReplacementNamed(context, 'register'),
      );
}
