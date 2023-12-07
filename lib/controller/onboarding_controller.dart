import 'package:get/get.dart';
import 'package:liquid_swipe/PageHelpers/LiquidController.dart';
import 'package:usefast/constant.dart';
import 'package:usefast/model/onboarding_model.dart';
import 'package:usefast/widgets/onboarding_widget.dart';

class OnboardingCongroller extends GetxController {
  OnboardingCongroller get getXID => Get.find<OnboardingCongroller>();

  final controller = LiquidController();
  RxInt currentPage = 0.obs;

  final pages = [
    onboardingWidget(
      model: OnboardingModel(
        image_name: 'assets/images/crypto.png',
        title: 'Sell Your Crypto',
        sub_title:
            'with FastPay you can sell your Crypto for easy and cash deposited in your bank account',
        counter: '1/3',
        bgColor: kPrimaryColor,
      ),
    ),
    onboardingWidget(
      model: OnboardingModel(
        image_name: 'assets/images/gift.png',
        title: 'Sell Your Gift Cards',
        sub_title:
            'we accept gift card of any type and FastPay is happy to purchase it from you',
        counter: '2/3',
        bgColor: kPrimaryColor,
      ),
    ),
    onboardingWidget(
      model: OnboardingModel(
        image_name: 'assets/images/bill.png',
        title: 'Pay Utility Bill',
        sub_title:
            'FastPay gives you the comfort to make payment for your utility bill',
        counter: '3/3',
        bgColor: kPrimaryColor,
      ),
    ),
  ];

  onPageChanged(int activePageIndex) => currentPage.value = activePageIndex;
  skip() => controller.jumpToPage(page: 6);

  animateToNextSlide() {
    int nextPage = controller.currentPage + 1;
    controller.animateToPage(page: nextPage);
  }
}