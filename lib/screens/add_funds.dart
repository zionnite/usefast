import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutterwave_standard/flutterwave.dart';
import 'package:get/get.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_sheet2/sliding_sheet2.dart';
import 'package:usefast/constant.dart';
import 'package:usefast/controller/account_controller.dart';
import 'package:usefast/controller/flutterwave_bill_controller.dart';
import 'package:usefast/services/api_services.dart';
import 'package:usefast/services/local_auth_services.dart';
import 'package:usefast/util/common.dart';
import 'package:usefast/util/currency_formatter.dart';
import 'package:usefast/widgets/my_money_field.dart';
import 'package:usefast/widgets/property_btn.dart';
import 'package:uuid/uuid.dart';

class AddFunds extends StatefulWidget {
  const AddFunds({Key? key}) : super(key: key);

  @override
  State<AddFunds> createState() => _AddFundsState();
}

class _AddFundsState extends State<AddFunds> {
  final accountController = AccountController().getXID;
  final billController = FlutterWaveBillController().getXID;

  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  static const _locale = 'en';
  String _formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(int.parse(s));
  String get _currency =>
      NumberFormat.compactSimpleCurrency(locale: _locale).currencySymbol;

  String disAmount = '0';
  bool amountError = false;
  bool isLoading = false;
  bool pageLoading = false;

  bool authenticated = false;
  String? transactionPin;

  String selectedCurrency = "";
  bool isTestMode = true;
  var uuid = const Uuid();

  //****//

  String? user_id;
  String? fullName;
  String? user_name;
  String? user_status;
  bool? admin_status;
  bool? isUserLogin;
  String? image_name;
  String? phoneNumber;
  String? email;
  bool? fingerprintAuth;

  initUserDetail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId1 = prefs.getString('user_id');
    var userName1 = prefs.getString('user_name');
    var user_status1 = prefs.getString('user_status');
    var admin_status1 = prefs.getBool('admin_status');
    var isUserLogin1 = prefs.getBool('isUserLogin');
    var image_name1 = prefs.getString('image_name');
    var fullName1 = prefs.getString('full_name');
    var phoneNumber1 = prefs.getString('phone');
    var email1 = prefs.getString('email');
    var fingerprintAuth1 = prefs.getBool('fingerprintAuth');

