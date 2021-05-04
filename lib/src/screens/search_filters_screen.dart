import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_icons/flutter_icons.dart';
import 'package:feeling_cars_now/src/constants/multiselect_items_constants.dart'
    as MultiselectItemsConstants;
import 'package:feeling_cars_now/src/constants/modalbutton_options_constants.dart'
    as ModalbuttonOptionsConstants;
import 'package:feeling_cars_now/src/widgets/multiselect_custom.dart';
import 'package:feeling_cars_now/src/widgets/text_header.dart';
import 'package:feeling_cars_now/src/utils/utils.dart' as Utils;
import 'package:feeling_cars_now/src/models/filter_model.dart';

class SearchAndFiltersScreen extends StatefulWidget {
  @override
  _SearchAndFiltersScreenState createState() => _SearchAndFiltersScreenState();
}

class _SearchAndFiltersScreenState extends State<SearchAndFiltersScreen> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final textController = TextEditingController();
  Filter filter = new Filter();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Búsqueda y filtros'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 30.0),
          child: Column(
            children: <Widget>[
              Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      // Barra de búsqueda
                      _createSearchInput(context),
                      SizedBox(height: 20.0),
                      // filtros
                      _createFilters(context),
                      SizedBox(height: 20.0),
                      // Botones
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          _createResetButton(context),
                          _createApllyButton(context),
                        ],
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget _createSearchInput(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).primaryColor,
          width: 2,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: TextField(
        controller: textController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: 'Buscar...',
          contentPadding: EdgeInsets.all(10),
        ),
        onChanged: (String value) => value = textController.text,
      ),
    );
  }

  Widget _createFilters(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          MultiselectCustom(
            title: 'Homologación',
            dataSource: MultiselectItemsConstants.multiselectCategory,
            filter: filter,
            category: true,
          ),
          SizedBox(height: 20.0),
          MultiselectCustom(
            title: 'Combustible',
            dataSource: MultiselectItemsConstants.multiselectFuel,
            filter: filter,
            category: false,
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TextHeader('Kilometros'),
              TextHeader('Potencia'),
            ],
          ),
          _kmAndPowerPickers(context),
        ],
      ),
    );
  }

  Widget _createApllyButton(BuildContext context) {
    return Container(
      child: ElevatedButton(
        child: Row(
          children: [Text('Aplicar   '), Icon(FontAwesome.flag_checkered)],
        ),
        style: ElevatedButton.styleFrom(
          primary: Theme.of(context).primaryColor,
        ),
        onPressed: () {
          // Eliminar espacios sobrantes y guardar palabras
          filter.searchWords = textController.text
              .replaceAll(RegExp(' +'), ' ')
              .trimRight()
              .trimLeft();
          // Guardar estado
          final FormState form = _formKey.currentState;
          form.save();
          // Navegar a una nueva página con los resultados
          Navigator.pushNamed(context, 'find', arguments: filter);
        },
      ),
    );
  }

  Widget _createResetButton(BuildContext context) {
    return Container(
      child: ElevatedButton(
        child: Icon(MaterialCommunityIcons.restore),
        style: ElevatedButton.styleFrom(
          primary: Theme.of(context).primaryColor,
        ),
        onPressed: () {
          // TODO: Reset campos
        },
      ),
    );
  }

  Widget _kmAndPowerPickers(BuildContext context) {
    return Row(
      children: <Widget>[
        _createModalBottomSheet(
          header: '${filter.kmSince ?? 0} - ${filter.kmUntil ?? 0}',
          firstOnItemChange: (index) => setState(() => filter.kmSince =
              int.tryParse(ModalbuttonOptionsConstants
                  .carKilometersValues[index]
                  .replaceFirst('.', ''))),
          secondOnItemChange: (index) => setState(() => filter.kmUntil =
              int.tryParse(ModalbuttonOptionsConstants
                  .carKilometersValues[index]
                  .replaceFirst('.', ''))),
          children: ModalbuttonOptionsConstants.carKilometersValues
              .map((e) => Text(e))
              .toList(),
        ),
        SizedBox(width: 10.0),
        _createModalBottomSheet(
          header: '${filter.powerSince ?? 0} - ${filter.powerUntil ?? 0}',
          firstOnItemChange: (index) => setState(() => filter.powerSince =
              int.tryParse(ModalbuttonOptionsConstants.carPowerValues[index])),
          secondOnItemChange: (index) => setState(() => filter.powerUntil =
              int.tryParse(ModalbuttonOptionsConstants.carPowerValues[index])),
          children: ModalbuttonOptionsConstants.carPowerValues
              .map((e) => Text(e))
              .toList(),
        )
      ],
    );
  }

  Widget _createModalBottomSheet(
      {String header,
      void Function(int) firstOnItemChange,
      void Function(int) secondOnItemChange,
      List<Widget> children}) {
    final height = Utils.getDeviceSize(context).height / 3;

    return Expanded(
      child: MaterialButton(
        child: Text(
          header,
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        color: Colors.grey[200],
        onPressed: () => showModalBottomSheet(
          context: context,
          builder: (BuildContext builder) => Container(
            height: height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [TextHeader('Desde'), TextHeader('Hasta')],
                  ),
                ),
                Expanded(
                  child: Container(
                    height: height,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: CupertinoPicker(
                            itemExtent: 50,
                            onSelectedItemChanged: firstOnItemChange,
                            children: children,
                          ),
                        ),
                        Expanded(
                          child: CupertinoPicker(
                              itemExtent: 50,
                              onSelectedItemChanged: secondOnItemChange,
                              children: children),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
