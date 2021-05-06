import 'package:flutter/material.dart';

const List<DropdownMenuItem<String>> categoryDropdownItems = [
  DropdownMenuItem(
    value: "Sin Homologar",
    child: Text(
      "Sin Homologar (circuito)",
    ),
  ),
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
    value: "Diesel",
    child: Text(
      "Diesel",
    ),
  ),
  DropdownMenuItem(
    value: "Hibrido",
    child: Text(
      "Híbrido",
    ),
  ),
];
