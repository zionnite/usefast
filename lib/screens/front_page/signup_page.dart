import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:usefast/constant.dart';
import 'package:usefast/controller/account_controller.dart';
import 'package:usefast/util/common.dart';
import 'package:usefast/widgets/my_textfield_icon.dart';

import 'login_page.dart';
import 'term_n_condition.dart';

class SignupPage extends StatefulWidget {
  SignupPage({required this.usersType});

  final String usersType;

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final usersController = AccountController().getXID;

  final userNameController = TextEditingController();
  final fullnameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final referalController = TextEditingController();
  String isMlm = 'false';
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
                'Create an Account!',
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyTextFieldIcon(
                      myTextFormController: userNameController,
                      fieldName: 'User Name',
                      prefix: Icons.person,
                    ),
                    const Text(
                      'Username must not contain special character or space',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    MyTextFieldIcon(
                      myTextFormController: fullnameController,
                      fieldName: 'Full Name',
                      prefix: Icons.person,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    MyTextFieldIcon(
                      myTextFormController: emailController,
                      fieldName: 'Email',
                      prefix: Icons.email,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    MyTextFieldIcon(
                      myTextFormController: phoneController,
                      fieldName: 'Phone No',
                      prefix: Icons.phone_android_sharp,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    MyTextFieldIcon(
                      myTextFormController: passwordController,
                      fieldName: 'Password',
                      prefix: Icons.key_sharp,
                      suffix: Icons.remove_red_eye,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Get.off(() => const LoginPage());
                        },
                        child: const Text(
                          'Already have Account?',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Terms_N_Conditions()));
                      },
                      child: Container(
                        margin: const EdgeInsets.only(left: 23.0, bottom: 8),
                        alignment: const Alignment(1.0, 0.0),
                        padding: const EdgeInsets.only(top: 15.0, left: 50.0),
                        child: const InkWell(
                          child: Text(
                            'By clicking on the SignUp Button you agree to our Term & Condition',
                            style: TextStyle(
                                color: Colors.red,
                                fontFamily: 'Trueno',
                                fontSize: 11.0,
                                decoration: TextDecoration.underline),
                            textAlign: TextAlign.right,
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
                          if (userNameController.text != '' &&
                              fullnameController.text != '' &&
                              emailController.text != '' &&
                              phoneController.text != '' &&
                              passwordController.text != '') {
                            setState(() {
                              isLoading = true;
                            });

                            if (referalController.text != '') {
                              setState(() {
                                isMlm = 'true';
                              });
                            }
                            bool status = await usersController.signUp(
                              userName: userNameController.text,
                              fullName: fullnameController.text,
                              email: emailController.text,
                              phone: phoneController.text,
                              password: passwordController.text,
                            );

                            if (status) {
                              setState(() {
                                userNameController.text = '';
                                fullnameController.text = '';
                                emailController.text = '';
                                phoneController.text = '';
                                passwordController.text = '';
                                referalController.text = '';
                                isLoading = false;
                              });

                              showSnackBar(
                                  title: 'Action Needed',
                                  msg:
                                      'An email has been sent to you please Verify the email',
                                  backgroundColor: Colors.blue,
                                  duration: const Duration(seconds: 45));
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
                                'SignUp',
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
          ],
        ),
      ),
    );
  }
}
