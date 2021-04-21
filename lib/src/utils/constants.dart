import 'package:flutter/material.dart';

// DROPDOWN ITEMS -----------------------------------------------------
const List<DropdownMenuItem<String>> categoryDropdownItems = [
  DropdownMenuItem(
    value: "Calle",
    child: Text(
      "Calle",
    ),
  ),
  DropdownMenuItem(
    value: "Rally",
    child: Text(
      "Rally",
    ),
  ),
];

const List<DropdownMenuItem<String>> fuelDropdownItems = [
  DropdownMenuItem(
    value: "Gasolina",
    child: Text(
      "Gasolina",
    ),
  ),
  DropdownMenuItem(
    value: "Hibrido",
    child: Text(
      "Híbrido",
    ),
  ),
];
//  ----------------------------------------------------- DROPDOWN ITEMS

// MULTISELECT ITEMS -----------------------------------------------------
const List<Map<String, Object>> multiselectCategory = [
  {
    "display": "Calle",
    "value": 1,
  },
  {
    "display": "Rally",
    "value": 2,
  },
];

const List<Map<String, Object>> multiselectFuel = [
  {
    "display": "Gasolina",
    "value": 1,
  },
  {
    "display": "Híbrido",
    "value": 2,
  },
];
//  ----------------------------------------------------- MULTISELECT ITEMS

// MODALBOTTON OPTIONS -----------------------------------------------------
const List<Widget> carKilometersValues = [
  Text('10.000'),
  Text('30.000'),
  Text('50.000'),
  Text('70.000'),
  Text('100.000'),
  Text('150.000'),
  Text('200.000'),
  Text('+200.000'),
];

const List<Widget> carPowerValues = [
  Text('100'),
  Text('200'),
  Text('250'),
  Text('300'),
  Text('350'),
  Text('400'),
  Text('500'),
  Text('+500'),
];
// ----------------------------------------------------- MODALBOTTON OPTIONS
