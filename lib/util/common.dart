import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giffy_dialog/giffy_dialog.dart';

Color backgroundColorPrimary = Colors.blue.shade900;
Color backgroundColorLight = const Color(0xff7c43bd);
Color backgroundColorDark = const Color(0xff512DA8);
Color backgroundColorAccent = Colors.purple;
Color textColorWhite = const Color(0xffffffff);

Color blackColor = const Color(0xff19191b);
Color greyColor = const Color(0xff8f8f8f);
Color blueColor = const Color(0xff2b9ed4);
Color userCircleBackground = const Color(0xff2b2b33);
Color onlineDotColor = const Color(0xff46dc64);
Color lightBlueColor = const Color(0xff0077d7);
Color separatorColor = const Color(0xff272c35);

Color gradientColorStart = const Color(0xff00b6f3);
Color gradientColorEnd = const Color(0xff0184dc);

Color senderColor = const Color(0xff2b343b);
Color receiverColor = const Color(0xff1e2225);

showSnackBar({
  required String title,
  required String msg,
  required Color backgroundColor,
  Duration duration = const Duration(seconds: 3),
}) {
  Get.snackbar(
    title,
    msg,
    backgroundColor: backgroundColor,
    colorText: Colors.white,
    snackPosition: SnackPosition.BOTTOM,
    duration: duration,
    // duration:
  );
}

displayBottomSheetFeedback({
  required BuildContext context,
  required String title,
  required String desc,
  required String image_name,
  required VoidCallback onTap,
  required VoidCallback onTapCancel,
}) {
  showModalBottomSheet(
    context: context,
    clipBehavior: Clip.antiAlias,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(40),
      ),
    ),
    builder: (BuildContext context) {
      return GiffyBottomSheet.image(
        Image.asset(
          '$image_name',
          height: 200,
          // fit: BoxFit.cover,
        ),
        title: Text(
          '$title',
          textAlign: TextAlign.center,
        ),
        content: Container(
          width: MediaQuery.of(context).size.width,
          child: Text(
            '$desc',
            textAlign: TextAlign.center,
          ),
        ),
        actions: [
          TextButton(
            onPressed: onTapCancel,
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: onTap,
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}

const int CURRENT_APP_VERSION = 4;
// const String baseDomain = 'https://ogabliss.com/';
const String baseDomain = 'http://localhost:8888/usefastpay/';
const String baseUrl = '${baseDomain}Api/';

// const String baseUrl  = 'http://localhost:8888/Api/';
// const String baseUrlSec  = 'http://localhost:8888/ApiMlm/';
