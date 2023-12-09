import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usefast/constant.dart';
import 'package:usefast/controller/account_controller.dart';
import 'package:usefast/controller/transaction_controller.dart';
import 'package:usefast/util/common.dart';
import 'package:usefast/widgets/profile_card_item.dart';

import 'front_page/change_pin_page.dart';
import 'profile/edit_email_page.dart';
import 'profile/edit_password.dart';
import 'profile/edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final transactionController = TransactionController().getXID;
  final accountController = AccountController().getXID;
  bool isLoading = false;

  String? user_id;
  String? fullName;
  String? user_name;
  String? user_status;
  bool? admin_status;
  bool? isUserLogin;
  String? image_name;
  String? phoneNumber;

  initUserDetail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId1 = prefs.getString('user_id');
    var userName1 = prefs.getString('user_name');
    var user_status1 = prefs.getString('user_status');
    var admin_status1 = prefs.getBool('admin_status');
    var isUserLogin1 = prefs.getBool('isUserLogin');
    var image_name1 = prefs.getString('image_name');
    var fullName1 = prefs.getString('full_name');
    var phoneNumber1 = prefs.getString('phone');

    if (mounted) {
      setState(() {
        user_id = userId1;
        user_name = userName1;
        user_status = user_status1;
        admin_status = admin_status1;
        isUserLogin = isUserLogin1;
        image_name = image_name1;
        fullName = fullName1;
        phoneNumber = phoneNumber1;
      });

      await accountController.getWallet(user_id, admin_status);
    }
  }

  @override
  void initState() {
    initUserDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(color: kSecondaryColor),
              child: Padding(
                padding: const EdgeInsets.only(left: 0.0, top: 50),
                child: Row(
                  children: [
                    IconButton(
                      color: Colors.white,
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(
                        Icons.chevron_left,
                        size: 40,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  painter: HeaderCurvedContainer(),
                  child: Container(
                    // width: MediaQuery.of(context).size.width,
                    // height: MediaQuery.of(context).size.height,
                    height: 180,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(0.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Your Profile',
                            style: TextStyle(
                              fontSize: 18.0,
                              letterSpacing: 1.5,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 0),
                    Card(
                      elevation: 15,
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin:
                          const EdgeInsets.only(top: 18, left: 35, right: 35),
                      child: Container(
                        height: 100,
                        color: Colors.white,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                CircularProfileAvatar(
                                  '$image_name',
                                  radius: 30,
                                  backgroundColor: Colors.transparent,
                                  borderWidth: 2,
                                  initialsText: const Text(
                                    "AD",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  borderColor: Colors.white,
                                  elevation: 0.0,
                                  foregroundColor:
                                      Colors.brown.withOpacity(0.5),
                                  cacheImage: true,
                                  imageFit: BoxFit.cover,
                                  onTap: () {},
                                  showInitialTextAbovePicture: false,
                                ),
                                Positioned(
                                  bottom: 5,
                                  right: 0,
                                  child: InkWell(
                                    onTap: () {
                                      print('upload profile picture');
                                    },
                                    child: Container(
                                      // height: 30,
                                      decoration: BoxDecoration(
                                        color: kSecondaryColor,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(1.0),
                                        child: Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$fullName',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '$phoneNumber',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 0),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 25,
                left: 20.0,
                right: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(
                      'Account',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ProfileCardItem(
                    iconData: Icons.person,
                    name: 'Change Personal Profile',
                    onTap: () {
                      Get.to(() => const EditProfilePage());
                    },
                  ),
                  const SizedBox(height: 10),
                  ProfileCardItem(
                    iconData: Icons.mail,
                    name: 'Change Email Address',
                    onTap: () {
                      Get.to(() => const EditEmailPage());
                      print('change email address');
                    },
                  ),
                  const SizedBox(height: 10),
                  ProfileCardItem(
                    iconData: Icons.lock,
                    name: 'Change Password',
                    onTap: () {
                      Get.to(() => const EditPasswordPage());
                      print('change email address');
                    },
                  ),
                  const SizedBox(height: 10),
                  ProfileCardItem(
                    iconData: Icons.key,
                    name: 'Change Pin',
                    onTap: () {
                      Get.to(() => const ChangePinPage());
                      print('change email address');
                    },
                  ),
                  const SizedBox(height: 30),
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(
                      'More',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ProfileCardItem(
                    iconData: Icons.fingerprint,
                    name: 'Enable Fingerprint / FaceID',
                    onTap: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      var fingerprintAuth = prefs.getBool('fingerprintAuth');
                      if (fingerprintAuth == null) {
                        displayBottomSheet(
                          title: 'Enable Fingerprint & FaceID',
                          desc:
                              'Enable Fingerprint for login authentication and transaction',
                          imageName: 'assets/images/fast_pay.png',
                          onTap: () async {
                            prefs.setBool('fingerprintAuth', true);

                            Get.back();
                          },
                          onTapCancel: () {
                            Get.back();
                          },
                        );
                      } else {
                        displayBottomSheet(
                          title: 'Enable Fingerprint & FaceID',
                          desc: 'Fingerprint already enable',
                          imageName: 'assets/images/fast_pay.png',
                          onTap: () async {
                            prefs.setBool('fingerprintAuth', true);

                            Get.back();
                          },
                          onTapCancel: () {
                            Get.back();
                          },
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  ProfileCardItem(
                    iconData: Icons.question_mark,
                    name: 'Terms & Condition',
                    onTap: () {
                      print('Terms and condition');
                    },
                  ),
                  const SizedBox(height: 10),
                  ProfileCardItem(
                    iconData: Icons.logout,
                    name: 'Logout',
                    onTap: () {
                      accountController.logoutUser();
                    },
                  ),
                  const SizedBox(height: 50),
                  Align(
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () {
                        print('delete Account');
                      },
                      child: const Text(
                        'Delete Account',
                        style: TextStyle(color: Colors.red, fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  displayBottomSheet({
    required String title,
    required String desc,
    required String imageName,
    required VoidCallback onTap,
    required VoidCallback onTapCancel,
  }) {
    displayBottomSheetFeedback(
      context: context,
      title: title,
      desc: desc,
      image_name: imageName,
      onTap: onTap,
      onTapCancel: onTapCancel,
    );
  }
}

// CustomPainter class to for the header curved-container
class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = kSecondaryColor;
    Path path = Path()
      ..relativeLineTo(0, 100)
      ..quadraticBezierTo(size.width / 2, 150.0, size.width, 100)
      ..relativeLineTo(0, -100)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
