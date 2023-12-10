import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h3m_shimmer_card/h3m_shimmer_card.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';
import 'package:searchable_listview/searchable_listview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_sheet2/sliding_sheet2.dart';
import 'package:usefast/constant.dart';
import 'package:usefast/controller/account_controller.dart';
import 'package:usefast/controller/flutterwave_bill_controller.dart';
import 'package:usefast/model/bank_list_model.dart' as bank;
import 'package:usefast/util/common.dart';
import 'package:usefast/widgets/my_text_field_num.dart';
import 'package:usefast/widgets/my_textfield_icon.dart';
import 'package:usefast/widgets/property_btn.dart';

class UpdateBankDetailPage extends StatefulWidget {
  const UpdateBankDetailPage({Key? key}) : super(key: key);

  @override
  State<UpdateBankDetailPage> createState() => _UpdateBankDetailPageState();
}

class _UpdateBankDetailPageState extends State<UpdateBankDetailPage> {
  final accountController = AccountController().getXID;
  final billController = FlutterWaveBillController().getXID;

  TextEditingController accountName = TextEditingController();
  TextEditingController accountNumber = TextEditingController();
  bool pageLoading = false;
  bool isLoading = false;

  final List<String> _gender = [
    'Male',
    'Female',
  ];

  var selectedGender;

  bool accNameError = false;
  bool accNumberError = false;
  bool dateError = false;
  bool bankSelectError = false;
  String? bankName;
  String? bankCode;

  String? user_id;
  String? fullName;
  String? user_name;
  String? user_status;
  bool? admin_status;
  bool? isUserLogin;
  String? image_name;
  String? phoneNumber;
  String? age;
  String? sex;
  String? login_status;
  String? account_name;
  String? account_number;
  String? bank_name;
  String? bank_code;
  String? isbank_verify;
  String? pin;
  String? pin_set;

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
    var age1 = prefs.getString('age');
    var sex1 = prefs.getString('sex');
    var login_status1 = prefs.getString('login_status');
    var account_name1 = prefs.getString('account_name');
    var account_number1 = prefs.getString('account_number');
    var bank_name1 = prefs.getString('bank_name');
    var bank_code1 = prefs.getString('bank_code');
    var isbank_verify1 = prefs.getString('isbank_verify');
    var pin1 = prefs.getString('pin');
    var pin_set1 = prefs.getString('pin_set');

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
        age = age1;
        sex = sex1;
        login_status = login_status1;
        account_name = account_name1;
        account_number = account_number1;
        bank_name = bank_name1;
        bank_code = bank_code1;
        isbank_verify = isbank_verify1;
        pin = pin1;
        pin_set = pin_set1;

        //

        bankName = bank_name;
        bankCode = bank_code;
        accountNumber.text = account_number!;
        accountName.text = account_name!;
      });

      await billController.fetchBankList();
    }
  }

  @override
  void initState() {
    initUserDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      const SizedBox(
                        width: 20,
                      ),
                      const Text(
                        'Update Bank Detail',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      MyTextFieldIcon(
                        myTextFormController: accountName,
                        fieldName: 'Account Name',
                        prefix: Icons.person,
                      ),
                      (accNameError)
                          ? const Text(
                              'Account is Name required',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            )
                          : Container(),
                      const SizedBox(
                        height: 15,
                      ),
                      MyNumField(
                        myTextFormController: accountNumber,
                        fieldName: 'Account Number',
                        prefix: Icons.account_balance_sharp,
                        onChange: (string) {},
                      ),
                      (accNumberError)
                          ? const Text(
                              'Account number is required',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            )
                          : Container(),
                      const SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        onTap: () async {
                          selectDataPlanBottomSheet();
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
                              (bankName != '')
                                  ? bankName.toString()
                                  : 'Select Bank',
                              style: TextStyle(
                                color: textColorWhite,
                              ),
                            ),
                          ),
                        ),
                      ),
                      (bankSelectError)
                          ? const Text('select a Bank',
                              style: TextStyle(
                                color: Colors.red,
                              ))
                          : Container(),
                      const SizedBox(height: 20),
                      propertyBtn(
                        borderRadius: 30,
                        elevation: 1,
                        card_margin:
                            const EdgeInsets.only(top: 0, left: 0, right: 0),
                        onTap: () async {
                          if (accountName.text != null &&
                              bankName != '' &&
                              accountNumber.text != '') {
                            setState(() {
                              pageLoading = true;
                              isLoading = true;
                              accNameError = false;
                              accNumberError = false;
                              dateError = false;
                              bankSelectError = false;
                            });

                            Future.delayed(const Duration(seconds: 1),
                                () async {
                              setState(() {
                                isLoading = false;
                              });

                              var status =
                                  await accountController.updateUserBank(
                                accountName: accountName.text,
                                accountNum: accountNumber.text,
                                bankName: bankName!,
                                bankCode: bankCode!,
                                my_id: user_id!,
                              );

                              displayBottomSheet(status);
                            });
                          } else {
                            setState(() {
                              isLoading = false;
                            });
                            if (accountName.text == '') {
                              setState(() {
                                accNameError = true;
                              });
                            } else if (accountNumber.text == '') {
                              setState(() {
                                accNumberError = true;
                              });
                            } else if (bankName == '') {
                              setState(() {
                                bankSelectError = true;
                              });
                            }
                          }
                        },
                        title: 'Update',
                        bgColor: kSecondaryColor,
                        isLoading: isLoading,
                      ),
                    ],
                  ),
                )
              ],
            ),
          )),
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
        () => (billController.bankList.isEmpty)
            ? Column(
                children: [
                  const Text(
                    'Select Bank',
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
            : Column(
                children: [
                  const Text(
                    'Select Bank',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 800,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SearchableList<bank.Datum>(
                      listViewPadding:
                          const EdgeInsets.symmetric(horizontal: 0),
                      initialList: billController.bankList,
                      builder: (list, index, bankList) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              bankCode = bankList.code;
                              bankName = bankList.name;
                            });

                            Get.back();
                          },
                          child: Card(
                            child: Container(
                              color: Colors.white,
                              padding: const EdgeInsets.all(18.0),
                              child: Text(
                                '${bankList.name}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      filter: (value) => billController.bankList
                          .where(
                            (element) =>
                                element.name!.toLowerCase().contains(value),
                          )
                          .toList(),
                      emptyWidget: const Text('No Bank Found with that name'),
                      inputDecoration: InputDecoration(
                        labelText: "Search Bank",
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.blue,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  displayBottomSheet(var status) {
    setState(() {
      pageLoading = false;
    });
    if (status == true) {
      displayBottomSheetFeedback(
        context: context,
        title: 'Congratulation',
        desc: 'Update Successful...',
        image_name: 'assets/images/check.png',
        onTap: () {
          Get.back();
        },
        onTapCancel: () {
          Get.back();
        },
      );
    } else {
      displayBottomSheetFeedback(
        context: context,
        title: 'Oops!',
        desc: '$status',
        image_name: 'assets/images/attention.png',
        onTap: () {
          Get.back();
        },
        onTapCancel: () {
          Get.back();
        },
      );
    }
  }
}