    if (mounted) {
      setState(() {
        user_id = userId1;
        user_name = userName1;
        user_status = user_status1;
        admin_status = admin_status1;
        isUserLogin = isUserLogin1;
        image_name = image_name1;
        fullName = fullName1;
        phoneNumber = phoneNumber1;
        email = email1;
        fingerprintAuth = fingerprintAuth1;
      });
    }
  }

  @override
  void initState() {
    initUserDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !pageLoading,
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: LoadingOverlayPro(
          isLoading: pageLoading,
          progressIndicator: Center(
            child: LoadingAnimationWidget.discreteCircle(
              color: Colors.white,
              size: 20,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
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
                Padding(
                  padding: const EdgeInsets.only(
                    left: 18.0,
                    right: 8.0,
                    top: 8,
                    bottom: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add Funds',
                        style: TextStyle(
                          color: textColorWhite,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 10),
                      MyMoneyField(
                        myTextFormController: amountController,
                        fieldName: 'Amount',
                        prefix: Icons.attach_money,
                        onChange: (string) {
                          if (amountController.text.isNotEmpty) {
                            string =
                                '${_formatNumber(string.replaceAll(',', ''))}';
                            amountController.value = TextEditingValue(
                              text: string,
                              selection: TextSelection.collapsed(
                                  offset: string.length),
                            );
                          } else {
                            setState(() {
                              string = '0';
                            });
                          }
                          setState(() {
                            disAmount = string;
                            disAmount = disAmount!.replaceAll(",", "");
                          });
                        },
                      ),
                      (amountError)
                          ? const Text('Amount is required!',
                              style: TextStyle(
                                color: Colors.red,
                              ))
                          : Container(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0.0),
                        child: propertyBtn(
                          card_margin:
                              const EdgeInsets.only(top: 0, left: 0, right: 0),
                          onTap: () async {
                            if (disAmount != '0') {
                              setState(() {
                                isLoading = true;
                                amountError = false;
                              });

                              Future.delayed(const Duration(seconds: 1), () {
                                setState(() {
                                  amountController.text = '';
                                  isLoading = false;
                                });
                                verifySelectedAmount();
                              });
                            } else {
                              setState(() {
                                isLoading = false;
                              });
                              if (disAmount == null || disAmount == '0') {
                                setState(() {
                                  amountError = true;
                                });
                              }
                            }
                          },
                          title: 'Continue',
                          bgColor: kSecondaryColor,
                          isLoading: isLoading,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //botom sheet Airitme
  verifySelectedAmount() {
    return showSlidingBottomSheet(
      context,
      builder: (context) => SlidingSheetDialog(
        cornerRadius: 16,
        snapSpec: const SnapSpec(
          snap: true,
          snappings: [0.6, 0.8, 1.0],
          positioning: SnapPositioning.relativeToAvailableSpace,
        ),
        builder: myCustomBuildSheetAirtime,
        headerBuilder: myCustomHeaderBuilderAirtime,
      ),
    );
  }

  Widget myCustomHeaderBuilderAirtime(BuildContext context, SheetState state) {
    return Container(
      // height: 80,
      color: kSecondaryColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          Center(
            child: Container(
              width: 32,
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget myCustomBuildSheetAirtime(context, state) {
    return Material(
      child: ListView(
        padding: const EdgeInsets.all(10),
        shrinkWrap: true,
        primary: false,
        children: [
          const Text(
            'Confirm Amount Transaction',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
            textAlign: TextAlign.center,
          ),
          Container(
            // color: kSecondaryColor,
            margin: const EdgeInsets.only(
              top: 20,
              bottom: 10,
            ),
            height: 200,
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Amount',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '${CurrencyFormatter.getCurrencyFormatter(
                            amount: disAmount.toString(),
                          )}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: propertyBtn(
              card_margin: const EdgeInsets.only(top: 0, left: 0, right: 0),
              onTap: () async {
                Get.back();
                if (disAmount != null && disAmount != '0') {
                  verifyTransactionPin();

                  Future.delayed(const Duration(seconds: 1), () {
                    setState(() {
                      amountController.text = '';
                      isLoading = false;
                    });
                  });
                }
              },
              title: 'Confirm Transaction',
              bgColor: kSecondaryColor,
              isLoading: isLoading,
            ),
          ),
        ],
      ),
    );
  }

  //bottomSheet Verify Pin
  verifyTransactionPin() {
    return showSlidingBottomSheet(
      context,
      builder: (context) => SlidingSheetDialog(
        // dismissOnBackdropTap: false,
        // isDismissable: false,
        cornerRadius: 16,
        snapSpec: const SnapSpec(
          snap: true,
          snappings: [0.8, 1.0],
          positioning: SnapPositioning.relativeToAvailableSpace,
        ),
        builder: myCustomBuildSheetPin,
        headerBuilder: myCustomHeaderBuilderPin,
      ),
    );
  }

  Widget myCustomHeaderBuilderPin(BuildContext context, SheetState state) {
    return Container(
      // height: 80,
      color: kSecondaryColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          Center(
            child: Container(
              width: 32,
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget myCustomBuildSheetPin(context, state) {
    return Material(
      child: ListView(
        padding: const EdgeInsets.all(10),
        shrinkWrap: true,
        primary: false,
        children: [
          const Text(
            'Enter Transaction Pin',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
            textAlign: TextAlign.center,
          ),
          Container(
            // color: kSecondaryColor,
            margin: const EdgeInsets.only(
              top: 20,
              bottom: 10,
            ),
            height: 300,
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OtpTextField(
                      numberOfFields: 5,
                      borderColor: const Color(0xFF512DA8),
                      //set to true to show as box or false to show as dash
                      showFieldAsBox: true,
                      //runs when a code is typed in
                      onCodeChanged: (String code) {
                        //handle validation or checks here
                      },
                      //runs when every textfield is filled
                      onSubmit: (String verificationCode) {
                        setState(() {
                          transactionPin = verificationCode;
                        });
                      }, // end onSubmit
                    ),
                  ),
                ),
                (fingerprintAuth == true)
                    ? Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: kPrimaryColor,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  child: InkWell(
                                    onTap: () async {
                                      bool authenticate =
                                          await LocalAuth.authenticate();
                                      if (authenticate) {
                                        authenticated = authenticate;
                                        // Get.back();
                                        handlePaymentInitialization(
                                            amount: disAmount);
                                      }

                                      Get.back();
                                      setState(() {});
                                    },
                                    child: const Icon(
                                      Icons.fingerprint,
                                      size: 45,
                                    ),
                                  ),
                                ),
                              ),
                              const Expanded(
                                child: Text(
                                  'Complete Transaction with Face ID or Finger Print',
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: propertyBtn(
              card_margin: const EdgeInsets.only(top: 0, left: 0, right: 0),
              onTap: () async {
                Get.back();
                if (disAmount != null && disAmount != '0') {
                  completeTransactionPin(
                    transactionPin: transactionPin!,
                    amount: disAmount,
                    userId: user_id!,
                  );

                  Future.delayed(const Duration(seconds: 1), () {
                    setState(() {
                      amountController.text = '';
                      isLoading = false;
                    });
                  });
                }
                setState(() {});
              },
              title: 'Continue',
              bgColor: kSecondaryColor,
              isLoading: isLoading,
            ),
          ),
        ],
      ),
    );
  }

  handlePaymentInitialization({required String amount}) async {
    print('clicked');
    final Customer customer = Customer(
      name: '$fullName',
      phoneNumber: '$phoneNumber',
      email: '$email',
    );
    final Flutterwave flutterwave = Flutterwave(
      context: context,
      publicKey: ApiServices.publicKey,
      currency: "NGN",
      redirectUrl: "https://facebook.com",
      txRef: uuid.v1(),
      amount: amount,
      customer: customer,
      paymentOptions: "ussd, card, barter, payattitude",
      customization: Customization(title: "Add Funds"),
      isTestMode: true,
    );

    setState(() {
      pageLoading = true;
    });
    final ChargeResponse response = await flutterwave.charge();
    // print("${response.toJson()}");
    //to access address field

    bool success = response.success!;
    String status = response.status!;
    if (success == true && status == 'successful') {
      String txRef = response.txRef!;
      String transactionId = response.transactionId!;

      var result = await accountController.verifyTransaction(
        userId: '$user_id',
        txRef: txRef,
        transactionId: transactionId,
        amount: amount,
      );
      setState(() {
        pageLoading = false;
      });
      displayResult(result);
    } else {
      setState(() {
        pageLoading = false;
      });
      displayResult('Transaction not successful, please try again later');
    }
  }

  completeTransactionPin({
    required String transactionPin,
    required String amount,
    required String userId,
  }) async {
    setState(() {
      pageLoading = true;
    });
    var status = await accountController.verifyJustTransactionPin(
      transactionPin: transactionPin!,
      userId: userId,
      amount: amount,
    );
    if (status == 'ok') {
      setState(() {
        pageLoading = false;
      });
      await handlePaymentInitialization(amount: amount);
    } else {
      setState(() {
        pageLoading = false;
      });
      displayResult(status);
    }
  }

  displayResult(String status) {
    return showModalBottomSheet(
      context: context,
      clipBehavior: Clip.antiAlias,
      isScrollControlled: true,
      isDismissible: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(40),
        ),
      ),
      builder: (BuildContext context) {
        return GiffyBottomSheet.image(
          Image.asset(
            "assets/images/fast_pay.png",
            height: 200,
            fit: BoxFit.cover,
          ),
          title: const Text(
            'Feedback',
            textAlign: TextAlign.center,
          ),
          content: Container(
            width: MediaQuery.of(context).size.width,
            child: Text(
              (status == 'error_pin')
                  ? 'Pin entered it\'s inaccurate, please enter correct pin to continue'
                  : (status == 'error_wallet' || status == 'error_debit_1')
                      ? 'Insufficient Balance in your wallet, please top up your account and try again'
                      : (status == 'error_debit_2')
                          ? 'having difficulties performing operation with your wallet'
                          : (status == 'not_successful')
                              ? 'Purchase not successful, please try again later!'
                              : (status == 'successful')
                                  ? 'Congratulation, Purchase was successful'
                                  : status,
              textAlign: TextAlign.center,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
