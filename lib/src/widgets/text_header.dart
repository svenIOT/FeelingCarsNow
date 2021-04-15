import 'package:flutter/material.dart';

class TextHeader extends StatelessWidget {
  TextHeader(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
