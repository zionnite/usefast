import 'package:animate_do/animate_do.dart';
import 'package:crisp_chat/crisp_chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usefast/constant.dart';
import 'package:usefast/controller/account_controller.dart';
import 'package:usefast/controller/lock_session.dart';
import 'package:usefast/controller/transaction_controller.dart';
import 'package:usefast/screens/bill_page.dart';
import 'package:usefast/util/common.dart';
import 'package:usefast/widgets/header.dart';

import 'add_funds.dart';
import 'purchase_bill.dart';
import 'purchase_bill_cable.dart';
import 'purchase_bill_data.dart';
import 'purchase_bill_electricity.dart';
import 'purchase_bill_wifi.dart';
import 'request_withdraw.dart';

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

  final String websiteID = '0ba48f9a-3159-4a42-b1d1-24d49df5a3ec';
  late CrispConfig config;

  @override
  void initState() {
    initUserDetail();
    super.initState();
    checkIfNewApp();

    config = CrispConfig(
      websiteID: websiteID,
    );
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
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 7,
                      bottom: 7,
                      left: 10,
                    ),
                    child: FadeInUp(
                      duration: const Duration(milliseconds: 900),
                      child: Container(
                        height: 100,
                        width: 200,
                        decoration: BoxDecoration(
                          color: kSecondaryColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                              right: 20,
                              top: 25,
                              bottom: 15,
                            ),
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    AppLock.of(context)!.disable();
                                    Get.to(() => const AddFunds());
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      ClipOval(
                                        child: Container(
                                          height: 38,
                                          width: 38,
                                          decoration: const BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Colors.white,
                                                Colors.grey
                                              ],
                                            ),
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 1,
                                              vertical: 1,
                                            ),
                                            child: Icon(Icons.credit_card),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'Deposit',
                                        style: kInfo.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 7,
                      bottom: 7,
                      right: 10,
                    ),
                    child: FadeInUp(
                      duration: const Duration(milliseconds: 900),
                      child: Container(
                        height: 100,
                        width: 200,
                        decoration: BoxDecoration(
                          color: kSecondaryColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                              right: 20,
                              top: 25,
                              bottom: 15,
                            ),
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Get.to(() => const RequestWithdraw());
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      ClipOval(
                                        child: Container(
                                          height: 38,
                                          width: 38,
                                          decoration: const BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Colors.white,
                                                Colors.grey
                                              ],
                                            ),
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 1,
                                              vertical: 1,
                                            ),
                                            child:
                                                Icon(Icons.water_drop_outlined),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'Withdrawal',
                                        style: kInfo.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 7,
                bottom: 7,
                left: 10,
                right: 10,
              ),
              child: FadeInUp(
                duration: const Duration(milliseconds: 900),
                child: Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: kSecondaryColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 25,
                        bottom: 15,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.to(
                                () => const PurchaseUtilityBill(
                                    utilityType: 'airtime'),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
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
                                      child: Icon(Icons.phone_android),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Top-up',
                                  style: kInfo.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Get.to(
                                () =>
                                    const PurchaseBillData(utilityType: 'data'),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
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
                                        horizontal: 5,
                                        vertical: 1,
                                      ),
                                      child: Icon(Icons.network_cell_outlined),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Data',
                                  style: kInfo.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Get.to(
                                () => const PurchaseBillElectricity(
                                    utilityType: 'electricity'),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
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
                                      child: Icon(Icons.power),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Power',
                                  style: kInfo.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Get.to(() => const BillPage());
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
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
                                      child: Icon(Icons.more_horiz_rounded),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'More',
                                  style: kInfo.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey.shade700,
        tooltip: 'Chat with support',
        onPressed: () async {
          await FlutterCrispChat.openCrispChat(
            config: config,
          );
        },
        child: const Icon(Icons.chat_bubble, color: Colors.white, size: 28),
      ),
    );
  }
}
