import 'dart:io';

import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usefast/constant.dart';
import 'package:usefast/controller/account_controller.dart';
import 'package:usefast/controller/transaction_controller.dart';
import 'package:usefast/util/common.dart';
import 'package:usefast/widgets/profile_card_item.dart';

import 'front_page/change_pin_page.dart';
import 'front_page/term_n_condition.dart';
import 'profile/edit_email_page.dart';
import 'profile/edit_password.dart';
import 'profile/edit_profile_page.dart';
import 'profile/update_bank_detail.dart';

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

  File? _image;
  Future _pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) {
        setState(() {
          isLoading = false;
        });
        return;
      }
      File? img = File(image.path);

      setState(() {
        _image = img;
      });
    } on PlatformException catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  bool pageLoading = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !pageLoading,
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: LoadingOverlayPro(
          isLoading: pageLoading,
          progressIndicator: Center(
            child: LoadingAnimationWidget.discreteCircle(
              color: Colors.white,
              size: 20,
            ),
          ),
          child: SingleChildScrollView(
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
                          margin: const EdgeInsets.only(
                              top: 18, left: 35, right: 35),
                          child: Container(
                            height: 100,
                            color: Colors.white,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 28.0),
                                  child: Stack(
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
                                              style: TextStyle(
                                                  color: Colors.white),
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
                                          (isLoading)
                                              ? Positioned(
                                                  top: 20,
                                                  left: 20,
                                                  child: LoadingAnimationWidget
                                                      .inkDrop(
                                                    color: Colors.white,
                                                    size: 20,
                                                  ),
                                                )
                                              : Text(''),
                                        ],
                                      ),
                                      Positioned(
                                        bottom: 5,
                                        right: 0,
                                        child: InkWell(
                                          onTap: () async {
                                            await _pickImage(
                                              ImageSource.gallery,
                                            );

                                            setState(() {
                                              isLoading = true;
                                            });

                                            var status = await accountController
                                                .uploadImage(
                                              user_id,
                                              _image!,
                                            );

                                            if (status == false) {
                                              setState(() {
                                                isLoading = false;
                                              });
                                            }

                                            if (status != false) {
                                              setState(() {
                                                isLoading = false;
                                              });
                                              SharedPreferences prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              prefs.setString(
                                                  'image_name', status);

                                              setState(() {
                                                image_name = status;
                                              });
                                            }

                                            if (status != false) {
                                              displayBottomSheet(
                                                title: 'Congratulation',
                                                desc: 'Profile Picture updated',
                                                imageName:
                                                    'assets/images/check.png',
                                                onTap: () async {
                                                  Get.back();
                                                },
                                                onTapCancel: () {
                                                  Get.back();
                                                },
                                              );
                                            } else {
                                              displayBottomSheet(
                                                title: 'Oops!',
                                                desc:
                                                    'Database Busy, Could not perform operation, Pls Try Again Later!',
                                                imageName:
                                                    'assets/images/attention.png',
                                                onTap: () async {
                                                  Get.back();
                                                },
                                                onTapCancel: () {
                                                  Get.back();
                                                },
                                              );
                                            }
                                            setState(() {});
                                          },
                                          child: Container(
                                            // height: 30,
                                            decoration: BoxDecoration(
                                              color: kSecondaryColor,
                                              borderRadius:
                                                  const BorderRadius.all(
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
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                  ),
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
                        },
                      ),
                      const SizedBox(height: 10),
                      ProfileCardItem(
                        iconData: Icons.lock,
                        name: 'Change Password',
                        onTap: () {
                          Get.to(() => const EditPasswordPage());
                        },
                      ),
                      const SizedBox(height: 10),
                      ProfileCardItem(
                        iconData: Icons.key,
                        name: 'Change Pin',
                        onTap: () {
                          Get.to(() => const ChangePinPage());
                        },
                      ),
                      const SizedBox(height: 10),
                      ProfileCardItem(
                        iconData: Icons.manage_accounts_rounded,
                        name: 'Update Bank Details',
                        onTap: () {
                          Get.to(() => const UpdateBankDetailPage());
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
                          var fingerprintAuth =
                              prefs.getBool('fingerprintAuth');
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
                          Get.to(() => Terms_N_Conditions());
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
                            deleteAccount();
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

  deleteAccount() {
    return (mounted)
        ? showModalBottomSheet(
            context: context,
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
                  'Delete Account',
                  textAlign: TextAlign.center,
                ),
                content: Container(
                  width: MediaQuery.of(context).size.width,
                  child: const Text(
                    'Are you sure you want to delete you account?',
                    textAlign: TextAlign.center,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'CANCEL'),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      Get.back();
                      setState(() {
                        pageLoading = true;
                      });
                      bool status =
                          await accountController.deleteAccount(user_id!);
                      setState(() {
                        pageLoading = false;
                      });
                      if (mounted) {
                        if (status) {
                          accountController.logoutUser();
                        }
                      }
                    },
                    child: const Text('Yes, Delete Account'),
                  ),
                ],
              );
            },
          )
        : Container();
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
