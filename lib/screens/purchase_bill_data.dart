import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:h3m_shimmer_card/h3m_shimmer_card.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_sheet2/sliding_sheet2.dart';
import 'package:usefast/constant.dart';
import 'package:usefast/controller/account_controller.dart';
import 'package:usefast/controller/flutterwave_bill_controller.dart';
import 'package:usefast/services/local_auth_services.dart';
import 'package:usefast/util/common.dart';
import 'package:usefast/util/currency_formatter.dart';
import 'package:usefast/widgets/my_money_field.dart';
import 'package:usefast/widgets/my_text_field_num.dart';
import 'package:usefast/widgets/property_btn.dart';

class PurchaseBillData extends StatefulWidget {
  const PurchaseBillData({Key? key, required this.utilityType})
      : super(key: key);
  final String utilityType;

  @override
  State<PurchaseBillData> createState() => _PurchaseBillDataState();
}

class _PurchaseBillDataState extends State<PurchaseBillData> {
  final accountController = AccountController().getXID;
  final billController = FlutterWaveBillController().getXID;

  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  final FlutterContactPicker _contactPicker = FlutterContactPicker();
  late Contact _contact;

  static const _locale = 'en';
  String _formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(int.parse(s));
  String get _currency =>
      NumberFormat.compactSimpleCurrency(locale: _locale).currencySymbol;

  String disAmount = '0';
  String? networkSelected;
  bool isSelected = false;
  String? selectedDataPlan;

  List<String> networkProvider = ["MTN", "AIRTEL", "GLO", "9MOBILE"];
  bool isLoading = false;
  bool phoneError = false;
  bool networkError = false;
  bool amountError = false;
  bool dataError = false;
  bool authenticated = false;
  String? transactionPin;

  String? itemCode;
  String? billerCode;
  String? billerName;
  String country = 'NG';

  String? user_id;
  bool? fingerprintAuth;
  initUserDetail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId1 = prefs.getString('user_id');
    var userName1 = prefs.getString('user_name');
    var user_status1 = prefs.getString('user_status');
    var admin_status1 = prefs.getBool('admin_status');
    var isUserLogin1 = prefs.getBool('isUserLogin');
    var image_name1 = prefs.getString('image_name');
    var fingerprintAuth1 = prefs.getBool('fingerprintAuth');

