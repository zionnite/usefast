import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:usefast/constant.dart';
import 'package:usefast/model/transaction_model.dart';
import 'package:usefast/util/currency_formatter.dart';

class TransactionDetail extends StatefulWidget {
  const TransactionDetail({Key? key, required this.transaction, required this.newType}) : super(key: key);
  final Transaction transaction;
  final String newType;

  @override
  State<TransactionDetail> createState() => _TransactionDetailState();
}

class _TransactionDetailState extends State<TransactionDetail> {
  @override
  Widget build(BuildContext context) {
    var trans = widget.transaction;
    String startDate = DateFormat('EEEE, MMM d, yyyy').format(DateTime.parse('${trans.dateCreated}'));
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 0.0),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: const Icon(
                    Icons.chevron_left_rounded,
                    color: Colors.white,
                    size: 42,
                  ),
                ),
              ],
            ),
          ),
          const Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Transaction ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    'Detail ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),

          //begin
          Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: Row(
              children: [
                (trans.transMethod == 'sell' || trans.transMethod == 'deposit')
                    ? Text(
                        '+',
                        style: kInfo.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                          fontSize: 20,
                        ),
                      )
                    : Text(
                        '-',
                        style: kInfo.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: 20,
                        ),
                      ),
                const SizedBox(
                  width: 1,
                ),
                Text(
                  CurrencyFormatter.getCurrencyFormatter(
                    amount: '${trans.disAmount}',
                  ),
                  style: kInfo.copyWith(
                    fontWeight: FontWeight.bold,
                    color: (trans.transMethod == 'sell' || trans.transMethod == 'deposit') ? Colors.green : Colors.red,
                    fontSize: 25,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0, top: 18.0, right: 18.0),
            child: Card(
              elevation: 5,
              child: Container(
                // height: 100,
                width: double.infinity,
                color: kSecondaryColor,
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Transaction initiated: ${startDate}',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      'Transaction Type: ${trans.billType}',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      'Transaction Status: ${trans.transStatus!.toUpperCase()}',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18, top: 5),
            child: Card(
              elevation: 5,
              child: Container(
                // height: 50,
                width: double.infinity,
                color: kSecondaryColor,
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Transaction Name: ${widget.newType!.toUpperCase()}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          (trans.transType == 'crypto' || trans.transType == 'gift')
              ? Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18, top: 5),
                  child: Card(
                    elevation: 5,
                    child: Container(
                      // height: 50,
                      width: double.infinity,
                      color: kSecondaryColor,
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Prof of Payment',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          CachedNetworkImage(
                            imageUrl: trans.docName!,
                            fit: BoxFit.cover,
                            height: 150,
                            width: double.infinity,
                            errorWidget: (context, url, error) => Image.asset(
                              'assets/images/withdraw.png',
                              fit: BoxFit.fitWidth,
                            ),
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
