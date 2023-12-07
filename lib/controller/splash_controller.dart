import 'dart:async';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usefast/screens/front_page/login_page.dart';
import 'package:usefast/screens/front_page/onboarding_screen.dart';
import 'package:usefast/widgets/bottom_bar.dart';

class SplashController extends GetxController {
  SplashController get getXID => Get.find<SplashController>();

  RxBool animate = false.obs;
  late Timer timer1, timer2;

  Future startAnimation() async {
    if (!animate.value) {
      await Future.delayed(const Duration(milliseconds: 500));
      animate.value = true;
      await Future.delayed(const Duration(milliseconds: 7000));

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var isUserLogin = prefs.getBool('isUserLogin');
      var isGuestLogin = prefs.getBool('isGuestLogin');
      var isFirstTime = prefs.getBool('isFirstTime');
      var userId1 = prefs.getString('user_id');
      var demoStatus = prefs.getBool("displayShowCase");

      // print('iS FIRST TIME $isFirstTime');
      if (isFirstTime == null) {
        return Get.offAll(() => OnboardingPage());
      }

      if (isUserLogin != null) {
        return Get.offAll(() => const BottomBar());
        // return Get.offAll(() => const BlissHome());
      } else {
        if (isGuestLogin != null) {
          return Get.offAll(() => const BottomBar());
          // return Get.offAll(() => const BlissHome());
        } else {
          return Get.to(() => const LoginPage());
          // return Get.offAll(() => const BlissHome());
        }
      }
    }
  }
}