    if (mounted) {
      setState(() {
        user_id = userId1;
        fingerprintAuth = fingerprintAuth1;
      });

      // await billController.fetchBillCategories();
    }
  }

  bool pageLoading = false;
  @override
  void initState() {
    initUserDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var utilityType = widget.utilityType;
    var type = (utilityType == 'airtime') ? 'airtime' : 'data';
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
                        (utilityType == 'airtime') ? 'Buy Airtime' : 'Buy Data',
                        style: TextStyle(
                          color: textColorWhite,
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Enter receiver\'s phone number to buy $type instantly',
                        style: TextStyle(
                          color: textColorWhite,
                        ),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: SizedBox(
                              width: 200,
                              child: MyNumField(
                                myTextFormController: phoneController,
                                fieldName: 'Phone Number',
                                prefix: Icons.phone_android_sharp,
                                onChange: (string) {},
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: () async {
                              Contact? contact =
                                  await _contactPicker.selectContact();
                              if (contact != null) {
                                setState(() {
                                  _contact = contact;
                                  phoneController.text =
                                      _contact.phoneNumbers![0];
                                });
                              }
                            },
                            child: Container(
                              width: 80,
                              decoration: BoxDecoration(
                                color: kSecondaryColor,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(8),
                                ),
                                border: Border.all(
                                  color: Colors.white,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 5.0,
                                  right: 5.0,
                                  top: 15,
                                  bottom: 15,
                                ),
                                child: Icon(
                                  Icons.contacts,
                                  color: textColorWhite,
                                  size: 25,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      (phoneError)
                          ? const Text('Phone number is required!',
                              style: TextStyle(
                                color: Colors.red,
                              ))
                          : Container(),
                      const SizedBox(
                        height: 18,
                      ),
                      Text(
                        'Select Network Provider',
                        style: TextStyle(
                          fontSize: 18,
                          color: textColorWhite,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Container(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: networkProvider.length,
                          itemBuilder: (BuildContext context, int index) {
                            var data = networkProvider[index];
                            return InkWell(
                              onTap: () async {
                                setState(() {
                                  networkSelected = data;
                                  isSelected = true;
                                });

                                if (networkSelected == 'MTN') {
                                  setState(() {
                                    billerCode = 'BIL104';
                                  });
                                } else if (networkSelected == 'AIRTEL') {
                                  setState(() {
                                    billerCode = 'BIL106';
                                  });
                                } else if (networkSelected == 'GLO') {
                                  setState(() {
                                    billerCode = 'BIL105';
                                  });
                                } else if (networkSelected == '9MOBILE') {
                                  setState(() {
                                    billerCode = 'BIL107';
                                  });
                                }

                                await billController.fetchBillDisDataPlan(
                                    billerCode: billerCode!);
                              },
                              child: Container(
                                // width: 150,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: kSecondaryColor,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  border: Border.all(
                                    color: (networkSelected == data)
                                        ? Colors.white
                                        : Colors.white12,
                                  ),
                                ),
                                padding: const EdgeInsets.all(20),
                                margin: const EdgeInsets.only(
                                  top: 10,
                                  right: 10,
                                  // bottom: 10,
                                ),
                                child: Center(
                                  child: Text(
                                    data,
                                    style: TextStyle(
                                      color: textColorWhite,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      (networkError)
                          ? const Text(
                              'Network provider not selected!',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            )
                          : Container(),

                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Data Plan',
                        style: TextStyle(
                          fontSize: 18,
                          color: textColorWhite,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (networkSelected != null) {
                            setState(() {
                              dataError = false;
                            });
                            selectDataPlanBottomSheet();
                          } else {
                            setState(() {
                              dataError = true;
                            });
                          }
                        },
                        child: Container(
                          // width: 150,
                          // height: 100,
                          decoration: BoxDecoration(
                            color: kSecondaryColor,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                            border: Border.all(
                              color: Colors.white12,
                            ),
                          ),
                          padding: const EdgeInsets.all(20),
                          margin: const EdgeInsets.only(
                            top: 10,
                            right: 10,
                            // bottom: 10,
                          ),
                          child: Center(
                            child: Text(
                              'Select a data plan',
                              style: TextStyle(
                                color: textColorWhite,
                              ),
                            ),
                          ),
                        ),
                      ),
                      (dataError)
                          ? const Text('select network provider!',
                              style: TextStyle(
                                color: Colors.red,
                              ))
                          : Container(),

                      const SizedBox(
                        height: 20,
                      ),
                      //
                      MyMoneyField(
                        myTextFormController: amountController,
                        fieldName: 'Amount',
                        editable: true,
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
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0.0),
                        child: propertyBtn(
                          card_margin:
                              const EdgeInsets.only(top: 0, left: 0, right: 0),
                          onTap: () async {
                            print('disamount $disAmount');
                            if (networkSelected != null &&
                                disAmount != '0' &&
                                phoneController.text != '') {
                              setState(() {
                                isLoading = true;
                                // showError = false;
                                phoneError = false;
                                networkError = false;
                                amountError = false;
                              });

                              Future.delayed(const Duration(seconds: 1), () {
                                setState(() {
                                  amountController.text = '';
                                  isLoading = false;
                                });
                                verifySelectedAirtime();
                              });
                            } else {
                              setState(() {
                                isLoading = false;
                              });
                              if (phoneController.text == '') {
                                setState(() {
                                  phoneError = true;
                                });
                              } else if (disAmount == null ||
                                  disAmount == '0') {
                                setState(() {
                                  amountError = true;
                                });
                              } else if (networkSelected == null) {
                                setState(() {
                                  networkError = true;
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

  //Select Data Plan Bottom Sheet
  selectDataPlanBottomSheet() {
    return showSlidingBottomSheet(
      context,
      builder: (context) => SlidingSheetDialog(
        cornerRadius: 16,
        snapSpec: const SnapSpec(
          snap: true,
          snappings: [0.8, 1.0],
          positioning: SnapPositioning.relativeToAvailableSpace,
        ),
        builder: myCustomBuildSheetDataPlan,
        headerBuilder: myCustomHeaderBuilderDataPlan,
      ),
    );
  }

  Widget myCustomHeaderBuilderDataPlan(BuildContext context, SheetState state) {
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

  Widget myCustomBuildSheetDataPlan(context, state) {
    return Material(
      child: Obx(
        () => (billController.billCatList.isEmpty)
            ? Column(
                children: [
                  const Text(
                    'Select a Plan',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ShimmerCard(
                      width: double.infinity,
                      height: 100,
                      beginAlignment: Alignment.topLeft,
                      endAlignment: Alignment.bottomRight,
                      backgroundColor: Colors.white,
                      shimmerColor: Colors.grey.shade200,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ShimmerCard(
                      width: double.infinity,
                      height: 100,
                      beginAlignment: Alignment.topLeft,
                      endAlignment: Alignment.bottomRight,
                      backgroundColor: Colors.white,
                      shimmerColor: Colors.grey.shade200,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ShimmerCard(
                      width: double.infinity,
                      height: 100,
                      beginAlignment: Alignment.topLeft,
                      endAlignment: Alignment.bottomRight,
                      backgroundColor: Colors.white,
                      shimmerColor: Colors.grey.shade200,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ShimmerCard(
                      width: double.infinity,
                      height: 100,
                      beginAlignment: Alignment.topLeft,
                      endAlignment: Alignment.bottomRight,
                      backgroundColor: Colors.white,
                      shimmerColor: Colors.grey.shade200,
                    ),
                  ),
                ],
              )
            : ListView(
                padding: const EdgeInsets.all(10),
                shrinkWrap: true,
                primary: false,
                children: [
                  const Text(
                    'Select a Plan',
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
                    // height: 200,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(0),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: const ClampingScrollPhysics(),
                      itemCount: billController.billCatList.length,
                      itemBuilder: (BuildContext context, int index) {
                        var dataPlans = billController.billCatList[index];
                        return InkWell(
                          onTap: () {
                            setState(() {
                              amountController.text =
                                  dataPlans.amount.toString();
                              disAmount = dataPlans.amount.toString();

                              itemCode = dataPlans.itemCode;
                              billerCode = dataPlans.billerCode;
                              billerName = dataPlans.billerName;
                            });

                            Get.back();
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    dataPlans.name!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(dataPlans.billerName!),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                      '${CurrencyFormatter.getCurrencyFormatter(
                                    amount: dataPlans.amount.toString(),
                                  )}'),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  //botom sheet Airitme
  verifySelectedAirtime() {
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
            'Confirm Data Purchase',
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
            child: ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          'Phone Number',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          phoneController.text,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          'Network',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '$networkSelected',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          'Data Plan',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '$billerName',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          'Amount',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '${CurrencyFormatter.getCurrencyFormatter(
                            amount: disAmount.toString(),
                          )}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
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
                if (disAmount != null &&
                    networkSelected != null &&
                    phoneController.text != '') {
                  verifyTransactionPin();

                  Future.delayed(const Duration(seconds: 1), () {
                    setState(() {
                      amountController.text = '';
                      isLoading = false;
                    });
                  });
                }
              },
              title: 'Confirm Purchase',
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
                (fingerprintAuth == true)
                    ? Expanded(
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
                                authenticated = true;
                              });
                            }, // end onSubmit
                          ),
                        ),
                      )
                    : Container(),
                Expanded(
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
                                  completeBillTransaction(
                                    amount: disAmount,
                                    network: networkSelected!,
                                    phoneNumber: phoneController.text,
                                    billerCode: billerCode!,
                                    billerName: billerName!,
                                    itemCode: itemCode!,
                                    isAirtime: false,
                                    userId: user_id!,
                                  );
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
                if (disAmount != null &&
                    networkSelected != null &&
                    phoneController.text != '') {
                  completeTransactionPin(
                    transactionPin: transactionPin!,
                    amount: disAmount,
                    network: networkSelected!,
                    phoneNumber: phoneController.text,
                    billerCode: billerCode!,
                    billerName: billerName!,
                    itemCode: itemCode!,
                    isAirtime: false,
                    userId: user_id!,
                  );

                  Future.delayed(const Duration(seconds: 1), () {
                    setState(() {
                      amountController.text = '';
                      isLoading = false;
                    });
                  });
                }
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

  completeBillTransaction({
    required String amount,
    required String network,
    required String phoneNumber,
    required String billerCode,
    required String billerName,
    required String itemCode,
    required bool isAirtime,
    required String userId,
  }) async {
    setState(() {
      pageLoading = true;
    });
    var status = await accountController.purchaseBill(
      amount: amount,
      network: network,
      phoneNumber: phoneNumber,
      billerCode: billerCode,
      billerName: billerName,
      itemCode: itemCode,
      isAirtime: isAirtime,
      userId: userId,
    );

    setState(() {
      pageLoading = false;
    });
    displayResult(status);
  }

  completeTransactionPin({
    required String transactionPin,
    required String amount,
    required String network,
    required String phoneNumber,
    required String billerCode,
    required String billerName,
    required String itemCode,
    required bool isAirtime,
    required String userId,
  }) async {
    setState(() {
      pageLoading = true;
    });
    var status = await accountController.verifyTransactionPin(
      transactionPin: transactionPin!,
      amount: disAmount,
      network: networkSelected!,
      phoneNumber: phoneController.text,
      billerCode: billerCode!,
      billerName: billerName!,
      itemCode: itemCode!,
      isAirtime: isAirtime,
      userId: userId,
    );

    setState(() {
      pageLoading = false;
    });
    displayResult(status);
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
