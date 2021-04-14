import 'package:flutter/material.dart';
import 'package:feeling_cars_now/src/routes/routes.dart';

class UserDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(),
          SizedBox(height: 5.0),
          _createDrawerItem(
            icon: Icons.car_rental,
            text: 'Mis coches',
            onTap: () => Navigator.pushNamed(context, 'resume'),
          ),
          _createDrawerItem(
            icon: Icons.event,
            text: 'Events',
            onTap: () => Navigator.pushNamed(context, 'resume'),
          ),
          Divider(),
          _createDrawerItem(
            icon: Icons.collections_bookmark,
            text: 'Steps',
            onTap: () => Navigator.pushNamed(context, 'resume'),
          ),
          _createDrawerItem(
            icon: Icons.settings,
            text: 'Preferencias',
            onTap: () => Navigator.pushNamed(context, 'resume'),
          ),
          Divider(),
          _createDrawerItem(
            icon: Icons.bug_report,
            text: 'Reportar un error',
            onTap: () => Navigator.pushNamed(context, 'resume'),
          ),
          Divider(),
          _createDrawerItem(
            icon: Icons.logout,
            text: 'Cerrar sesión',
            onTap: () => Navigator.pushReplacementNamed(context, 'login'),
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
      {IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _createHeader() {
    return DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage('assets/no-image.png'), // TODO: fondo header
        ),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 12.0,
            left: 16.0,
            child: Text(
              "Usuario", // TODO: añadir usuario
              style: TextStyle(
                color: Colors.white,
                fontSize: 21.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
