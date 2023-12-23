import 'package:flutter/material.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usefast/constant.dart';
import 'package:usefast/screens/front_page/login_page.dart';
import 'package:usefast/services/local_auth_services.dart';
import 'package:usefast/widgets/bottom_bar.dart';
import 'package:usefast/widgets/property_btn.dart';

class LockPage extends StatefulWidget {
  const LockPage({Key? key}) : super(key: key);

  @override
  State<LockPage> createState() => _LockPageState();
}

class _LockPageState extends State<LockPage> {
  String? transactionPin;
  bool isPinSet = false;
  bool pinError = false;
  bool pinNotMatched = false;

  bool? fingerprintAuth;
  String? fullName;

  initUserDetail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var fingerprintAuth1 = prefs.getBool('fingerprintAuth');
    var fullName1 = prefs.getString('full_name');

    if (mounted) {
      setState(() {
        fingerprintAuth = fingerprintAuth1;
        fullName = fullName1;
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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            Stack(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Image(
                    image: const AssetImage('assets/images/fast_pay.png'),
                    height: height * 0.25,
                  ),
                ),
                Positioned(
                  bottom: 30,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 33.0),
                    child: Row(
                      children: [
                        const Text(
                          'Welcome, ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          child: Text(
                            '$fullName',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 80,
            ),
            Text(
              'Enter Lock Pin',
              style: TextStyle(
                color: kTextColor,
                fontSize: 20,
              ),
            ),
            // Text(
            //   'App lock due to in-activeness',
            //   style: TextStyle(
            //     color: kTextColor,
            //     fontSize: 15,
            //   ),
            // ),
            const SizedBox(height: 9),
            OtpTextField(
              textStyle: const TextStyle(
                color: Colors.white,
              ),
              // filled: true,
              // fillColor: Colors.white,
              numberOfFields: 5,
              borderColor: const Color(0xFF512DA8),
              //set to true to show as box or false to show as dash
              showFieldAsBox: true,
              //runs when a code is typed in
              onCodeChanged: (String code) {
                //handle validation or checks here
              },
              //runs when every textfield is filled
              onSubmit: (String verificationCode) {
                setState(() {
                  transactionPin = verificationCode;
                });
              }, // end onSubmit
            ),
            (pinError)
                ? const Text(
                    'enter your desire pin',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  )
                : Container(),
            (pinNotMatched)
                ? const Text(
                    'Wrong pin entered, please enter the correct Pin',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  )
                : Container(),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: propertyBtn(
                elevation: 0,
                borderRadius: 30,
                card_margin: const EdgeInsets.only(top: 0, left: 0, right: 0),
                onTap: () async {
                  if (transactionPin == null) {
                    setState(() {
                      pinError = true;
                    });
                  } else {
                    setState(() {
                      pinError = false;
                      pinNotMatched = false;
                      isPinSet = true;
                    });
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    var lockPin = prefs.getString('lockPin');

                    if (lockPin == transactionPin) {
                      Future.delayed(const Duration(seconds: 1), () {
                        setState(() {
                          isPinSet = false;
                        });

                        goToHome();
                      });
                    } else {
                      setState(() {
                        isPinSet = false;
                        pinNotMatched = true;
                      });
                    }
                  }
                },
                title: 'Continue',
                bgColor: kSecondaryColor,
                isLoading: isPinSet,
              ),
            ),
            const SizedBox(height: 20),
            (fingerprintAuth == true)
                ? Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: kSecondaryColor,
                            border: Border.all(
                              color: Colors.white,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: IconButton(
                            onPressed: () async {
                              bool authenticate =
                                  await LocalAuth.authenticate();

                              if (authenticate) {
                                //authenticated = authenticate;
                                // Get.back();
                                goToHome();
                              }

                              setState(() {});
                            },
                            icon: const Icon(
                              Icons.fingerprint,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                        // const SizedBox(height: 5),
                        // const Text(
                        //   'use fingerprint',
                        //   style: TextStyle(
                        //     color: Colors.white,
                        //   ),
                        // ),
                      ],
                    ),
                  )
                : Container(),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Not you?',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    didUnlock();
                    Get.to(() => const LoginPage());
                  },
                  child: const Text(
                    'Switch Account',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  didUnlock() {
    AppLock.of(context)!.didUnlock();
  }

  goToHome() {
    AppLock.of(context)!.didUnlock();
    Get.offAll(() => const BottomBar());
  }
}
