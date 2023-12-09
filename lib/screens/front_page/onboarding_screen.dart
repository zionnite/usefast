import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:usefast/controller/onboarding_controller.dart';
import 'package:usefast/screens/front_page/login_page.dart';

class OnboardingPage extends StatefulWidget {
  OnboardingPage();

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  Widget build(BuildContext context) {
    // widget.timer1.cancel();
    // widget.timer2.cancel();

    final onboardingController = OnboardingCongroller().getXID;
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          LiquidSwipe(
            enableSideReveal: true,
            slideIconWidget: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            liquidController: onboardingController.controller,
            onPageChangeCallback: onboardingController.onPageChanged,
            pages: onboardingController.pages,
          ),
          Obx(
            () => Positioned(
              bottom: 40,
              child: (onboardingController.currentPage.value == 2)
                  ? InkWell(
                      onTap: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setBool('isFirstTime', true);
                        Get.offAll(() => const LoginPage());
                      },
                      child: Card(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Continue',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : OutlinedButton(
                      style: ElevatedButton.styleFrom(
                        side: const BorderSide(color: Colors.white60),
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(20),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () =>
                          onboardingController.animateToNextSlide(),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black,
                        ),
                        child: const Icon(
                          Icons.arrow_forward_ios_sharp,
                        ),
                      ),
                    ),
            ),
          ),
          Obx(
            () => (onboardingController.currentPage.value == 2)
                ? Container()
                : Positioned(
                    top: 50,
                    right: 20,
                    child: TextButton(
                      onPressed: () => onboardingController.skip(),
                      child: const Text(
                        'skip',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
          ),
          Obx(
            () => Positioned(
              bottom: 25,
              child: (onboardingController.currentPage.value == 2)
                  ? Container()
                  : AnimatedSmoothIndicator(
                      activeIndex: onboardingController.currentPage.value,
                      count: 3,
                      effect: const WormEffect(
                        activeDotColor: Colors.white,
                        dotHeight: 5.0,
                        dotColor: Colors.black,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
