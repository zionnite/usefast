import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:usefast/model/flutterwave_bill_model.dart';
import 'package:usefast/services/api_services.dart';
import 'package:usefast/util/common.dart';

class FlutterWaveBillController extends GetxController {
  FlutterWaveBillController get getXID => Get.find<FlutterWaveBillController>();

  var page_num = 1;
  var isRequestProcessing = 'null'.obs;
  var isMoreDataAvailable = true.obs;
  var billCatList = <Datum>[].obs;

  @override
  void onInit() async {
    super.onInit();
  }

  fetchBillCategories() async {
    var seeker = await ApiServices.fetchBillCategories();
    if (seeker != null) {
      isRequestProcessing.value = 'yes';
      billCatList.value = seeker.cast<Datum>();
    } else {
      isRequestProcessing.value = 'no';
    }
  }

  fetchBillDisDataPlan({required String billerCode}) async {
    billCatList.clear();
    var seeker = await ApiServices.fetchBillDisDataPlan(billerCode: billerCode);
    if (seeker != null) {
      isRequestProcessing.value = 'yes';
      billCatList.value = seeker.cast<Datum>();
    } else {
      isRequestProcessing.value = 'no';
    }
  }

  submitBill({
    required String userId,
    required String transType,
    required String amount,
    required String transMethod,
    required File? image,
  }) async {
    bool status = await ApiServices.uploadProfOfPayment(
        userId: userId,
        transType: transType,
        image: image,
        amount: amount,
        transMethod: transMethod);

    String? msg;

    if (status) {
      msg = 'awaiting Admin approval';
      showSnackBar(title: 'Submitted', msg: msg, backgroundColor: Colors.blue);
    } else {
      msg = 'Database busy, please try again later!';
      showSnackBar(title: 'Oops!', msg: msg, backgroundColor: Colors.blue);
    }

    return status;
  }
}
