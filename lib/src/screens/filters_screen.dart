import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'package:feeling_cars_now/src/widgets/text_header.dart';
import 'package:feeling_cars_now/src/models/filter_model.dart';
import 'package:feeling_cars_now/src/utils/utils.dart' as utils;
import 'package:feeling_cars_now/src/widgets/multiselect_custom.dart';
import 'package:feeling_cars_now/src/constants/multiselect_items_constants.dart'
    as multiselectItemsConstants;
import 'package:feeling_cars_now/src/constants/modalbutton_options_constants.dart'
    as modalbuttonOptionsConstants;

class FiltersScreen extends StatefulWidget {
  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final textController = TextEditingController();
  Filter filter = new Filter();

  @override
  void initState() {
    super.initState();
  }

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

  /// Crea el campo de texto para búsqueda por marca o modelo.
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
      child: TextFormField(
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

  /// Crea los filtros más específicos.
  Widget _createFilters(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          MultiselectCustom(
            title: 'Homologación',
            dataSource: multiselectItemsConstants.multiselectCategory,
            filter: filter,
            category: true,
          ),
          SizedBox(height: 20.0),
          MultiselectCustom(
            title: 'Combustible',
            dataSource: multiselectItemsConstants.multiselectFuel,
            filter: filter,
            category: false,
          ),
          SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TextHeader('Kilometros'),
              TextHeader('Potencia'),
            ],
          ),
          _kmAndPowerPickers(context),
          SizedBox(height: 20.0),
          TextHeader('Precio'),
          _pricePicker(context),
        ],
      ),
    );
  }

  /// Crea los selectores de kilómetros y potencia con valor inicial y final.
  Widget _kmAndPowerPickers(BuildContext context) {
    return Row(
      children: <Widget>[
        _createModalBottomSheet(
          header: '${filter.kmSince ?? 0} - ${filter.kmUntil ?? 0}',
          sinceOnItemChange: (index) => setState(() => filter.kmSince =
              int.tryParse(modalbuttonOptionsConstants
                  .carKilometersValues[index]
                  .replaceFirst('.', ''))),
          untilOnItemChange: (index) => setState(() => filter.kmUntil =
              int.tryParse(modalbuttonOptionsConstants
                  .carKilometersValues[index]
                  .replaceFirst('.', ''))),
          children: modalbuttonOptionsConstants.carKilometersValues
              .map((e) => Text(e))
              .toList(),
        ),
        SizedBox(width: 10.0),
        _createModalBottomSheet(
          header: '${filter.powerSince ?? 0} - ${filter.powerUntil ?? 0}',
          sinceOnItemChange: (index) => setState(() => filter.powerSince =
              int.tryParse(modalbuttonOptionsConstants.carPowerValues[index])),
          untilOnItemChange: (index) => setState(() => filter.powerUntil =
              int.tryParse(modalbuttonOptionsConstants.carPowerValues[index])),
          children: modalbuttonOptionsConstants.carPowerValues
              .map((e) => Text(e))
              .toList(),
        )
      ],
    );
  }

  /// Crea el selector de precio con valor inicial y final.
  Widget _pricePicker(BuildContext context) {
    return Row(
      children: <Widget>[
        _createModalBottomSheet(
          header: '${filter.priceSince ?? 0} - ${filter.priceUntil ?? 0}',
          sinceOnItemChange: (index) => setState(() => filter.priceSince =
              int.tryParse(modalbuttonOptionsConstants.carPriceValues[index]
                  .replaceFirst('.', ''))),
          untilOnItemChange: (index) => setState(() => filter.priceUntil =
              int.tryParse(modalbuttonOptionsConstants.carPriceValues[index]
                  .replaceFirst('.', ''))),
          children: modalbuttonOptionsConstants.carPriceValues
              .map((e) => Text(e))
              .toList(),
        ),
      ],
    );
  }

  /// Crea un selector "desde", "hasta". Recibe un objeto con las funciones a realizar cuando
  /// se modifica un valor y la lista de hijos a mostrar (valores).
  Widget _createModalBottomSheet(
      {String header,
      void Function(int) sinceOnItemChange,
      void Function(int) untilOnItemChange,
      List<Widget> children}) {
    final height = utils.getDeviceSize(context).height / 3;

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
                            onSelectedItemChanged: sinceOnItemChange,
                            children: children,
                          ),
                        ),
                        Expanded(
                          child: CupertinoPicker(
                              itemExtent: 50,
                              onSelectedItemChanged: untilOnItemChange,
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

  /// Crea el botón para aplicar los filtros en el estado actual. Elimina carácteres
  /// sobrantes de la búsqueda por texto.
  ///
  /// Al aplicar se guarda el estado, y se le pasa la clase filter a la siguiente página.
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

          // Inicializar filtros (listas) que sean nulos.
          if (filter.category == null) filter.category = [];
          if (filter.fuel == null) filter.fuel = [];
          if (filter.filteredCars == null) filter.filteredCars = [];
          Navigator.pushNamed(context, 'find', arguments: filter);
        },
      ),
    );
  }

  /// Resetea los campos de selección del formulario.
  Widget _createResetButton(BuildContext context) {
    return Container(
      child: ElevatedButton(
        child: Icon(MaterialCommunityIcons.restore),
        style: ElevatedButton.styleFrom(
          primary: Theme.of(context).primaryColor,
        ),
        onPressed: () {
          final FormState form = _formKey.currentState;
          form.reset();
          textController.text = '';
          setState(() {
            filter.kmSince = 0;
            filter.kmUntil = 0;
            filter.powerSince = 0;
            filter.powerUntil = 0;
            filter.priceSince = 0;
            filter.priceUntil = 0;
          });
        },
      ),
    );
  }
}
