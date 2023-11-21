import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:usefast/constant.dart';
import 'package:usefast/screens/purchase_bill.dart';
import 'package:usefast/util/common.dart';

import 'purchase_bill_data.dart';

class BillPage extends StatefulWidget {
  const BillPage({Key? key}) : super(key: key);

  @override
  State<BillPage> createState() => _BillPageState();
}

class _BillPageState extends State<BillPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        title: const Text('Utility Bills'),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Text(
              'Click on any bill to pay it easily',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 18.0,
              right: 18,
              top: 8,
            ),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Get.to(
                      () => const PurchaseUtilityBill(utilityType: 'airtime'),
                    );
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
                              Icons.phone_android_sharp,
                              color: kTextColor,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              'Airtime Top-up',
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
                    Get.to(
                      () => const PurchaseBillData(utilityType: 'data'),
                    );
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
                              Icons.network_cell,
                              color: kTextColor,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              'Data Purchase',
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
    );
  }
}
