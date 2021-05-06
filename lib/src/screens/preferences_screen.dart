import 'package:flutter/material.dart';

import 'package:feeling_cars_now/src/user_preferences/user_preferences.dart';

class PreferencesScreen extends StatefulWidget {
  static final String routeName = 'settings';

  @override
  _PreferencesScreenState createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  bool _secondaryColor;
  int _genre;
  String _name = "";

  TextEditingController _textController;

  final prefs = new UserPreferences();

  @override
  void initState() {
    super.initState();
    _genre = prefs.genre;
    _secondaryColor = prefs.secondaryColor;
    _textController = new TextEditingController(text: prefs.username);
    prefs.lastPage = PreferencesScreen.routeName;
  }

  _setSelectedRadio(int value) {
    prefs.genre = value;
    setState(() => _genre = value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          appBar: AppBar(
              title: Text('Ajustes'),
              backgroundColor: (prefs.secondaryColor)
                  ? Colors.grey[700]
                  : Theme.of(context).primaryColor),
          body: ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(15.0),
                child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                      labelText: 'Nombre de usuario',
                      hintText: 'ej: Yoshida Special 930'),
                  onChanged: (value) => prefs.username = value,
                ),
              ),
              RadioListTile(
                value: 1,
                title: Text('Masculino'),
                groupValue: _genre,
                onChanged: _setSelectedRadio,
              ),
              RadioListTile(
                  value: 2,
                  title: Text('Femenino'),
                  groupValue: _genre,
                  onChanged: _setSelectedRadio),
              Divider(),
              SwitchListTile(
                value: _secondaryColor,
                title: Text('Color secundario'),
                onChanged: (value) {
                  prefs.secondaryColor = value;
                  setState(() => _secondaryColor = value);
                },
              ),
            ],
          )),
    );
  }
}
