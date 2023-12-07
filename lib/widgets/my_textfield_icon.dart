import 'package:flutter/material.dart';
import 'package:usefast/constant.dart';
import 'package:usefast/util/common.dart';

class MyTextFieldIcon extends StatefulWidget {
  MyTextFieldIcon({
    required this.myTextFormController,
    required this.fieldName,
    this.onChange,
    this.prefix,
    this.suffix,
    this.enableDisable = true,
    this.isPassword = false,
  });

  final TextEditingController myTextFormController;
  final String fieldName;
  final ValueChanged<String>? onChange;
  final IconData? prefix;
  final IconData? suffix;
  final bool enableDisable;
  final bool isPassword;

  @override
  State<MyTextFieldIcon> createState() => _MyTextFieldIconState();
}

class _MyTextFieldIconState extends State<MyTextFieldIcon> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: TextFormField(
        style: const TextStyle(
          color: Colors.white,
        ),
        obscureText: widget.isPassword,
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
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white12,
            ),
          ),
          labelText: widget.fieldName,
          labelStyle: const TextStyle(
            color: Colors.white,
          ),
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
          enabled: widget.enableDisable,
        ),
      ),
    );
  }
}
