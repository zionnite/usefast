import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usefast/constant.dart';
import 'package:usefast/controller/account_controller.dart';
import 'package:usefast/screens/front_page/signup_page.dart';
import 'package:usefast/widgets/bottom_bar.dart';
import 'package:usefast/widgets/my_textfield_icon.dart';

import 'create_pin_page.dart';
import 'foreget_password.dart';
import 'lock_pin_create.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usersController = AccountController().getXID;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  bool? fingerprintAuth;

  initUserDetail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var fingerprintAuth1 = prefs.getBool('fingerprintAuth');

    if (mounted) {
      setState(() {
        fingerprintAuth = fingerprintAuth1;
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
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Image(
              image: const AssetImage('assets/images/fast_pay.png'),
              height: height * 0.3,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 18.0),
              child: Text(
                'Login',
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'Passion One',
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Form(
                child: Column(
                  children: [
                    MyTextFieldIcon(
                      myTextFormController: emailController,
                      fieldName: 'Email',
                      prefix: Icons.email,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    MyTextFieldIcon(
                      myTextFormController: passwordController,
                      fieldName: 'Password',
                      prefix: Icons.key_sharp,
                      isPassword: true,
                      // suffix: Icons.remove_red_eye,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Get.to(() => const ForgetPasswordPage());
                        },
                        child: const Text(
                          'forget Password?',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          foregroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(),
                          side: const BorderSide(color: Colors.white),
                          backgroundColor: kSecondaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                        ),
                        onPressed: () async {
                          if (emailController.text != '' &&
                              passwordController.text != '') {
                            setState(() {
                              isLoading = true;
                            });
                            bool status = await usersController.login(
                                email: emailController.text,
                                password: passwordController.text);
                            if (status) {
                              setState(() {
                                isLoading = false;
                              });

                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              var userId1 = prefs.getString('user_id');
                              var userName1 = prefs.getString('user_name');
                              var pin1 = prefs.getString('pin');
                              var pin_set1 = prefs.getString('pin_set');
                              var lockPin = prefs.getString('lockPin');

                              if (pin_set1 == 'yes') {
                                Get.offAll(() => const BottomBar());
                                // if (lockPin == null) {
                                //   Get.offAll(() => const LockPinCreate());
                                // } else {
                                //   Get.offAll(() => const BottomBar());
                                // }
                              } else {
                                if (lockPin == null) {
                                  Get.offAll(() => const CreatePinPage());
                                } else {
                                  Get.offAll(() => const LockPinCreate());
                                }
                              }
                            } else {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                        },
                        child: (isLoading)
                            ? Center(
                                child: LoadingAnimationWidget.staggeredDotsWave(
                                color: Colors.white,
                                size: 20,
                              ))
                            : const Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: TextButton(
                onPressed: () {
                  Get.to(() => SignupPage(usersType: 'usersType'));
                },
                child: const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Don\'t have account?, click here',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
