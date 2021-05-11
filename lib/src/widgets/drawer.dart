import 'package:flutter/material.dart';

import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

import 'package:feeling_cars_now/src/user_preferences/user_preferences.dart';
import 'package:feeling_cars_now/src/bloc/auth_bloc.dart';

class UserDrawer extends StatelessWidget {
  final prefs = new UserPreferences();

  @override
  Widget build(BuildContext context) {
    final googleAuthBloc = Provider.of<AuthBloc>(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(),
          SizedBox(height: 5.0),
          _createDrawerItem(
            context: context,
            icon: MaterialCommunityIcons.car_back,
            text: 'Mis coches',
            onTap: () => Navigator.pushNamed(context, 'resume'),
          ),
          _createDrawerItem(
            context: context,
            icon: Icons.question_answer,
            text: 'Mensajes',
            onTap: () => Navigator.pushNamed(context, 'resume'),
          ),
          Divider(),
          _createDrawerItem(
            context: context,
            icon: Icons.help_center,
            text: 'Preguntas frecuentes',
            onTap: () => Navigator.pushNamed(context, 'faq'),
          ),
          _createDrawerItem(
            context: context,
            icon: Icons.settings,
            text: 'Preferencias',
            onTap: () => Navigator.pushNamed(context, 'preferences'),
          ),
          Divider(),
          _createDrawerItem(
            context: context,
            icon: Icons.bug_report,
            text: 'Reportar un error',
            onTap: () => Navigator.pushNamed(context, 'error'),
          ),
          Divider(),
          _createDrawerItem(
            context: context,
            icon: Icons.logout,
            text: 'Cerrar sesión',
            onTap: () {
              // Cerrar sesión con google
              googleAuthBloc?.logout();
              Navigator.pushReplacementNamed(context, 'login');
            },
          ),
          ListTile(
            title: Text('0.0.1'),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _createDrawerItem(
      {BuildContext context,
      IconData icon,
      String text,
      GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon, color: Theme.of(context).primaryColor),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _createHeader() => DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage('assets/img/drawer_header.jpg'),
          ),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              bottom: 12.0,
              left: 16.0,
              child: Text(
                // Si el usuario no tiene nombre se le asigna
                prefs.username.trim() == ""
                    ? 'Usuario-' +
                        prefs.token.substring(prefs.token.toString().length - 6,
                            prefs.token.toString().length)
                    : prefs.username,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
}
