import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:usefast/constant.dart';
import 'package:usefast/screens/front_page/lock_pin_verify.dart';
import 'package:usefast/widgets/property_btn.dart';

class LockPinCreate extends StatefulWidget {
  const LockPinCreate({Key? key}) : super(key: key);

  @override
  State<LockPinCreate> createState() => _LockPinCreateState();
}

class _LockPinCreateState extends State<LockPinCreate> {
  String? transactionPin;
  bool isPinSet = false;
  bool pinError = false;
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
              'Create your Lock Pin',
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
                      isPinSet = true;
                    });
                    Future.delayed(const Duration(seconds: 1), () {
                      setState(() {
                        isPinSet = false;
                      });
                      Get.to(() => LockPinVerify(newPin: transactionPin!));
                    });
                  }
                },
                title: 'Continue',
                bgColor: kSecondaryColor,
                isLoading: isPinSet,
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
