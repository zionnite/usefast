import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:usefast/constant.dart';
import 'package:usefast/widgets/property_btn_icon.dart';

import 'add_funds.dart';

class FundPage extends StatefulWidget {
  const FundPage({Key? key}) : super(key: key);

  @override
  State<FundPage> createState() => _FundPageState();
}

class _FundPageState extends State<FundPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        title: const Text(''),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: PropertyBtnIcon(
                elevation: 1,
                borderRadius: 40,
                card_margin: const EdgeInsets.only(top: 0, left: 0, right: 0),
                onTap: () async {
                  Get.to(() => const AddFunds());
                },
                title: 'Add Funds',
                bgColor: kSecondaryColor,
                isLoading: false,
                icon: Icons.add,
                icon_color: Colors.white,
                icon_size: 20,
                textSize: 14,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: PropertyBtnIcon(
                elevation: 1,
                borderRadius: 40,
                card_margin: const EdgeInsets.only(top: 0, left: 0, right: 0),
                onTap: () async {},
                title: 'Request Withdraw',
                bgColor: kSecondaryColor,
                isLoading: false,
                icon: Icons.water_drop,
                icon_color: Colors.white,
                icon_size: 20,
                textSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
