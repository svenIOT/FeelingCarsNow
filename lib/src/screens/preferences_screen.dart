import 'package:flutter/material.dart';

import 'package:feeling_cars_now/src/widgets/drawer.dart';
import 'package:feeling_cars_now/src/widgets/text_header.dart';
import 'package:feeling_cars_now/src/utils/utils.dart' as utils;
import 'package:feeling_cars_now/src/user_preferences/user_preferences.dart';

class PreferencesScreen extends StatefulWidget {
  static final String routeName = 'preferences';

  @override
  _PreferencesScreenState createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  bool _secondaryColor;
  int _accountType;

  TextEditingController _textController;

  final prefs = new UserPreferences();

  @override
  void initState() {
    super.initState();
    _accountType = prefs.accountType;
    _secondaryColor = prefs.secondaryColor;
    _textController = new TextEditingController(text: prefs.username);
    prefs.lastScreen = PreferencesScreen.routeName;
  }

  _setSelectedRadio(int value) {
    prefs.accountType = value;
    setState(() => _accountType = value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          appBar: AppBar(
            title: Text('Ajustes'),
            backgroundColor:
                utils.getActualColor(context, prefs.secondaryColor),
          ),
          drawer: UserDrawer(),
          body: ListView(
            children: <Widget>[
              _createContainerBox(<Widget>[
                TextHeader('Ajustes de usuario'),
                SizedBox(height: 5.0),
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
                  title: Text('Particular'),
                  groupValue: _accountType,
                  onChanged: _setSelectedRadio,
                ),
                RadioListTile(
                    value: 2,
                    title: Text('Empresa'),
                    groupValue: _accountType,
                    onChanged: _setSelectedRadio),
              ]),
              SizedBox(height: 20.0),
              _createContainerBox(
                <Widget>[
                  TextHeader('Ajustes de la App'),
                  SizedBox(height: 5.0),
                  SwitchListTile(
                    value: _secondaryColor,
                    title: Text('Color secundario'),
                    onChanged: (value) {
                      prefs.secondaryColor = value;
                      setState(() => _secondaryColor = value);
                    },
                  ),
                ],
              )
            ],
          )),
    );
  }

  Widget _createContainerBox(List<Widget> _children) => Container(
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _children,
        ),
      );
}
