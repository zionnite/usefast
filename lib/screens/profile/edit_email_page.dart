import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usefast/constant.dart';
import 'package:usefast/controller/account_controller.dart';
import 'package:usefast/util/common.dart';
import 'package:usefast/widgets/my_textfield_icon.dart';
import 'package:usefast/widgets/property_btn.dart';

class EditEmailPage extends StatefulWidget {
  const EditEmailPage({Key? key}) : super(key: key);

  @override
  State<EditEmailPage> createState() => _EditEmailPageState();
}

class _EditEmailPageState extends State<EditEmailPage> {
  final accountController = AccountController().getXID;

  TextEditingController emailController = TextEditingController();
  TextEditingController newEmailController = TextEditingController();
  bool pageLoading = false;
  bool isLoading = false;

  final List<String> _gender = [
    'Male',
    'Female',
  ];

  var selectedGender;

  bool emailError = false;
  bool email2Error = false;

  String? user_id;
  String? fullName;
  String? email;
  String? user_name;
  String? user_status;
  bool? admin_status;
  bool? isUserLogin;
  String? image_name;
  String? phoneNumber;
  String? age;
  String? sex;
  String? login_status;
  String? account_name;
  String? account_number;
  String? bank_name;
  String? bank_code;
  String? isbank_verify;
  String? pin;
  String? pin_set;

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
    var age1 = prefs.getString('age');
    var sex1 = prefs.getString('sex');
    var login_status1 = prefs.getString('login_status');
    var account_name1 = prefs.getString('account_name');
    var account_number1 = prefs.getString('account_number');
    var bank_name1 = prefs.getString('bank_name');
    var bank_code1 = prefs.getString('bank_code');
    var isbank_verify1 = prefs.getString('isbank_verify');
    var pin1 = prefs.getString('pin');
    var pin_set1 = prefs.getString('pin_set');
    var email1 = prefs.getString('email');

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
        age = age1;
        sex = sex1;
        login_status = login_status1;
        account_name = account_name1;
        account_number = account_number1;
        bank_name = bank_name1;
        bank_code = bank_code1;
        isbank_verify = isbank_verify1;
        pin = pin1;
        pin_set = pin_set1;
        email = email1;

        //
        emailController.text = email!;
      });
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
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 0.0),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: const Icon(
                          Icons.chevron_left_rounded,
                          color: Colors.white,
                          size: 42,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      const Text(
                        'Edit Email',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      MyTextFieldIcon(
                        myTextFormController: emailController,
                        fieldName: 'Current Email',
                        prefix: Icons.mail,
                      ),
                      (emailError)
                          ? const Text(
                              'Current Email is required',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            )
                          : Container(),
                      const SizedBox(
                        height: 15,
                      ),
                      MyTextFieldIcon(
                        myTextFormController: newEmailController,
                        fieldName: 'New Email',
                        prefix: Icons.mail,
                      ),
                      (email2Error)
                          ? const Text(
                              'New Email is required',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            )
                          : Container(),
                      const SizedBox(height: 20),
                      propertyBtn(
                        borderRadius: 30,
                        elevation: 1,
                        card_margin:
                            const EdgeInsets.only(top: 0, left: 0, right: 0),
                        onTap: () async {
                          if (emailController.text != null &&
                              newEmailController.text != '') {
                            setState(() {
                              isLoading = true;
                              pageLoading = true;
                              emailError = false;
                              email2Error = false;
                            });

                            Future.delayed(const Duration(seconds: 1),
                                () async {
                              setState(() {
                                isLoading = false;
                              });

                              var status =
                                  await accountController.updateUserEmail(
                                newEmail: emailController.text,
                                userId: user_id!,
                              );

                              displayBottomSheet(status);
                            });
                          } else {
                            setState(() {
                              isLoading = false;
                            });
                            if (emailController.text == '') {
                              setState(() {
                                emailError = true;
                              });
                            } else if (newEmailController.text == '') {
                              setState(() {
                                email2Error = true;
                              });
                            }
                          }
                        },
                        title: 'Update Email',
                        bgColor: kSecondaryColor,
                        isLoading: isLoading,
                      ),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }

  displayBottomSheet(var status) {
    setState(() {
      pageLoading = false;
    });
    if (status == true) {
      displayBottomSheetFeedback(
        context: context,
        title: 'Congratulation',
        desc: 'Update Successful...',
        image_name: 'assets/images/check.png',
        onTap: () {
          Get.back();
        },
        onTapCancel: () {
          Get.back();
        },
      );
    } else {
      displayBottomSheetFeedback(
        context: context,
        title: 'Oops!',
        desc: '$status',
        image_name: 'assets/images/attention.png',
        onTap: () {
          Get.back();
        },
        onTapCancel: () {
          Get.back();
        },
      );
    }
  }
}
