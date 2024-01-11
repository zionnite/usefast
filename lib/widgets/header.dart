import 'package:animate_do/animate_do.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usefast/controller/account_controller.dart';
import 'package:usefast/controller/transaction_controller.dart';
import 'package:usefast/screens/profile_page.dart';
import 'package:usefast/util/currency_formatter.dart';

import '../constant.dart';

class Header extends StatefulWidget {
  const Header({Key? key}) : super(key: key);

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  final transactionController = TransactionController().getXID;
  final accountController = AccountController().getXID;

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
  }

  void refreshWallet() async {
    await accountController.getWallet(user_id, admin_status);
  }

  var current_page = 1;
  bool isLoading = false;
  bool widgetLoading = true;

  @override
  void initState() {
    initUserDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 245,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(
        left: 36,
        top: 30,
        right: 30,
      ),
      color: kSecondaryColor,
      child: Column(
        children: [
          FadeInUp(
            duration: const Duration(milliseconds: 500),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome Back!',
                        style: kSFUI16,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '$fullName',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: kTextColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                CircularProfileAvatar(
                  '$image_name',
                  radius: 20,
                  backgroundColor: Colors.transparent,
                  borderWidth: 2,
                  initialsText: const Text(
                    "AD",
                    style: TextStyle(color: Colors.white),
                  ),
                  borderColor: Colors.white,
                  elevation: 5.0,
                  foregroundColor: Colors.brown.withOpacity(0.5),
                  cacheImage: true,
                  imageFit: BoxFit.cover,
                  onTap: () {
                    // Get.to(
                    //   () => const ProfilePage(),
                    // );
                  },
                  showInitialTextAbovePicture: false,
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FadeInUp(
                duration: const Duration(milliseconds: 700),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Your Current Balance',
                      style: kSFUI16.copyWith(
                        color: Colors.white30,
                      ),
                    ),
                    SizedBox(width: 10),
                    InkWell(
                      onTap: refreshWallet,
                        child: const Icon(Icons.refresh, color: Colors.white,)),
                  ],
                ),
              ),
              const SizedBox(height: 7),
              FadeInUp(
                duration: const Duration(milliseconds: 700),
                child: Align(
                  alignment: Alignment.center,
                  child: Obx(
                    () => SizedBox(
                      // width: 300,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(0),
                        physics: const ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount:
                            accountController.accountStatusCounter.length,
                        itemBuilder: (BuildContext context, int index) {
                          var data =
                              accountController.accountStatusCounter[index];

                          var tWorth = data.totalWorth;

                          return Text(
                            (tWorth != null)
                                ? '${CurrencyFormatter.getCurrencyFormatter(
                                    amount: tWorth.toString(),
                                  )}'
                                : 'xxxx',
                            style: kBalance,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 7),
            ],
          ),
        ],
      ),
    );
  }
}
