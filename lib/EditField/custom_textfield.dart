import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {

  final String labText;
  final TextEditingController Controller;
  final TextInputType KeyboardType;


  CustomTextField( this.labText , this.Controller , this.KeyboardType);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: Controller,
      keyboardType: KeyboardType,
      decoration: InputDecoration(
        labelText: labText,
      ),
    );
  }
}
