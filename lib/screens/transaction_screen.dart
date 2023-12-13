import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:usefast/constant.dart';
import 'package:usefast/util/common.dart';
import 'package:usefast/widgets/cards_list.dart';
import 'package:usefast/widgets/header.dart';
import 'package:usefast/widgets/section_title.dart';
import 'package:usefast/widgets/text_info.dart';
import 'package:usefast/widgets/transaction_list.dart';

import 'list_all_transaction.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({Key? key}) : super(key: key);

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  @override
  void initState() {
    super.initState();
    checkIfNewApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            const Header(),
            const SizedBox(height: 40),
            const SectionTitle(title: 'Transactions'),
            const SizedBox(height: 20),
            const TransactionList(),
            const SizedBox(height: 15),
            InkWell(
              onTap: () {
                Get.to(() => const ListAllTransaction());
              },
              child: const TextInfo(title: 'See all transaction details'),
            ),
            const SizedBox(height: 25),
            // const SectionTitle(title: 'Cards'),
            // const SizedBox(height: 20),
            // const CardsList(),
            // const SizedBox(height: 25),
            // const TextInfo(title: 'Swipe up for more'),
          ],
        ),
      ),
    );
  }
}
