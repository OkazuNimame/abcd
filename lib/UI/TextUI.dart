import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextUI extends StatelessWidget {
  TextEditingController controller;
  String label, hint;
  TextInputType textInputType;
  int? maxLenght,maxLine;
  TextInputFormatter? textInputFormatter;

  TextUI({
    required this.controller,
    required this.hint,
    required this.label,
    required this.textInputType,
    this.maxLenght,this.maxLine,this.textInputFormatter
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.yellow.withOpacity(0.9)
        ),
        child: TextField(
          controller: controller,
          maxLines: maxLine,
          maxLength: maxLenght,
          decoration: InputDecoration(label: Text(label), hint: Text(hint)),
          inputFormatters: textInputFormatter != null?[textInputFormatter!]:null,
          keyboardType: textInputType,
        ),
      )
    );
  }
}
