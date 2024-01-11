import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usefast/constant.dart';
import 'package:usefast/controller/account_controller.dart';
import 'package:usefast/screens/front_page/lock_pin_create.dart';
import 'package:usefast/widgets/property_btn.dart';

class VerifyCreatePinPage extends StatefulWidget {
  const VerifyCreatePinPage({Key? key, required this.newPin}) : super(key: key);
  final String newPin;

  @override
  State<VerifyCreatePinPage> createState() => _VerifyCreatePinPageState();
}

class _VerifyCreatePinPageState extends State<VerifyCreatePinPage> {
  final usersController = AccountController().getXID;

  String? transactionPin;
  bool isPinSet = false;
  bool pinError = false;
  bool pinMatchError = false;

  String? user_id;
  initUserDetail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId1 = prefs.getString('user_id');
    var userName1 = prefs.getString('user_name');
    var user_status1 = prefs.getString('user_status');
    var admin_status1 = prefs.getBool('admin_status');
    var isUserLogin1 = prefs.getBool('isUserLogin');
    var image_name1 = prefs.getString('image_name');

    if (mounted) {
      setState(() {
        user_id = userId1;
      });
    }
  }

  bool pageLoading = false;
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
            Align(
              alignment: Alignment.topLeft,
              child: Image(
                image: const AssetImage('assets/images/fast_pay.png'),
                height: height * 0.3,
              ),
            ),
            Text(
              'Verify your Transaction Pin',
              style: TextStyle(
                color: kTextColor,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 20),
            OtpTextField(
              textStyle: const TextStyle(
                color: Colors.white,
              ),
              // filled: true,
              // fillColor: Colors.white,
              numberOfFields: 4,
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
            (pinMatchError)
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.0),
                    child: Text(
                      'You Pin does not match, please go back and re-enter your 5 digit pin',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                : Container(),
            const SizedBox(
              height: 100,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: propertyBtn(
                elevation: 5,
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
                    });

                    //check if pin match
                    if (transactionPin == widget.newPin) {
                      //insert into database

                      setState(() {
                        pinMatchError = false;
                        isPinSet = true;
                      });

                      bool status = await usersController.updateTransactionPin(
                        pin: transactionPin!,
                        userId: user_id!,
                      );

                      Future.delayed(const Duration(seconds: 1), () {
                        setState(() {
                          isPinSet = false;
                        });

                        if (status) {
                          Get.offAll(() => const LockPinCreate());
                        }
                      });
                    } else {
                      setState(() {
                        isPinSet = false;
                        pinMatchError = true;
                      });
                    }
                  }
                },
                title: 'Continue',
                bgColor: kSecondaryColor,
                isLoading: isPinSet,
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: propertyBtn(
                elevation: 5,
                borderRadius: 30,
                card_margin: const EdgeInsets.only(top: 0, left: 0, right: 0),
                onTap: () async {
                  Get.back();
                },
                title: 'Go Back',
                bgColor: kSecondaryColor,
                isLoading: false,
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
