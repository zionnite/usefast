import 'package:animate_do/animate_do.dart';
import 'package:crisp_chat/crisp_chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_awesome_bottom_sheet/flutter_awesome_bottom_sheet.dart';
import 'package:get/get.dart';
import 'package:usefast/constant.dart';

import 'submit_payment_prof.dart';

class TradePage extends StatefulWidget {
  const TradePage({Key? key, required this.transType}) : super(key: key);
  final String transType;

  @override
  State<TradePage> createState() => _TradePageState();
}

class _TradePageState extends State<TradePage> {
  final AwesomeBottomSheet _awesomeBottomSheet = AwesomeBottomSheet();

  final String websiteID = '12f29ecd-04da-42dc-ad15-2f322ce4b5e4';
  late CrispConfig config;

  @override
  void initState() {
    super.initState();
    config = CrispConfig(
      websiteID: websiteID,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        title: const Text('Trade Center'),
        backgroundColor: kPrimaryColor,
        centerTitle: false,
        elevation: 5,
      ),
      body: SafeArea(
        child: ListView(
          children: [
            FadeInUp(
              duration: const Duration(milliseconds: 500),
              child: Column(
                children: [
                  InkWell(
                    onTap: () async {
                      // Get.to(() => const ChatSupportPage());
                      await FlutterCrispChat.openCrispChat(
                        config: config,
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                        top: 20,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: kSecondaryColor,
                          borderRadius: BorderRadius.circular(0),
                        ),
                        width: double.infinity,
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'Get Current Rating',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(
                          () => SubmitPaymentProf(transType: widget.transType));
                    },
                    child: Card(
                      margin: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                        top: 10,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: kSecondaryColor,
                          borderRadius: BorderRadius.circular(0),
                        ),
                        width: double.infinity,
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'Upload Prof of Payment',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BuildButton extends StatelessWidget {
  final BuildContext context;
  final String text;
  final VoidCallback onClick;

  const BuildButton({
    Key? key,
    required this.context,
    required this.text,
    required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 8.0),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: onClick,
        child: Container(
          padding: const EdgeInsets.all(10),
          color: Colors.blue,
          child: SizedBox(
            width: double.infinity,
            child: Text(
              text,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
