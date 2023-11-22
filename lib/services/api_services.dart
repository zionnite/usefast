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
  static const String privateKey =
      'FLWSECK_TEST-e87034a1db84700165c21f6cd3c2ef54-X';

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
  static const String _verify_transaction_pin = 'verify_transaction';
  static const String _debit_wallet = 'debit_wallet';
  static const String _add_transaction_history = 'add_transaction_history';
  static const String _refund_wallet = 'refund_wallet';

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
      header["Authorization"] = 'Bearer $privateKey';
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
      header["Authorization"] = 'Bearer $privateKey';
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

  static Future verifyPin({
    required String userId,
    required String amount,
    required String pin,
  }) async {
    try {
      final uri = Uri.parse('$_mybaseUrl$_verify_transaction_pin/$userId');

      var response = await http.post(uri, body: {
        'userId': userId.toString(),
        'amount': amount.toString(),
        'pin': pin.toString(),
      });

      if (response.statusCode == 200) {
        var body = response.body;

        final j = json.decode(body) as Map<String, dynamic>;
        String status = j['status'];
        print(status);
        return status;
      } else {
        showSnackBar(
          title: 'Oops!',
          msg: 'could not connect to server ',
          backgroundColor: Colors.red,
          duration: Duration(seconds: 56),
        );
      }
    } catch (ex) {
      print(ex.toString());
    }
  }

  static Future validateInputDetails({
    required String phoneNumber,
    required String billerCode,
    required String billerName,
    required String itemCode,
  }) async {
    print('started validating');
    try {
      Map<String, String> header = {};
      header["Authorization"] = 'Bearer $privateKey';
      header["Content-Type"] = 'application/json';
      final uri = Uri.parse(
          'https://api.flutterwave.com/v3/bill-items/$itemCode/validate?code=$billerCode&customer=$phoneNumber');
      var response = await http
          .get(uri, headers: header)
          .timeout(const Duration(minutes: 60));

      print('this response ${response.statusCode}');
      print('this response body ${response.body}');
      var body = response.body;
      final j = json.decode(body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        String status = j['status'];
        String message = j['message'];
        if (status == 'success') {
          return status;
        } else {
          return message;
        }
      } else {
        String status = j['status'];
        String message = j['message'];
        if (status == 'success') {
          return status;
        } else {
          return message;
        }
        print('error validating');
        showSnackBar(
          title: 'Oops!',
          msg: 'could not connect to server',
          backgroundColor: Colors.red,
        );
      }
    } catch (ex) {
      print(ex.toString());
    }
  }

  static Future debitWallet({
    required String userId,
    required String amount,
    required String ref,
    required String billType,
    required String customer,
  }) async {
    print('debbiting wallet');
    try {
      final uri = Uri.parse('$_mybaseUrl$_debit_wallet/$userId');

      var response = await http.post(uri, body: {
        'userId': userId.toString(),
        'amount': amount.toString(),
        'ref': ref.toString(),
        'bill_type': billType.toString(),
        'customer': customer.toString(),
      });

      if (response.statusCode == 200) {
        var body = response.body;

        final j = json.decode(body) as Map<String, dynamic>;
        String status = j['status'];
        print(status);
        return status;
      } else {
        showSnackBar(
          title: 'Oops!',
          msg: 'could not connect to server',
          backgroundColor: Colors.red,
        );
      }
    } catch (ex) {
      print(ex.toString());
    }
  }

  static Future createBillPurchase({
    required String phoneNumber,
    required String billerCode,
    required String billerName,
    required String itemCode,
    required String country,
    required String amount,
    required bool isAirtime,
    required String ref,
  }) async {
    print('creating bill');
    try {
      Map<String, String> header = {};
      header["Authorization"] = 'Bearer $privateKey';
      header["Content-Type"] = 'application/json';
      final uri = Uri.parse('https://api.flutterwave.com/v3/bills');
      var response = await http
          .post(
            uri,
            headers: header,
            body: jsonEncode({
              'country': country,
              'customer': phoneNumber,
              'amount': int.parse(amount),
              'type': (isAirtime) ? 'AIRTIME' : billerName,
              'reference': ref,
            }),
          )
          .timeout(const Duration(minutes: 60));

      print('response statuscode ${response.statusCode}');
      print('response  ${response.body}');
      var body = response.body;
      final j = json.decode(body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        String status = j['status'];
        String message = j['message'];
        if (status == 'success') {
          return status;
        } else {
          return message;
        }
      } else {
        // showSnackBar(
        //   title: 'Oops!',
        //   msg: 'could not connect to server create',
        //   backgroundColor: Colors.red,
        // );
      }
    } catch (ex) {
      print(ex.toString());
    }
  }

  static Future addToTransactionHistory({
    required String userId,
    required String amount,
    required String ref,
    required String billType,
    required String customer,
  }) async {
    print('add to transaction history');
    try {
      final uri = Uri.parse('$_mybaseUrl$_add_transaction_history/$userId');

      var response = await http.post(uri, body: {
        'userId': userId.toString(),
        'amount': amount.toString(),
        'ref': ref.toString(),
        'bill_type': billType.toString(),
        'customer': customer.toString(),
      });

      if (response.statusCode == 200) {
        var body = response.body;

        final j = json.decode(body) as Map<String, dynamic>;
        String status = j['status'];
        if (status != 'fail') {
          var disData = j['transaction'];

          final data = accountModelFromJson(jsonEncode(disData).toString());
          return data;
        } else {
          return status;
        }
      } else {
        showSnackBar(
          title: 'Oops!',
          msg: 'could not connect to server',
          backgroundColor: Colors.red,
        );
      }
    } catch (ex) {
      print(ex.toString());
    }
  }

  static Future refundWallet({
    required String userId,
    required String amount,
    required String ref,
    required String billType,
    required String customer,
  }) async {
    print('Refund wallet');
    try {
      final uri = Uri.parse('$_mybaseUrl$_refund_wallet/$userId');

      var response = await http.post(uri, body: {
        'userId': userId.toString(),
        'amount': amount.toString(),
        'ref': ref.toString(),
        'bill_type': billType.toString(),
        'customer': customer.toString(),
      });

      if (response.statusCode == 200) {
        var body = response.body;

        final j = json.decode(body) as Map<String, dynamic>;
        String status = j['status'];
        if (status != 'fail') {
          var disData = j['transaction'];

          final data = accountModelFromJson(jsonEncode(disData).toString());
          return data;
        } else {
          return status;
        }
      } else {
        showSnackBar(
          title: 'Oops!',
          msg: 'could not connect to server',
          backgroundColor: Colors.red,
        );
      }
    } catch (ex) {
      print(ex.toString());
    }
  }

  static Future fetchBillElectricProvider() async {
    try {
      Map<String, String> header = {};
      header["Authorization"] = 'Bearer $privateKey';
      header["Content-Type"] = 'application/json';
      final uri = Uri.parse(
          'https://api.flutterwave.com/v3/bill-categories?power=1&country=NG');

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

  static Future fetchBillWifiProvider() async {
    try {
      Map<String, String> header = {};
      header["Authorization"] = 'Bearer $privateKey';
      header["Content-Type"] = 'application/json';
      final uri = Uri.parse(
          'https://api.flutterwave.com/v3/bill-categories?internet=1&country=NG');

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

  static Future fetchBillCableProvider() async {
    try {
      Map<String, String> header = {};
      header["Authorization"] = 'Bearer $privateKey';
      header["Content-Type"] = 'application/json';
      final uri = Uri.parse(
          'https://api.flutterwave.com/v3/bill-categories?cables=1&country=NG');

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
