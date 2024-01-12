import 'package:animate_do/animate_do.dart';
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

  const TransactionItem({
    Key? key,
    required this.logo,
    required this.type,
    required this.method,
    required this.amount,
    required this.status,
    required this.time_ago,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 7,
        bottom: 7,
        left: 36,
        right: 31,
      ),
      child: FadeInUp(
        duration: const Duration(milliseconds: 900),
        child: Container(
          height: 79,
          width: double.infinity,
          decoration: BoxDecoration(
            color: kSecondaryColor,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 15,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipOval(
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
                                      : (logo == 'account_withdrawal')? const Icon(LineAwesome.laptop_solid):Container(),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      type,
                      style: kInfo.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            method,
                            style: kInfo.copyWith(
                              color: Colors.white30,
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
                    ),
                    Expanded(
                      child: Text(
                        time_ago,
                        style: kInfo.copyWith(
                          color: Colors.white30,
                        ),
                      ),
                    ),
                  ],
                ),
                const Expanded(child: SizedBox(width: 89)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    (method == 'sell' || method == 'deposit')
                        ? Text(
                            '+',
                            style: kInfo.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          )
                        : Text(
                            '-',
                            style: kInfo.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                    const SizedBox(
                      width: 1,
                    ),
                    Text(
                      CurrencyFormatter.getCurrencyFormatter(
                        amount: amount,
                      ),
                      style: kInfo.copyWith(
                        fontWeight: FontWeight.bold,
                        color: (method == 'sell' || method == 'deposit')
                            ? Colors.green
                            : Colors.red,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
