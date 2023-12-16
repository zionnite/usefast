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
        image_name: 'assets/images/gift.png',
        title: 'Sell Your Gift Cards',
        sub_title:
            'we accept gift card of any type and FastPay is happy to purchase it from you',
        counter: '1/3',
        bgColor: kPrimaryColor,
      ),
    ),
    onboardingWidget(
      model: OnboardingModel(
        image_name: 'assets/images/crypto.png',
        title: 'Buy Airtime',
        sub_title: 'with FastPay you can easily make purchase for your airtime',
        counter: '2/3',
        bgColor: kPrimaryColor,
      ),
    ),
    onboardingWidget(
      model: OnboardingModel(
        image_name: 'assets/images/bill.png',
        title: 'Buy Electricity Bill',
        sub_title:
            'FastPay gives you the comfort to make payment for your Electricity bill and many more',
        counter: '3/3',
        bgColor: kPrimaryColor,
      ),
    ),
  ];

  onPageChanged(int activePageIndex) => currentPage.value = activePageIndex;
  skip() => controller.jumpToPage(page: 2);

  animateToNextSlide() {
    int nextPage = controller.currentPage + 1;
    controller.animateToPage(page: nextPage);
  }
}
