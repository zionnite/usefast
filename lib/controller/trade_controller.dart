import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:usefast/services/api_services.dart';
import 'package:usefast/util/common.dart';

class TradeController extends GetxController {
  TradeController get getXID => Get.find<TradeController>();

  var page_num = 1;
  var isRequestProcessing = 'null'.obs;
  var isMoreDataAvailable = true.obs;
  // var requestList = <RequestModel>[].obs;

  // String? user_id;
  // bool? admin_status;

  @override
  void onInit() async {
    super.onInit();
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // user_id = prefs.getString('user_id');
    // admin_status = prefs.getBool('admin_status');
    // await fetchRequest(page_num);
  }

  // fetchRequest(pageNum, user_id, admin_status) async {
  //   var seeker = await ApiServices.getRequest(pageNum, user_id, admin_status);
  //   if (seeker != null) {
  //     isRequestProcessing.value = 'yes';
  //     requestList.value = seeker.cast<RequestModel>();
  //   } else {
  //     isRequestProcessing.value = 'no';
  //   }
  // }
  //
  // fetchRequestMore(pageNum, user_id, admin_status) async {
  //   var seeker = await ApiServices.getRequest(pageNum, user_id, admin_status);
  //   if (seeker != null) {
  //     requestList.addAll(seeker.cast<RequestModel>());
  //   } else {}
  // }

  submitPayment({
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
