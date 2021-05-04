import 'package:flutter/material.dart';
import 'package:feeling_cars_now/src/bloc/login_bloc.dart';
import 'package:feeling_cars_now/src/bloc/provider.dart';
import 'package:feeling_cars_now/src/providers/user_provider.dart';
import 'package:feeling_cars_now/src/utils/utils.dart';

class RegisterScreen extends StatelessWidget {
  final userProvider = new UserProvider();

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

  Widget _loginForm(BuildContext context, Size size) {
    final bloc = Provider.of(context);

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SafeArea(child: Container(height: 200.0)),
          Container(
            width: size.width * 0.85,
            margin: EdgeInsets.symmetric(vertical: 30.0),
            padding: EdgeInsets.symmetric(vertical: 50.0),
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
                Text('Crear cuenta', style: TextStyle(fontSize: 20.0)),
                SizedBox(height: 60.0),
                _createEmail(bloc),
                SizedBox(height: 30.0),
                _createPassword(bloc),
                SizedBox(height: 30.0),
                _createButton(bloc)
              ],
            ),
          ),
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(primary: Colors.white30, elevation: 0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
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
          ),
          SizedBox(height: 100.0)
        ],
      ),
    );
  }

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

  _register(BuildContext context, LoginBloc bloc) async {
    final info = await userProvider.newUser(bloc.email, bloc.password);

    return (info['ok'])
        ? Navigator.pushReplacementNamed(context, 'home')
        : showAlert(context,
            'Ya existe una cuenta con ese email,\ninfo: ' + info['message']);
  }

  Widget _createBackground(BuildContext context, Size size) => Container(
        height: size.height * 0.4,
        width: double.infinity,
        child: Image(
          image: AssetImage('assets/img/logo-nocircles.png'),
          fit: BoxFit.fill,
        ),
      );
}
