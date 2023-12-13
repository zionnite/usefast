import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usefast/constant.dart';
import 'package:usefast/controller/account_controller.dart';
import 'package:usefast/controller/lock_session.dart';
import 'package:usefast/controller/transaction_controller.dart';
import 'package:usefast/util/common.dart';
import 'package:usefast/widgets/buttons.dart';
import 'package:usefast/widgets/header.dart';

import 'trade_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final transactionController = TransactionController().getXID;
  final accountController = AccountController().getXID;
  final lockSession = LockSession().getXID;

  String? user_id;
  String? fullName;
  String? user_name;
  String? user_status;
  bool? admin_status;
  bool? isUserLogin;
  String? image_name;

  initUserDetail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId1 = prefs.getString('user_id');
    var userName1 = prefs.getString('user_name');
    var user_status1 = prefs.getString('user_status');
    var admin_status1 = prefs.getBool('admin_status');
    var isUserLogin1 = prefs.getBool('isUserLogin');
    var image_name1 = prefs.getString('image_name');
    var fullName1 = prefs.getString('full_name');
    var fingerprintAuth = prefs.getBool('fingerprintAuth');
    var lockPin = prefs.getString('lockPin');

    if (mounted) {
      setState(() {
        user_id = userId1;
        user_name = userName1;
        user_status = user_status1;
        admin_status = admin_status1;
        isUserLogin = isUserLogin1;
        image_name = image_name1;
        fullName = fullName1;
      });

      await accountController.getWallet(user_id, admin_status);
    }

    if (fingerprintAuth != null) {
      AppLock.of(Get.context!)!.enable();
    } else if (lockPin != null) {
      AppLock.of(Get.context!)!.enable();
    }
  }

  var current_page = 1;
  bool isLoading = false;
  bool widgetLoading = true;

  @override
  void initState() {
    initUserDetail();
    super.initState();
    checkIfNewApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            const Header(),
            const SizedBox(height: 20),
            const SizedBox(height: 15),
            InkWell(
              onTap: () {
                Get.to(() => const TradePage(transType: 'crypto'));
              },
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 7,
                  bottom: 7,
                  left: 10,
                  right: 10,
                ),
                child: FadeInUp(
                  duration: const Duration(milliseconds: 900),
                  child: Container(
                    height: 69,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: kSecondaryColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 15,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipOval(
                            child: Container(
                              height: 38,
                              width: 38,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.white, Colors.grey],
                                ),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 1,
                                  vertical: 1,
                                ),
                                child: Icon(LineAwesome.btc),
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Trade Crypto',
                                style: kInfo.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'sell now',
                                style: kInfo.copyWith(
                                  color: Colors.white30,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Get.to(() => const TradePage(
                      transType: 'gift',
                    ));
              },
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 7,
                  bottom: 7,
                  left: 10,
                  right: 10,
                ),
                child: FadeInUp(
                  duration: const Duration(milliseconds: 900),
                  child: Container(
                    height: 69,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: kSecondaryColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 15,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipOval(
                            child: Container(
                              height: 38,
                              width: 38,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.white, Colors.grey],
                                ),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 1,
                                  vertical: 1,
                                ),
                                child: Icon(LineAwesome.gift_solid),
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Trade Gift Card',
                                style: kInfo.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'sell now',
                                style: kInfo.copyWith(
                                  color: Colors.white30,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            // const SectionTitle(title: 'My Cards'),
            // const SizedBox(height: 15),
            // const CardList(),
            // const SizedBox(height: 40),
            const Buttons(),
            const SizedBox(height: 30),
            // const SectionTitle(title: 'Activity'),
            const SizedBox(height: 15),
            // const Chart(),
          ],
        ),
      ),
    );
  }
}
