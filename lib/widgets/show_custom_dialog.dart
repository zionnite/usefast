import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:usefast/constant.dart';

import 'property_btn.dart';

class ShowCustomDialog extends StatefulWidget {
  const ShowCustomDialog({Key? key}) : super(key: key);

  @override
  State<ShowCustomDialog> createState() => _ShowCustomDialogState();
}

class _ShowCustomDialogState extends State<ShowCustomDialog> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          callDialog(),
        ],
      ),
    );
  }

  callDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(builder: (context, StateSetter setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            child: Container(
              height: 500,
              width: 350,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // SizedBox(height: 1),
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Image.asset('assets/images/check.png'),
                  ),
                  const Text(
                    "This is a Custom Dialog",
                    style: TextStyle(fontSize: 20),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                      right: 8,
                      bottom: 30,
                    ),
                    child: propertyBtn(
                      borderRadius: 20,
                      card_margin:
                          const EdgeInsets.only(top: 0, left: 0, right: 0),
                      onTap: () async {
                        setState(() {});
                        print('clicked');
                        setState(() {
                          isLoading = true;
                        });

                        Future.delayed(const Duration(seconds: 1), () {
                          setState(() {
                            isLoading = false;
                          });
                        });

                        Future.delayed(const Duration(seconds: 1), () {
                          Get.back();
                        });
                      },
                      title: 'Continue',
                      bgColor: kSecondaryColor,
                      isLoading: isLoading,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }
}
