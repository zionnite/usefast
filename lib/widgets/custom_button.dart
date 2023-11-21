import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constant.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final String svgPath;
  final VoidCallback onTap;

  const CustomButton({
    Key? key,
    required this.title,
    required this.svgPath,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 53,
      width: 160,
      child: TextButton.icon(
        label: Text(title),
        icon: SvgPicture.asset(svgPath),
        onPressed: onTap,
        style: TextButton.styleFrom(
          primary: kTextColor,
          backgroundColor: kSecondaryColor,
          textStyle: kSFUI16,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(9),
            ),
          ),
        ),
      ),
    );
  }
}
