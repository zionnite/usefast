import 'package:flutter/material.dart';
import 'package:usefast/constant.dart';
import 'package:usefast/util/common.dart';

class MyNumField extends StatefulWidget {
  MyNumField({
    required this.myTextFormController,
    required this.fieldName,
    this.onChange,
    this.prefix,
    this.suffix,
    this.hintText,
  });

  final TextEditingController myTextFormController;
  final String fieldName;
  final ValueChanged<String>? onChange;
  final IconData? prefix;
  final IconData? suffix;
  final String? hintText;

  @override
  State<MyNumField> createState() => _MyNumFieldState();
}

class _MyNumFieldState extends State<MyNumField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: TextField(
        style: const TextStyle(
          color: Colors.white,
        ),
        keyboardType: TextInputType.number,
        onChanged: widget.onChange,
        controller: widget.myTextFormController,
        decoration: InputDecoration(
          filled: true,
          fillColor: kSecondaryColor,
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: kSecondaryColor,
            ),
          ),
          labelText: widget.fieldName,
          labelStyle: const TextStyle(
            color: Colors.white,
          ),
          hintText: widget.hintText,
          prefixIcon: (widget.prefix != '' && widget.prefix != null)
              ? Icon(
                  widget.prefix,
                  color: textColorWhite,
                )
              : null,
          suffixIcon: (widget.suffix != '' && widget.suffix != null)
              ? Icon(
                  widget.suffix,
                  color: textColorWhite,
                )
              : null,
        ),
      ),
    );
  }
}
