import 'package:crisp_chat/crisp_chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_awesome_bottom_sheet/flutter_awesome_bottom_sheet.dart';
import 'package:get/get.dart';
import 'package:usefast/constant.dart';
import 'package:usefast/util/common.dart';

import 'submit_payment_prof.dart';

class TradePage extends StatefulWidget {
  const TradePage({Key? key}) : super(key: key);

  @override
  State<TradePage> createState() => _TradePageState();
}

class _TradePageState extends State<TradePage> {
  final AwesomeBottomSheet _awesomeBottomSheet = AwesomeBottomSheet();

  final String websiteID = '0ba48f9a-3159-4a42-b1d1-24d49df5a3ec';
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              const Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Trade ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                        ),
                      ),
                      Text(
                        'Center ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 18.0,
                  right: 18,
                  top: 38,
                ),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () async {
                        await FlutterCrispChat.openCrispChat(config: config);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.support_agent,
                                  color: kTextColor,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  'Chat with our Agent',
                                  style: TextStyle(color: kTextColor),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.chevron_right_sharp,
                              color: kTextColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: SizedBox(
                        height: 10,
                        child: Divider(
                          color: greyColor,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(() => const SubmitPaymentProf(
                              transType: 'gift',
                              transCategory: 'Gift Card',
                              billType: 'Token',
                            ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.card_giftcard,
                                  color: kTextColor,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  'Gift Card',
                                  style: TextStyle(color: kTextColor),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.chevron_right_sharp,
                              color: kTextColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: SizedBox(
                        height: 10,
                        child: Divider(
                          color: greyColor,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(() => const SubmitPaymentProf(
                              transType: 'crypto',
                              transCategory: 'Crypto',
                              billType: 'Btc',
                            ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.water_drop,
                                  color: kTextColor,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  'Coin',
                                  style: TextStyle(color: kTextColor),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.chevron_right_sharp,
                              color: kTextColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
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
