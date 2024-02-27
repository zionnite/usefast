import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:usefast/services/api_services.dart';

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
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(40),
      ),
    ),
    builder: (BuildContext context) {
      return GiffyBottomSheet.image(
        Image.asset(
          '$image_name',
          height: 150,
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

const int CURRENT_APP_VERSION = 2;
const String baseDomain = 'https://app.usefastpay.ng/';
// const String baseDomain = 'http://localhost:8888/useFastPay/';
const String baseUrl = '${baseDomain}Api/';

// const String baseUrl  = 'http://localhost:8888/Api/';
// const String baseUrlSec  = 'http://localhost:8888/ApiMlm/';

checkIfNewApp() async {
  final int UPDATEDAPPVERSION = await ApiServices.isAppHasNewUpdate();
  var androidAppLink = await ApiServices.androidStoreLink();
  var iosAppLink = await ApiServices.iosStoreLink();
  if (UPDATEDAPPVERSION > CURRENT_APP_VERSION) {
    showUpgrade(androidAppLink, iosAppLink);
  }
}

showUpgrade(androidAppLink, iosAppLink) {
  return showModalBottomSheet(
    context: Get.context!,
    clipBehavior: Clip.antiAlias,
    isScrollControlled: true,
    isDismissible: false,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(40),
      ),
    ),
    builder: (BuildContext context) {
      return GiffyBottomSheet.image(
        Image.asset(
          "assets/images/fast_pay.png",
          height: 200,
          fit: BoxFit.cover,
        ),
        title: const Text(
          'New App Update!',
          textAlign: TextAlign.center,
        ),
        content: const Text(
          'New App Update is available on the Store, click on the Button to update to the new version',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'CANCEL'),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () async {
              if (Platform.isIOS) {
                _launchUniversalLinkIos(iosAppLink);
              }
              if (Platform.isAndroid) {
                _launchUniversalLinkIos(androidAppLink);
              }
              Get.back();
            },
            child: const Text('Update Now'),
          ),
        ],
      );
    },
  );
}

Future<void> _launchUniversalLinkIos(String link) async {
  if (await canLaunchUrl(Uri.parse(link))) {
    final bool nativeAppLaunchSucceeded = await launchUrl(
      Uri.parse(link),
      mode: LaunchMode.externalNonBrowserApplication,
    );
    if (!nativeAppLaunchSucceeded) {
      await launchUrl(
        Uri.parse(link),
        mode: LaunchMode.inAppWebView,
      );
    }
  }
}
