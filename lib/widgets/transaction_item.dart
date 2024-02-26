import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:usefast/util/currency_formatter.dart';

import '../constant.dart';

class TransactionItem extends StatelessWidget {
  final String logo;
  final String type;
  final String method;
  final String amount;
  final String status;
  final String time_ago;
  final String bill_type;

  const TransactionItem({
    Key? key,
    required this.logo,
    required this.type,
    required this.method,
    required this.amount,
    required this.status,
    required this.time_ago,
    required this.bill_type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 7,
            bottom: 7,
            left: 36,
            right: 31,
          ),
          child: Container(
            color: kSecondaryColor,
            child: ListTile(
              leading: ClipOval(
                child: Container(
                  height: 38,
                  width: 38,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.white, Colors.grey],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 1,
                      vertical: 1,
                    ),
                    child: (logo == 'crypto')
                        ? const Icon(LineAwesome.btc)
                        : (logo == 'gift')
                            ? const Icon(LineAwesome.gift_solid)
                            : (logo == 'bill')
                                ? const Icon(LineAwesome.network_wired_solid)
                                : (logo == 'account_top_up')
                                    ? const Icon(LineAwesome.laptop_solid)
                                    : (logo == 'account_withdrawal')
                                        ? const Icon(LineAwesome.laptop_solid)
                                        : Container(),
                  ),
                ),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${type}',
                      style: kInfo.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: (method == 'sell' || method == 'deposit')
                              ? Text(
                                  '+${CurrencyFormatter.getCurrencyFormatter(
                                    amount: amount,
                                  )}',
                                  style: kInfo.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: (method == 'sell' || method == 'deposit') ? Colors.green : Colors.red,
                                  ),
                                  textAlign: TextAlign.right,
                                )
                              : Text(
                                  '-${CurrencyFormatter.getCurrencyFormatter(
                                    amount: amount,
                                  )}',
                                  style: kInfo.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: (method == 'sell' || method == 'deposit') ? Colors.green : Colors.red,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${bill_type}',
                          style: kInfo.copyWith(
                            color: Colors.white30,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        status,
                        style: kInfo.copyWith(
                          color: (status == 'pending')
                              ? Colors.white30
                              : (status == 'approved')
                                  ? Colors.green
                                  : (status == 'rejected')
                                      ? Colors.red
                                      : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    time_ago,
                    style: kInfo.copyWith(
                      color: Colors.white30,
                    ),
                  ),
                ],
              ),
              // trailing: Expanded(
              //   child: Row(
              //     crossAxisAlignment: CrossAxisAlignment.end,
              //     mainAxisAlignment: MainAxisAlignment.end,
              //     children: [
              //       (method == 'sell' || method == 'deposit')
              //           ? Text(
              //               '+',
              //               style: kInfo.copyWith(
              //                 fontWeight: FontWeight.bold,
              //                 color: Colors.green,
              //               ),
              //             )
              //           : Text(
              //               '-',
              //               style: kInfo.copyWith(
              //                 fontWeight: FontWeight.bold,
              //                 color: Colors.red,
              //               ),
              //             ),
              //       const SizedBox(
              //         width: 1,
              //       ),
              //       Text(
              //         CurrencyFormatter.getCurrencyFormatter(
              //           amount: amount,
              //         ),
              //         style: kInfo.copyWith(
              //           fontWeight: FontWeight.bold,
              //           color: (method == 'sell' || method == 'deposit') ? Colors.green : Colors.red,
              //         ),
              //         textAlign: TextAlign.right,
              //       ),
              //     ],
              //   ),
              // ),
            ),
          ),
        ),
      ],
    );
  }
}
