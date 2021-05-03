import 'package:flutter/material.dart';

import 'package:flutter_multiselect/flutter_multiselect.dart';
import 'package:feeling_cars_now/src/models/filter_model.dart';

class MultiselectCustom extends StatelessWidget {
  final String title;
  final List<Map<String, Object>> dataSource;
  final bool category;
  final Filter filter;
  final bool isRequired;

  MultiselectCustom(
      {@required this.title,
      @required this.dataSource,
      @required this.category,
      this.filter,
      this.isRequired});

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
        category
            ? filter.category = value?.cast<String>()
            : filter.fuel = value?.cast<String>();
      },
      selectIcon: Icons.arrow_drop_down_circle,
    );
  }
}
