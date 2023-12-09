import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usefast/constant.dart';
import 'package:usefast/controller/account_controller.dart';
import 'package:usefast/util/common.dart';
import 'package:usefast/widgets/my_text_field_num.dart';
import 'package:usefast/widgets/my_textfield_icon.dart';
import 'package:usefast/widgets/property_btn.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final accountController = AccountController().getXID;

  TextEditingController fullnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  bool pageLoading = false;
  bool isLoading = false;

  final List<String> _gender = [
    'Male',
    'Female',
  ];

  final format = DateFormat("yyyy-MM-dd");
  final timeFormat = DateFormat("HH:mm");
  DateTime? selectedDate, selectedTime;
  var selectedGender;

  bool phoneError = false;
  bool nameError = false;
  bool dateError = false;
  bool genderError = false;

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

        fullnameController.text = fullName!;
        phoneController.text = phoneNumber!;
        DateFormat inputFormat = DateFormat('yyyy-MM-dd');
        selectedDate = inputFormat.parse('${DateTime.parse("$age")}');

        selectedGender = sex;
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
                        'Edit Personal Detail',
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
                        myTextFormController: fullnameController,
                        fieldName: 'Full Name',
                        prefix: Icons.person,
                      ),
                      (nameError)
                          ? const Text(
                              'Name required',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            )
                          : Container(),
                      const SizedBox(
                        height: 15,
                      ),
                      MyNumField(
                        myTextFormController: phoneController,
                        fieldName: 'Phone Number',
                        prefix: Icons.call,
                        onChange: (string) {},
                      ),
                      (phoneError)
                          ? const Text(
                              'Phone number required',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            )
                          : Container(),
                      const SizedBox(
                        height: 15,
                      ),
                      DateTimeField(
                        format: format,
                        onShowPicker: (context, currentValue) {
                          return showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            initialDate: selectedDate ?? DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                        },
                        style: const TextStyle(color: Colors.white),
                        onChanged: (val) {
                          setState(() {
                            selectedDate = val;
                          });
                          print(val);
                        },
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                            ),
                          ),
                          labelText:
                              (selectedDate == null || selectedDate == '')
                                  ? 'Date'
                                  : "$age"!,
                          labelStyle: const TextStyle(color: Colors.white),
                          hintText: 'Select Date',
                          hintStyle: const TextStyle(color: Colors.white),
                          prefixIcon: const Icon(
                            Icons.calendar_month,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      (dateError)
                          ? const Text(
                              'Date of Birth required',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            )
                          : Container(),
                      const SizedBox(
                        height: 15,
                      ),
                      CustomDropdown<String>(
                        closedSuffixIcon: const Icon(
                          Icons.arrow_drop_down_outlined,
                          color: Colors.white,
                        ),
                        closedFillColor: kSecondaryColor,
                        hintText: 'Select Gender',
                        items: _gender,
                        initialItem: (selectedGender == 'Male')
                            ? _gender[0]
                            : (selectedGender == 'Female')
                                ? _gender[1]
                                : null,
                        onChanged: (value) {
                          setState(() {
                            selectedGender = value;
                          });
                        },
                      ),
                      (genderError)
                          ? const Text(
                              'Gender not selected',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            )
                          : Container(),
                      const SizedBox(height: 20),
                      propertyBtn(
                        borderRadius: 30,
                        elevation: 1,
                        card_margin:
                            const EdgeInsets.only(top: 0, left: 0, right: 0),
                        onTap: () async {
                          if (fullnameController.text != null &&
                              selectedGender != null &&
                              phoneController.text != '' &&
                              selectedDate != null) {
                            setState(() {
                              pageLoading = true;
                              isLoading = true;
                              nameError = false;
                              phoneError = false;
                              dateError = false;
                              genderError = false;
                            });

                            Future.delayed(const Duration(seconds: 1),
                                () async {
                              setState(() {
                                isLoading = false;
                              });

                              var status =
                                  await accountController.updateUserBio(
                                fullName: fullnameController.text,
                                phone: phoneController.text,
                                age: selectedDate.toString(),
                                sex: selectedGender,
                                my_id: user_id!,
                              );

                              displayBottomSheet(status);
                            });
                          } else {
                            setState(() {
                              isLoading = false;
                            });
                            if (fullnameController.text == '') {
                              setState(() {
                                nameError = true;
                              });
                            } else if (phoneController.text == '') {
                              setState(() {
                                phoneError = true;
                              });
                            } else if (selectedDate == null) {
                              setState(() {
                                dateError = true;
                              });
                            } else if (selectedGender == null) {
                              setState(() {
                                genderError = true;
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
