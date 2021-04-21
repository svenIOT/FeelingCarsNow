import 'package:flutter/material.dart';

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
