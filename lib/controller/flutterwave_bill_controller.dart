import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:usefast/model/bank_list_model.dart' as bank;
import 'package:usefast/model/flutterwave_bill_model.dart';
import 'package:usefast/model/flutterwave_bill_model_cables.dart' as cables;
import 'package:usefast/services/api_services.dart';
import 'package:usefast/util/common.dart';

class FlutterWaveBillController extends GetxController {
  FlutterWaveBillController get getXID => Get.find<FlutterWaveBillController>();

  var page_num = 1;
  var isRequestProcessing = 'null'.obs;
  var isMoreDataAvailable = true.obs;
  var billCatList = <Datum>[].obs;
  var billCatListCables = <cables.Datum>[].obs;
  var bankList = <bank.Datum>[].obs;
  var isBankProcessing = 'null'.obs;

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

  fetchBillElectricProvider() async {
    billCatList.clear();
    var seeker = await ApiServices.fetchBillElectricProvider();
    if (seeker != null) {
      isRequestProcessing.value = 'yes';
      billCatList.value = seeker.cast<Datum>();
    } else {
      isRequestProcessing.value = 'no';
    }
  }

  fetchBillWifiProvider() async {
    billCatList.clear();
    var seeker = await ApiServices.fetchBillWifiProvider();
    if (seeker != null) {
      isRequestProcessing.value = 'yes';
      billCatList.value = seeker.cast<Datum>();
    } else {
      isRequestProcessing.value = 'no';
    }
  }

  fetchBillCableProvider() async {
    var seeker = await ApiServices.fetchBillCableProvider();
    if (seeker != null) {
      isRequestProcessing.value = 'yes';
      billCatListCables.value = seeker.cast<cables.Datum>();
    } else {
      isRequestProcessing.value = 'no';
    }
  }

  fetchBankList() async {
    var seeker = await ApiServices.fetchBankListProvider();
    if (seeker != null) {
      isBankProcessing.value = 'yes';
      bankList.value = seeker.cast<bank.Datum>();
    } else {
      isBankProcessing.value = 'no';
    }
  }
}
