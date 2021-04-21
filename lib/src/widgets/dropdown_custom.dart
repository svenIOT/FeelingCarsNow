import 'package:flutter/material.dart';

import 'package:feeling_cars_now/src/models/car_model.dart';

class DropdownCustom extends StatefulWidget {
  final List<DropdownMenuItem<String>> items;
  final String hintText;
  final CarModel car;

  DropdownCustom({@required this.items, this.hintText, this.car});

  @override
  _DropdownCustomState createState() => _DropdownCustomState();
}

class _DropdownCustomState extends State<DropdownCustom> {
  String _value;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      items: widget.items,
      onChanged: (value) {
        if (widget.car != null) {
          setState(() {
            // Cambiar el valor del dropdown
            _value = value;
            // Asignar valor según si es categoría o combustible al coche que se va a guardar
            final firstItem = widget.items[0].value.toString();
            firstItem.contains("Gasolina") || firstItem.contains("Hibrido")
                ? widget.car.fuel = value
                : widget.car.category = value;
          });
        } else {
          // Filtros TODO: pasar _value a "X" para enviarlo a la findPage (Clase Filter??)
          setState(() {
            _value = value;
          });
        }
      },
      value: _value,
      elevation: 2,
      style: TextStyle(color: Colors.black54, fontSize: 18.0),
      isDense: true,
      iconSize: 40.0,
      isExpanded: true,
      hint: Text(
        widget.hintText ?? "",
        style: TextStyle(fontSize: 18.0),
      ),
    );
  }
}
