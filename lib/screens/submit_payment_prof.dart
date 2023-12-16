import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:usefast/constant.dart';
import 'package:usefast/controller/trade_controller.dart';
import 'package:usefast/util/common.dart';
import 'package:usefast/widgets/my_money_field.dart';
import 'package:usefast/widgets/property_btn.dart';

class SubmitPaymentProf extends StatefulWidget {
  const SubmitPaymentProf({Key? key, required this.transType})
      : super(key: key);
  final String transType;

  @override
  State<SubmitPaymentProf> createState() => _SubmitPaymentProfState();
}

class _SubmitPaymentProfState extends State<SubmitPaymentProf> {
  final String userId = '1';
  String? disAmount;

  final tradeController = TradeController().getXID;

  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController docFileNameController = TextEditingController();

  final format = DateFormat("yyyy-MM-dd");
  final timeFormat = DateFormat("HH:mm");
  var selectedDate, selectedTime;

  bool isLoading = false;

  bool showError = false;
  File? _doc_file;
  String? _doc_ext;

  File? _image;
  Future _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image == null) {
        setState(() {
          isLoading = false;
        });
        return;
      }
      File? img = File(image.path);

      setState(() {
        _image = img;
      });
    } on PlatformException catch (e) {
      showSnackBar(
        title: 'Oops!',
        msg: 'Invalid image selected. Please select another image',
        backgroundColor: Colors.red,
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  //change here
  final _controller = TextEditingController();
  static const _locale = 'en';
  String _formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(int.parse(s));
  String get _currency =>
      NumberFormat.compactSimpleCurrency(locale: _locale).currencySymbol;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        title: const Text('Trade Center'),
        backgroundColor: kPrimaryColor,
        centerTitle: false,
        elevation: 5,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //const PropertyAppBar(title: 'Book Inspection'),

            Container(
              padding: const EdgeInsets.only(top: 0, left: 8, right: 8),
              child: Column(
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  MyMoneyField(
                    myTextFormController: amountController,
                    fieldName: 'Amount',
                    prefix: Icons.attach_money,
                    onChange: (string) {
                      if (amountController.text.isNotEmpty) {
                        string = '${_formatNumber(string.replaceAll(',', ''))}';
                        amountController.value = TextEditingValue(
                          text: string,
                          selection:
                              TextSelection.collapsed(offset: string.length),
                        );
                      } else {
                        setState(() {
                          string = '0';
                        });
                      }
                      setState(() {
                        disAmount = string;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 0,
                  ),
                  InkWell(
                    onTap: () async {
                      await _pickImage(ImageSource.gallery);
                    },
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: kSecondaryColor,
                        ),
                        width: double.infinity,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 0.0,
                            vertical: 19,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.file_open,
                                color: Colors.white,
                              ),
                              SizedBox(width: 5),
                              Text(
                                'Select Document',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: (_image == null)
                        ? Container()
                        : Container(
                            height: 200.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.grey.shade200,
                            ),
                            child: Center(
                              child: _image == null
                                  ? Container()
                                  : Image.file(
                                      File(_image!.path!),
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                  ),
                  const SizedBox(
                    height: 0,
                  ),
                ],
              ),
            ),
            (showError)
                ? const Text(
                    'No File was selected.\nYou cann\'t upload empty document\n Or Amount Field is empty',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 17,
                    ),
                    textAlign: TextAlign.center,
                  )
                : Container(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: propertyBtn(
                borderRadius: 30,
                elevation: 0,
                card_margin: const EdgeInsets.only(top: 12, left: 8, right: 8),
                onTap: () async {
                  if (_image != null && amountController.text != '') {
                    setState(() {
                      isLoading = true;
                      showError = false;
                    });

                    if (amountController.text != '' && _image != null) {
                      await tradeController.submitPayment(
                        userId: userId,
                        image: _image,
                        amount: disAmount!,
                        transType: widget.transType,
                        transMethod: 'sell',
                      );

                      Future.delayed(const Duration(seconds: 1), () {
                        setState(() {
                          amountController.text = '';
                          _image = null;
                          isLoading = false;
                        });
                      });
                    }
                  } else {
                    setState(() {
                      showError = true;
                    });
                  }
                },
                title: 'submit',
                fontSize: 15,
                bgColor: kSecondaryColor,
                isLoading: isLoading,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
