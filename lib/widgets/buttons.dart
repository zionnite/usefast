import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutterwave_standard/flutterwave.dart';
import 'package:get/get.dart';
import 'package:usefast/controller/account_controller.dart';
import 'package:usefast/controller/transaction_controller.dart';
import 'package:usefast/screens/bill_page.dart';
import 'package:usefast/screens/fund_page.dart';
import 'package:usefast/screens/submit_payment_prof.dart';
import 'package:uuid/uuid.dart';

import 'custom_button.dart';

class Buttons extends StatefulWidget {
  const Buttons({Key? key}) : super(key: key);

  @override
  State<Buttons> createState() => _ButtonsState();
}

class _ButtonsState extends State<Buttons> {
  final transactionController = TransactionController().getXID;
  final accountController = AccountController().getXID;

  final formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  final currencyController = TextEditingController();
  final narrationController = TextEditingController();
  final publicKeyController = TextEditingController();
  final encryptionKeyController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();

  String selectedCurrency = "";
  bool isTestMode = true;
  var uuid = const Uuid();

  makePayment() {
    // accountController.verifyAccountDeposit(
    //     userId: '1', txRef: 'txRef', transactionId: 'transactionId');
  }

  handlePaymentInitialization() async {
    // print('clicked');
    final Customer customer = Customer(
      name: "Flutterwave Developer",
      phoneNumber: "1234566677777",
      email: "customer@customer.com",
    );
    final Flutterwave flutterwave = Flutterwave(
      context: context,
      publicKey: "FLWPUBK_TEST-ff3a6c1dffa100835d97718e083470ff-X",
      currency: "NGN",
      redirectUrl: "http://followme.com",
      txRef: uuid.v1(),
      amount: "2000",
      customer: customer,
      paymentOptions: "card",
      customization: Customization(title: "My Payment"),
      isTestMode: true,
    );

    final ChargeResponse response = await flutterwave.charge();
    // print("${response.toJson()}");
    //to access address field

    bool success = response.success!;
    String status = response.status!;
    if (success == true && status == 'successful') {
      String txRef = response.txRef!;
      String transactionId = response.transactionId!;

      // accountController.verifyAccountDeposit(
      //     userId: '1', txRef: txRef, transactionId: transactionId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: FadeInUp(
        duration: const Duration(milliseconds: 1100),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomButton(
              title: 'Gift Card',
              icon: const Icon(
                Icons.wallet_giftcard,
                color: Colors.white,
              ),
              onTap: () {
                Get.to(() => const SubmitPaymentProf(transType: 'gift'));
                // handlePaymentInitialization();
              },
            ),
            const SizedBox(width: 10),
            CustomButton(
              title: 'Coin',
              icon: const Icon(
                Icons.water_drop,
                color: Colors.white,
              ),
              onTap: () {
                Get.to(() => const SubmitPaymentProf(transType: 'crypto'));
              },
            ),
          ],
        ),
      ),
    );
  }

  String getPublicKey() {
    return "";
  }

  void _openBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return _getCurrency();
        });
  }

  Widget _getCurrency() {
    final currencies = ["NGN", "RWF", "UGX", "KES", "ZAR", "USD", "GHS", "TZS"];
    return Container(
      height: 250,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      color: Colors.white,
      child: ListView(
        children: currencies
            .map((currency) => ListTile(
                  onTap: () => {_handleCurrencyTap(currency)},
                  title: Column(
                    children: [
                      Text(
                        currency,
                        textAlign: TextAlign.start,
                        style: const TextStyle(color: Colors.black),
                      ),
                      const SizedBox(height: 4),
                      const Divider(height: 1)
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }

  _handleCurrencyTap(String currency) {
    setState(() {
      selectedCurrency = currency;
      currencyController.text = currency;
    });
    Navigator.pop(context);
  }

  Future<void> showLoading(String message) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            margin: const EdgeInsets.fromLTRB(30, 20, 30, 20),
            width: double.infinity,
            height: 50,
            child: Text(message),
          ),
        );
      },
    );
  }
}
