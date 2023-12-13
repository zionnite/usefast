import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usefast/controller/transaction_controller.dart';
import 'package:usefast/dummy.dart';
import 'package:usefast/screens/transaction_detail.dart';

import 'show_not_found.dart';
import 'transaction_item.dart';

class TransactionList extends StatefulWidget {
  const TransactionList({Key? key}) : super(key: key);

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  final transactionController = TransactionController().getXID;

  late ScrollController _controller;

  String? user_id;

  String? user_status;

  bool? admin_status;

  initUserDetail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId1 = prefs.getString('user_id');
    var user_status1 = prefs.getString('user_status');
    var admin_status1 = prefs.getBool('admin_status');

    if (mounted) {
      setState(() {
        user_id = userId1;
        user_status = user_status1;
        admin_status = admin_status1;
      });

      await transactionController.fetchTransaction(1, user_id, admin_status);
    }
  }

  var current_page = 1;

  bool isLoading = false;

  bool widgetLoading = true;

  @override
  void initState() {
    initUserDetail();
    super.initState();

    _controller = ScrollController()..addListener(_scrollListener);

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          checkIfListLoaded();
        });
      }
    });
  }

  void _scrollListener() {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      setState(() {
        isLoading = true;
        current_page++;
      });

      transactionController.fetchTransactionMore(
          current_page, user_id, admin_status);

      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  checkIfListLoaded() {
    var loading = transactionController.isTransactionProcessing;
    if (loading == 'yes' || loading == 'no') {
      setState(() {
        widgetLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: transaction.length * 89,
      width: double.infinity,
      child: Column(
        children: [
          Expanded(
            child: Obx(
              () => (transactionController.isTransactionProcessing == 'null')
                  ? Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                        color: Colors.white,
                        size: 20,
                      ),
                    )
                  : detail(),
            ),
          ),
        ],
      ),
    );
  }

  Widget detail() {
    return Obx(
      () => (transactionController.transactionList.isEmpty)
          ? Stack(children: [
              const ShowNotFound(),
              Positioned(
                bottom: 10,
                right: 10,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      transactionController.isTransactionProcessing.value =
                          'null';
                      transactionController.fetchTransaction(
                          1, user_id, admin_status);
                      transactionController.transactionList.refresh();
                    });
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 20,
                    ),
                    child: const Icon(
                      Icons.refresh,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ])
          : Obx(
              () => ListView.builder(
                controller: _controller,
                padding: const EdgeInsets.only(bottom: 120),
                key: const PageStorageKey<String>('allTransaction'),
                // physics: const ClampingScrollPhysics(),
                physics: const NeverScrollableScrollPhysics(),
                // itemExtent: 350,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: transactionController.transactionList.length,
                itemBuilder: (BuildContext context, int index) {
                  var trans = transactionController.transactionList[index];
                  if (transactionController.transactionList[index].id == null) {
                    return Container();
                  }

                  String startDate = DateFormat('EEEE, MMM d, yyyy')
                      .format(DateTime.parse('${trans.dateCreated}'));

                  String? newType;
                  if (trans.transType == 'gift') {
                    newType = 'Gift Card';
                  } else if (trans.transType == 'crypto') {
                    newType = 'Crypto';
                  } else if (trans.transType == 'bill') {
                    newType = 'Bill';
                  } else if (trans.transType == 'account_top_up') {
                    newType = 'Account Top up';
                  }
                  return InkWell(
                    onTap: () {
                      Get.to(() => TransactionDetail(transaction: trans));
                    },
                    child: TransactionItem(
                      logo: '${trans.transType}',
                      type: '$newType',
                      method: '${trans.transMethod}',
                      status: '${trans.transStatus}',
                      amount: '${trans.disAmount}',
                      time_ago: startDate,
                    ),
                  );
                },
              ),
            ),
    );
  }
}
