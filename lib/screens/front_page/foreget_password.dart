import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:usefast/constant.dart';
import 'package:usefast/controller/account_controller.dart';
import 'package:usefast/widgets/my_textfield_icon.dart';

import 'login_page.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordPage> createState() => _ForetPasswordPageState();
}

class _ForetPasswordPageState extends State<ForgetPasswordPage> {
  final usersController = AccountController().getXID;
  final emailController = TextEditingController();
  bool isLoading = false;
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
                'Change Password',
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
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Get.to(() => const LoginPage());
                      },
                      child: const Text(
                        'Already have account?',
                        style: TextStyle(
                          color: Colors.white,
                        ),
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
                        if (emailController.text != '') {
                          setState(() {
                            isLoading = true;
                          });
                          bool status = await usersController.resetPassword(
                            email: emailController.text,
                          );
                          if (status) {
                            setState(() {
                              isLoading = false;
                            });

                            Get.offAll(() => const LoginPage());
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
                              'Reset Password',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ],
              )),
            )
          ],
        ),
      ),
    );
  }
}
