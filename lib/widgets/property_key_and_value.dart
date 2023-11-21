import 'package:flutter/material.dart';

class PropertyKeyAndValue extends StatelessWidget {
  const PropertyKeyAndValue({
    required this.propsKey,
    required this.propsValue,
    this.check,
  });

  final bool? check;
  final String propsKey;
  final String propsValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: 15,
        right: 15,
        bottom: 20,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              propsKey,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(
            width: 150,
          ),
          Expanded(
            child: Text(
              propsValue,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
