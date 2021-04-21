import 'package:flutter/material.dart';

import 'package:flutter_multiselect/flutter_multiselect.dart';

class MultiselectCustom extends StatelessWidget {
  final String title;
  final List<Map<String, Object>> dataSource;
  final bool isRequired;

  MultiselectCustom(
      {@required this.title, @required this.dataSource, this.isRequired});

  @override
  Widget build(BuildContext context) {
    return MultiSelect(
      autovalidate: false,
      titleText: title,
      errorText: 'Por favor selecciona 1 o más opciones',
      dataSource: dataSource,
      textField: 'display',
      valueField: 'value',
      filterable: true,
      required: isRequired ?? false,
      value: null,
      onSaved: (value) {
        print('The value is $value');
      },
      selectIcon: Icons.arrow_drop_down_circle,
    );
  }
}
