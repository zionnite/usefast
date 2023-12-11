import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usefast/screens/front_page/login_page.dart';
import 'package:usefast/screens/front_page/onboarding_screen.dart';
import 'package:usefast/widgets/bottom_bar.dart';

class SplashController extends GetxController {
  SplashController get getXID => Get.find<SplashController>();

  RxBool animate = false.obs;
  late Timer timer1, timer2;

  @override
  void onInit() async {
    super.onInit();
  }

  bool? isUserLogin;
  bool? isGuestLogin;
  bool? isFirstTime;
  String? userId1;
  bool? demoStatus;
  startAnimationTimer() async {
    await Future.delayed(const Duration(milliseconds: 500));
    animate.value = true;
    await Future.delayed(const Duration(milliseconds: 7000));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    isUserLogin = prefs.getBool('isUserLogin');
    isGuestLogin = prefs.getBool('isGuestLogin');
    isFirstTime = prefs.getBool('isFirstTime');
    userId1 = prefs.getString('user_id');
    demoStatus = prefs.getBool("displayShowCase");
  }

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
        showLockScreen();
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

  showLockScreen() {
    BuildContext context = Get.context!;
    AppLock.of(context)!.showLockScreen();
  }
}
