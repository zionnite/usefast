import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:usefast/model/account_model.dart';
import 'package:usefast/model/flutterwave_bill_model.dart';
import 'package:usefast/model/transaction_model.dart';

import '../util/common.dart';

class ApiServices {
  static var client = http.Client();
  static const String _mybaseUrl = baseUrl;

  /***
   * below relife start
   */

  static const String _signup = 'signup_authorization';
  static const String _login = 'login_authorization';
  static const String _resetPassword = 'reset_password';

  static const String _count_msg = 'count_msg';
  static const String _checkIfBan = 'check_ifBan';
  static const String _deleteAccount = 'delete_account';
  static const String _has_new_update = 'has_new_update';
  static const String _ios_store_link = 'ios_store_link';
  static const String _android_store_link = 'android_store_link';

  //
  static const String _prof_of_payment = 'submit_payment_prof';
  static const String _get_transaction = 'get_transaction';
  static const String _getAccountDetails = 'get_wallet_detail';
  static const String _verify_deposit = 'verify_deposit';

  static Future uploadProfOfPayment({
    required String userId,
    required String transType,
    required File? image,
    required String amount,
    required String transMethod,
  }) async {
    try {
      final uri = Uri.parse('$_mybaseUrl$_prof_of_payment/$userId');
      var request = http.MultipartRequest('POST', uri);

      request.fields['user_id'] = userId.toString();
      request.fields['amount'] = amount.toString();
      request.fields['trans_type'] = transType.toString();
      request.fields['trans_method'] = transMethod.toString();

      var productImage =
          await http.MultipartFile.fromPath('doc_file', image!.path!);
      request.files.add(productImage);

      var respond = await request.send();

      if (respond.statusCode == 200) {
        var result = await respond.stream.bytesToString();
        final j = json.decode(result) as Map<String, dynamic>;
        bool status = j['status'];

        return status;
      } else {
        showSnackBar(
          title: 'Oops!',
          msg: 'could not connect to server',
          backgroundColor: Colors.red,
        );
        return false;
      }
    } catch (ex) {
      return false;
    }
  }

  static Future getTransaction(var pageNum, var userId, var adminStatus) async {
    try {
      final uri = Uri.parse('$_mybaseUrl$_get_transaction/$pageNum/$userId');

      var response = await http.post(uri, body: {
        'admin_status': adminStatus.toString(),
      });

      if (response.statusCode == 200) {
        var body = response.body;

        final j = json.decode(body) as Map<String, dynamic>;
        String status = j['status'];
        if (status == 'success') {
          var disData = j['transaction'] as List;

          final data = disData
              .map<Transaction>((json) => Transaction.fromJson(json))
              .toList();
          return data;
        }
      } else {
        return showSnackBar(
          title: 'Oops!',
          msg: 'could not connect to server',
          backgroundColor: Colors.red,
        );
      }
    } catch (ex) {}
  }

  static Future getWalletDetail(var userId, var adminStatus) async {
    try {
      final result = await client.get(
          Uri.parse('$_mybaseUrl$_getAccountDetails/$userId/$adminStatus'));

      if (result.statusCode == 200) {
        final data = accountModelFromJson(result.body);
        return data;
      } else {
        return showSnackBar(
          title: 'Oops!',
          msg: 'could not connect to server',
          backgroundColor: Colors.red,
        );
      }
    } catch (ex) {
      // print(ex);
      // return showSnackBar(
      //   title: 'Oops!',
      //   msg: ex.toString(),
      //   backgroundColor: Colors.red,
      // );
    }
  }

  static Future verifyAccountDeposit({
    required String userId,
    required String txRef,
    required String transactionId,
  }) async {
    try {
      print('initializing connection');
      final uri = Uri.parse('$_mybaseUrl$_verify_deposit/$userId/false');

      var response = await http.post(uri, body: {
        'userId': userId.toString(),
        'txRef': txRef.toString(),
        'transactionId': transactionId.toString(),
      });

      print('connecting....');
      if (response.statusCode == 200) {
        var body = response.body;

        print('outpouting body $body');

        final j = json.decode(body) as Map<String, dynamic>;
        bool status = j['status'];
        if (status) {
          var disData = j['wallet'];

          final data = accountModelFromJson(jsonEncode(disData).toString());
          return data;
        }
      } else {
        return showSnackBar(
          title: 'Oops!',
          msg: 'could not connect to server',
          backgroundColor: Colors.red,
        );
      }
    } catch (ex) {
      print(ex.toString());
    }
  }

  static Future fetchBillCategories() async {
    try {
      Map<String, String> header = {};
      header["Authorization"] =
          'Bearer FLWSECK_TEST-e87034a1db84700165c21f6cd3c2ef54-X';
      header["Content-Type"] = 'application/json';
      final uri = Uri.parse('https://api.flutterwave.com/v3/bill-categories');

      var response = await http
          .get(
            uri,
            headers: header,
          )
          .timeout(const Duration(minutes: 60));

      if (response.statusCode == 200) {
        var body = response.body;

        final j = json.decode(body) as Map<String, dynamic>;
        String status = j['status'];
        if (status == 'success') {
          var disData = j['data'] as List;

          final data =
              disData.map<Datum>((json) => Datum.fromJson(json)).toList();
          return data;
        }
      } else {
        return showSnackBar(
          title: 'Oops!',
          msg: 'could not connect to server',
          backgroundColor: Colors.red,
        );
      }
    } catch (ex) {
      // print(ex.toString());
    }
  }

  static Future fetchBillDisDataPlan({required String billerCode}) async {
    try {
      Map<String, String> header = {};
      header["Authorization"] =
          'Bearer FLWSECK_TEST-e87034a1db84700165c21f6cd3c2ef54-X';
      header["Content-Type"] = 'application/json';
      final uri = Uri.parse(
          'https://api.flutterwave.com/v3/bill-categories?biller_code=$billerCode');
      var response = await http
          .get(
            uri,
            headers: header,
          )
          .timeout(const Duration(minutes: 60));

      if (response.statusCode == 200) {
        var body = response.body;
        final j = json.decode(body) as Map<String, dynamic>;
        String status = j['status'];
        if (status == 'success') {
          var disData = j['data'] as List;

          final data =
              disData.map<Datum>((json) => Datum.fromJson(json)).toList();
          return data;
        }
      } else {
        return showSnackBar(
          title: 'Oops!',
          msg: 'could not connect to server',
          backgroundColor: Colors.red,
        );
      }
    } catch (ex) {
      // print(ex.toString());
    }
  }
}
