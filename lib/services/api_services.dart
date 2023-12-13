import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usefast/model/account_model.dart';
import 'package:usefast/model/bank_list_model.dart' as bank;
import 'package:usefast/model/flutterwave_bill_model.dart';
import 'package:usefast/model/transaction_model.dart';
import 'package:usefast/model/user_model.dart';

import '../util/common.dart';

class ApiServices {
  static var client = http.Client();
  static const String _mybaseUrl = baseUrl;
  static const String privateKey =
      'FLWSECK-d46162dc85e05336959b7df588eb67b2-18bf654ca5avt-X';
  static const String publicKey = 'FLWPUBK-48817ec524c2b0f49e2c2ace12021684-X';

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
  static const String _verify_just_pin = 'verify_just_pin';
  static const String _verify_withdraw = 'verify_withdraw';
  static const String _debit_wallet = 'debit_wallet';
  static const String _add_transaction_history = 'add_transaction_history';
  static const String _refund_wallet = 'refund_wallet';
  static const String _get_dis_user = 'get_dis_user';
  static const String _update_profile = 'update_profile';
  static const String _update_profile_image = 'update_profile_image';
  static const String _verify_bank_account = 'verify_bank_account';
  static const String _update_bank_detail = 'update_bank_detail';
  static const String _update_transaction_pin = 'update_transaction_pin';
  static const String _update_email = 'update_email';
  static const String _update_password = 'update_password';

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
        showSnackBar(
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
      // return showSnackBar(
      //   title: 'Oops!',
      //   msg: ex.toString(),
      //   backgroundColor: Colors.red,
      // );
    }
  }

  static Future depositUserFund({
    required String userId,
    required String amount,
    required String ref,
  }) async {
    try {
      final uri = Uri.parse('$_mybaseUrl$_verify_deposit/$userId');

      var response = await http.post(uri, body: {
        'amount': amount.toString(),
        'ref': ref.toString(),
      });

      if (response.statusCode == 200) {
        var body = response.body;

        // print('body $body');
        final j = json.decode(body) as Map<String, dynamic>;
        bool status = j['status'];
        if (status) {
          var disData = j['wallet'];

          final data = accountModelFromJson(jsonEncode(disData).toString());
          return data;
        } else {
          //return status;
        }
      } else {
        print('could not connect to server');
      }
    } catch (ex) {
      print(ex.toString());
    }
  }

  static Future verifyTransaction({
    required String userId,
    required String txRef,
    required String transactionId,
  }) async {
    try {
      Map<String, String> header = {};
      header["Authorization"] = 'Bearer $privateKey';
      header["Content-Type"] = 'application/json';
      final uri = Uri.parse(
          'https://api.flutterwave.com/v3/transactions?tx_ref=$txRef');
      var response = await http
          .get(uri, headers: header)
          .timeout(const Duration(minutes: 60));

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
      }
    } catch (ex) {
      return ex.toString();
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
    } catch (ex) {}
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
    } catch (ex) {}
  }

  static Future verifyPin({
    required String userId,
    required String amount,
    required String pin,
  }) async {
    try {
      final uri = Uri.parse('$_mybaseUrl$_verify_just_pin/$userId');

      var response = await http.post(uri, body: {
        'userId': userId.toString(),
        'amount': amount.toString(),
        'pin': pin.toString(),
      });

      if (response.statusCode == 200) {
        var body = response.body;

        final j = json.decode(body) as Map<String, dynamic>;
        String status = j['status'];

        return status;
      } else {
        return 'could not connect to server ';
      }
    } catch (ex) {
      return ex.toString();
    }
  }

  static Future verifyWithdraw({
    required String userId,
    required String amount,
  }) async {
    try {
      final uri = Uri.parse('$_mybaseUrl$_verify_withdraw/$userId');

      var response = await http.post(uri, body: {
        'userId': userId.toString(),
        'amount': amount.toString(),
      });

      if (response.statusCode == 200) {
        var body = response.body;

        final j = json.decode(body) as Map<String, dynamic>;
        bool status = j['status'];
        if (status) {
          var disData = j['wallet'];

          final data = accountModelFromJson(jsonEncode(disData).toString());
          return data;
        } else {
          //return status;
        }
      } else {
        showSnackBar(
          title: 'Oops!',
          msg: 'could not connect to server ',
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 56),
        );
      }
    } catch (ex) {}
  }

  static Future validateInputDetails({
    required String phoneNumber,
    required String billerCode,
    required String billerName,
    required String itemCode,
  }) async {
    try {
      Map<String, String> header = {};
      header["Authorization"] = 'Bearer $privateKey';
      header["Content-Type"] = 'application/json';
      final uri = Uri.parse(
          'https://api.flutterwave.com/v3/bill-items/$itemCode/validate?code=$billerCode&customer=$phoneNumber');
      var response = await http
          .get(uri, headers: header)
          .timeout(const Duration(minutes: 60));

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

        showSnackBar(
          title: 'Oops!',
          msg: 'could not connect to server',
          backgroundColor: Colors.red,
        );
      }
    } catch (ex) {
      return ex.toString();
    }
  }

  static Future debitWallet({
    required String userId,
    required String amount,
    required String ref,
    required String billType,
    required String customer,
  }) async {
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

        return status;
      } else {
        return 'could not connect to server';
      }
    } catch (ex) {
      return ex.toString();
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
    print('create bill purchase');
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

      var body = response.body;
      print('body $body');
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
    } catch (ex) {}
  }

  static Future addToTransactionHistory({
    required String userId,
    required String amount,
    required String ref,
    required String billType,
    required String customer,
  }) async {
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
    } catch (ex) {}
  }

  static Future refundWallet({
    required String userId,
    required String amount,
    required String ref,
    required String billType,
    required String customer,
  }) async {
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
    } catch (ex) {}
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
    } catch (ex) {}
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
    } catch (ex) {}
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
    } catch (ex) {}
  }

  static Future<String> signUp({
    required String userName,
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final uri = Uri.parse('$_mybaseUrl$_signup');

      var response = await http.post(uri, body: {
        'user_name': userName.toString(),
        'full_name': fullName.toString(),
        'email': email.toString(),
        'phone': phone.toString(),
        'password': password.toString(),
      });
      if (response.statusCode == 200) {
        var body = response.body;

        final j = json.decode(body) as Map<String, dynamic>;
        String status = j['status'];
        if (status == 'success') {
          return 'true';
        } else {
          String msg = j['status_msg'];
          return msg;
        }
      } else {
        showSnackBar(
          title: 'Oops!',
          msg: 'could not connect to server',
          backgroundColor: Colors.red,
        );
        return 'could not connect to server';
      }
    } catch (ex) {
      showSnackBar(
        title: 'Oops!',
        msg: ex.toString(),
        backgroundColor: Colors.red,
      );
      return ex.toString();
    }
  }

  static Future<String> login({
    required String email,
    required String password,
  }) async {
    try {
      final uri = Uri.parse('$_mybaseUrl$_login');

      var response = await http.post(uri, body: {
        'email': email.toString(),
        'password': password.toString(),
      });
      if (response.statusCode == 200) {
        var body = response.body;

        final j = json.decode(body) as Map<String, dynamic>;
        String status = j['status'];
        if (status == 'success') {
          SharedPreferences prefs = await SharedPreferences.getInstance();

          String user_id = j['id'];
          String user_name = j['user_name'];
          String full_name = j['full_name'];
          String email = j['email'];
          String image_name = j['image_name'];
          String status = j['user_status'];
          String phone = j['phone'];
          String age = j['age'];
          String sex = j['sex'];
          String address = j['address'];
          String date_created = j['date_created'];
          String account_name = j['account_name'];
          String account_number = j['account_number'];
          String bank_name = j['bank_name'];
          String bank_code = j['bank_code'];
          String current_balance = j['current_balance'];
          String login_status = j['login_status'];
          bool admin_status = j['admin_status'];
          String isbank_verify = j['isbank_verify'];
          String pin = j['pin'];
          String pin_set = j['pin_set'];

          prefs.setString('user_id', user_id);
          prefs.setString('user_name', user_name);
          prefs.setString('full_name', full_name);
          prefs.setString('email', email);
          prefs.setString('image_name', image_name);
          prefs.setString('user_status', status);
          prefs.setString('phone', phone);
          prefs.setString('age', age);
          prefs.setString('sex', sex);
          prefs.setString('address', address);
          prefs.setString('date_created', date_created);
          prefs.setString('account_name', account_name);
          prefs.setString('account_number', account_number);
          prefs.setString('bank_name', bank_name);
          prefs.setString('bank_code', bank_code);
          prefs.setString('current_balance', current_balance);
          prefs.setString('login_status', login_status);
          prefs.setBool('admin_status', admin_status);
          prefs.setString('isbank_verify', isbank_verify);
          prefs.setBool('isUserLogin', true);
          prefs.setBool('tempLoginStatus', true);
          prefs.setString('pin', pin);
          prefs.setString('pin_set', pin_set);

          var isGuestLogin = prefs.getBool('isGuestLogin');
          if (isGuestLogin != null) {
            prefs.remove("isGuestLogin");
          }

          return 'true';
        } else {
          String msg = j['status_msg'];
          return msg;
        }
      } else {
        showSnackBar(
          title: 'Oops!',
          msg: 'could not connect to server',
          backgroundColor: Colors.red,
        );
        return 'could not connect to server';
      }
    } catch (ex) {
      showSnackBar(
        title: 'Oops!',
        msg: ex.toString(),
        backgroundColor: Colors.red,
      );
      return ex.toString();
    }
  }

  static Future<String> resetPassword({required String email}) async {
    try {
      final uri = Uri.parse('$_mybaseUrl$_resetPassword');

      var response = await http.post(uri, body: {
        'email': email.toString(),
      });
      if (response.statusCode == 200) {
        var body = response.body;

        final j = json.decode(body) as Map<String, dynamic>;
        String status = j['status'];
        if (status == 'success') {
          return 'true';
        } else {
          String msg = j['status_msg'];
          return msg;
        }
      } else {
        showSnackBar(
          title: 'Oops!',
          msg: 'could not connect to server',
          backgroundColor: Colors.red,
        );
        return 'could not connect to server';
      }
    } catch (ex) {
      showSnackBar(
        title: 'Oops!',
        msg: ex.toString(),
        backgroundColor: Colors.red,
      );
      return ex.toString();
    }
  }

  static Future<List<UsersModel?>?> getDisUser(var userId) async {
    try {
      final uri = Uri.parse('$_mybaseUrl$_get_dis_user/$userId');

      final result = await client.get(uri);

      if (result.statusCode == 200) {
        var body = result.body;
        final j = json.decode(body) as Map<String, dynamic>;
        String status = j['status'];
        if (status == 'success') {
          var disData = j['users'] as List;

          final data = disData
              .map<UsersModel>((json) => UsersModel.fromJson(json))
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
    } catch (ex) {
      // return showSnackBar(
      //   title: 'Oops!',
      //   msg: ex.toString(),
      //   backgroundColor: Colors.red,
      // );
    }
  }

  static Future<String> updateUserBio2({
    required String fullName,
    required String phone,
    required String age,
    required String sex,
    required String my_id,
  }) async {
    try {
      final uri = Uri.parse('$_mybaseUrl$_update_profile/$my_id');

      var response = await http.post(uri, body: {
        'full_name': fullName.toString(),
        'phone': phone.toString(),
        'age': age.toString(),
        'sex': sex.toString(),
      });

      if (response.statusCode == 200) {
        var body = response.body;

        final j = json.decode(body) as Map<String, dynamic>;

        String status = j['status'];
        if (status == 'success') {
          SharedPreferences prefs = await SharedPreferences.getInstance();

          String user_id = j['id'].toString();
          String user_name = j['user_name'].toString();
          String full_name = j['full_name'].toString();
          String email = j['email'].toString();
          String image_name = j['image_name'].toString();
          String status = j['user_status'].toString();
          String phone = j['phone'].toString();
          String age = j['age'].toString();
          String sex = j['sex'].toString();
          String address = j['address'].toString();
          String date_created = j['date_created'].toString();
          String account_name = j['account_name'].toString();
          String account_number = j['account_number'].toString();
          String bank_name = j['bank_name'].toString();
          String bank_code = j['bank_code'].toString();
          String current_balance = j['current_balance'].toString();
          String login_status = j['login_status'].toString();
          bool admin_status = j['admin_status'];
          String isbank_verify = j['isbank_verify'].toString();
          String pin = j['pin'].toString();
          String pin_set = j['pin_set'].toString();

          prefs.setString('user_id', user_id);
          prefs.setString('user_name', user_name);
          prefs.setString('full_name', full_name);
          prefs.setString('email', email);
          prefs.setString('image_name', image_name);
          prefs.setString('user_status', status);
          prefs.setString('phone', phone);
          prefs.setString('age', age);
          prefs.setString('sex', sex);
          prefs.setString('address', address);
          prefs.setString('date_created', date_created);
          prefs.setString('account_name', account_name);
          prefs.setString('account_number', account_number);
          prefs.setString('bank_name', bank_name);
          prefs.setString('bank_code', bank_code);
          prefs.setString('current_balance', current_balance);
          prefs.setString('login_status', login_status);
          prefs.setBool('admin_status', admin_status);
          prefs.setString('isbank_verify', isbank_verify);
          prefs.setBool('isUserLogin', true);
          prefs.setBool('tempLoginStatus', true);
          prefs.setString('pin', pin);
          prefs.setString('pin_set', pin_set);

          return 'true';
        } else {
          String msg = j['status_msg'];
          return msg;
        }
      } else {
        return "could not connect to server";
        // return showSnackBar(
        //   title: 'Oops!',
        //   msg: 'could not connect to server',
        //   backgroundColor: Colors.red,
        // );
      }
    } catch (ex) {
      return ex.toString();

      // return showSnackBar(
      //   title: 'Oops!',
      //   msg: ex.toString(),
      //   backgroundColor: Colors.red,
      // );
    }
  }

  static Future<String?> updateUserBio({
    required String fullName,
    required String phone,
    required String age,
    required String sex,
    required String my_id,
  }) async {
    try {
      final uri = Uri.parse('$_mybaseUrl$_update_profile/$my_id');

      var response = await http.post(uri, body: {
        'full_name': fullName.toString(),
        'phone': phone.toString(),
        'age': age.toString(),
        'sex': sex.toString(),
      });
      if (response.statusCode == 200) {
        var body = response.body;

        final j = json.decode(body) as Map<String, dynamic>;
        String status = j['status'];
        if (status == 'success') {
          SharedPreferences prefs = await SharedPreferences.getInstance();

          String user_id = j['id'];
          String user_name = j['user_name'];
          String full_name = j['full_name'];
          String email = j['email'];
          String image_name = j['image_name'];
          String status = j['user_status'];
          String phone = j['phone'];
          String age = j['age'];
          String sex = j['sex'];
          String address = j['address'];
          String date_created = j['date_created'];
          String account_name = j['account_name'];
          String account_number = j['account_number'];
          String bank_name = j['bank_name'];
          String bank_code = j['bank_code'];
          String current_balance = j['current_balance'];
          String login_status = j['login_status'];
          bool admin_status = j['admin_status'];
          String isbank_verify = j['isbank_verify'];
          String pin = j['pin'];
          String pin_set = j['pin_set'];

          prefs.setString('user_id', user_id);
          prefs.setString('user_name', user_name);
          prefs.setString('full_name', full_name);
          prefs.setString('email', email);
          prefs.setString('image_name', image_name);
          prefs.setString('user_status', status);
          prefs.setString('phone', phone);
          prefs.setString('age', age);
          prefs.setString('sex', sex);
          prefs.setString('address', address);
          prefs.setString('date_created', date_created);
          prefs.setString('account_name', account_name);
          prefs.setString('account_number', account_number);
          prefs.setString('bank_name', bank_name);
          prefs.setString('bank_code', bank_code);
          prefs.setString('current_balance', current_balance);
          prefs.setString('login_status', login_status);
          prefs.setBool('admin_status', admin_status);
          prefs.setString('isbank_verify', isbank_verify);
          prefs.setBool('isUserLogin', true);
          prefs.setBool('tempLoginStatus', true);
          prefs.setString('pin', pin);
          prefs.setString('pin_set', pin_set);

          var isGuestLogin = prefs.getBool('isGuestLogin');
          if (isGuestLogin != null) {
            prefs.remove("isGuestLogin");
          }

          return 'true';
        } else {
          String msg = j['status'];
          return msg;
        }
      } else {
        return showSnackBar(
          title: 'Oops!',
          msg: 'could not connect to server',
          backgroundColor: Colors.red,
        );
      }
    } catch (ex) {
      return ex.toString();
      // return
      // showSnackBar(
      //   title: 'Oops!',
      //   msg: ex.toString(),
      //   backgroundColor: Colors.red,
      // );
    }
  }

  static Future<String> updateUserBank1({
    required String accountName,
    required String accountNum,
    required String bankName,
    required String bankCode,
    required String my_id,
  }) async {
    try {
      final uri = Uri.parse('$_mybaseUrl$_update_bank_detail/$my_id');

      var response = await http.post(uri, body: {
        'account_name': accountName.toString(),
        'account_num': accountNum.toString(),
        'bank_name': bankName.toString(),
        'bank_code': bankCode.toString(),
      });
      if (response.statusCode == 200) {
        var body = response.body;

        final j = json.decode(body) as Map<String, dynamic>;
        String status = j['status'];
        if (status == 'success') {
          SharedPreferences prefs = await SharedPreferences.getInstance();

          String user_id = j['agent_id'];
          String user_name = j['agent_user_name'];
          String full_name = j['agent_full_name'];
          String email = j['agent_email'];
          String image_name = j['agent_image_name'];
          String status = j['agent_status'];
          String phone = j['agent_phone'];
          String age = j['agent_age'];
          String sex = j['agent_sex'];
          String address = j['agent_address'];
          String date_created = j['agent_date_created'];
          String account_name = j['agent_account_name'];
          String account_number = j['agent_account_number'];
          String bank_name = j['agent_bank_name'];
          String bank_code = j['agent_bank_code'];
          String current_balance = j['agent_current_balance'];
          String login_status = j['agent_login_status'];
          String prop_counter = j['agent_prop_counter'];
          bool admin_status = j['admin_status'];
          String isbank_verify = j['isbank_verify'];

          prefs.setString('user_id', user_id);
          prefs.setString('user_name', user_name);
          prefs.setString('full_name', full_name);
          prefs.setString('email', email);
          prefs.setString('image_name', image_name);
          prefs.setString('user_status', status);
          prefs.setString('phone', phone);
          prefs.setString('age', age);
          prefs.setString('sex', sex);
          prefs.setString('address', address);
          prefs.setString('date_created', date_created);
          prefs.setString('account_name', account_name);
          prefs.setString('account_number', account_number);
          prefs.setString('bank_name', bank_name);
          prefs.setString('bank_code', bank_code);
          prefs.setString('current_balance', current_balance);
          prefs.setString('login_status', login_status);
          prefs.setString('prop_counter', prop_counter);
          prefs.setBool('admin_status', admin_status);
          prefs.setString('isbank_verify', isbank_verify);

          return 'true';
        } else {
          String msg = j['status_msg'];
          return msg;
        }
      } else {
        return showSnackBar(
          title: 'Oops!',
          msg: 'could not connect to server',
          backgroundColor: Colors.red,
        );
      }
    } catch (ex) {
      return showSnackBar(
        title: 'Oops!',
        msg: ex.toString(),
        backgroundColor: Colors.red,
      );
    }
  }

  static Future uploadUserImage({
    required String userId,
    required File image,
  }) async {
    try {
      final uri = Uri.parse('$_mybaseUrl$_update_profile_image/$userId');
      var request = http.MultipartRequest('POST', uri);

      request.fields['user_id'] = userId.toString();

      var productImage =
          await http.MultipartFile.fromPath('property_image', image.path);
      request.files.add(productImage);

      var respond = await request.send();

      if (respond.statusCode == 200) {
        var result = await respond.stream.bytesToString();
        final j = json.decode(result) as Map<String, dynamic>;
        bool status = j['status'];

        if (status) {
          String image_name = j['image_name'];
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('image_name', image_name);
          return image_name;
        }
        return false;
      } else {
        //  showSnackBar(
        //   title: 'Oops!',
        //   msg: 'could not connect to server',
        //   backgroundColor: Colors.red,
        // );
        return false;
      }
    } catch (ex) {
      // return showSnackBar(
      //   title: 'Oops!',
      //   msg: ex.toString(),
      //   backgroundColor: Colors.red,
      // );
      return false;
    }
  }

  static Future<String> verifyBank({
    required String accountNum,
    required String bankCode,
    required String my_id,
  }) async {
    try {
      final uri = Uri.parse(
          '$_mybaseUrl$_verify_bank_account/$my_id/$bankCode/$accountNum');

      var response = await http.post(uri);
      if (response.statusCode == 200) {
        var body = response.body;

        final j = json.decode(body) as Map<String, dynamic>;
        String status = j['status'];
        return status;
      } else {
        return showSnackBar(
          title: 'Oops!',
          msg: 'could not connect to server',
          backgroundColor: Colors.red,
        );
      }
    } catch (ex) {
      return showSnackBar(
        title: 'Oops!',
        msg: ex.toString(),
        backgroundColor: Colors.red,
      );
    }
  }

  static Future checkIfBan(var userId) async {
    try {
      final result =
          await client.get(Uri.parse('$_mybaseUrl$_checkIfBan/$userId'));

      if (result.statusCode == 200) {
        final j = json.decode(result.body) as Map<String, dynamic>;
        bool status = j['status'];

        return status;
      } else {
        return showSnackBar(
          title: 'Oops!',
          msg: 'could not connect to server',
          backgroundColor: Colors.red,
        );
      }
    } catch (ex) {
      // return showSnackBar(
      //   title: 'Oops!',
      //   msg: ex.toString(),
      //   backgroundColor: Colors.red,
      // );
    }
  }

  static Future deleteAccount(var userId) async {
    try {
      final result =
          await client.get(Uri.parse('$_mybaseUrl$_deleteAccount/$userId'));

      if (result.statusCode == 200) {
        final j = json.decode(result.body) as Map<String, dynamic>;
        bool status = j['status'];

        return status;
      } else {
        // return showSnackBar(
        //   title: 'Oops!',
        //   msg: 'could not connect to server',
        //   backgroundColor: Colors.red,
        // );
        return false;
      }
    } catch (ex) {
      // return showSnackBar(
      //   title: 'Oops!',
      //   msg: ex.toString(),
      //   backgroundColor: Colors.red,
      // );
      return false;
    }
  }

  static Future<int> isAppHasNewUpdate() async {
    final response = await http.get(Uri.parse('$_mybaseUrl$_has_new_update/'));

    Map<String, dynamic> j = json.decode(response.body);
    int counter = j['counter'];
    return counter;
  }

  static Future<String> iosStoreLink() async {
    final response = await http.get(Uri.parse('$_mybaseUrl$_ios_store_link/'));

    Map<String, dynamic> j = json.decode(response.body);
    String counter = j['link'];
    return counter;
  }

  static Future<String> androidStoreLink() async {
    final response =
        await http.get(Uri.parse('$_mybaseUrl$_android_store_link/'));

    Map<String, dynamic> j = json.decode(response.body);
    String counter = j['link'];
    return counter;
  }

  static Future<String> updateTransactionPin(
      {required String pin, required String userId}) async {
    try {
      final uri = Uri.parse('$_mybaseUrl$_update_transaction_pin');

      var response = await http.post(uri, body: {
        'pin': pin.toString(),
        'user_id': userId.toString(),
      });
      if (response.statusCode == 200) {
        var body = response.body;

        final j = json.decode(body) as Map<String, dynamic>;
        String status = j['status'];
        if (status == 'success') {
          return 'true';
        } else {
          String msg = j['status_msg'];
          return msg;
        }
      } else {
        return showSnackBar(
          title: 'Oops!',
          msg: 'could not connect to server',
          backgroundColor: Colors.red,
        );
      }
    } catch (ex) {
      return showSnackBar(
        title: 'Oops!',
        msg: ex.toString(),
        backgroundColor: Colors.red,
      );
    }
  }

  static Future<String> updateUserEmail(
      {required String userId, required String newEmail}) async {
    try {
      final uri = Uri.parse('$_mybaseUrl$_update_email');

      var response = await http.post(uri, body: {
        'email': newEmail.toString(),
        'user_id': userId.toString(),
      });
      if (response.statusCode == 200) {
        var body = response.body;

        final j = json.decode(body) as Map<String, dynamic>;
        String status = j['status'];

        if (status == 'success') {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String email = j['email'];
          prefs.setString('email', email);
          return 'true';
        } else {
          String msg = j['status_msg'];
          return msg;
        }
      } else {
        return showSnackBar(
          title: 'Oops!',
          msg: 'could not connect to server',
          backgroundColor: Colors.red,
        );
      }
    } catch (ex) {
      return showSnackBar(
        title: 'Oops!',
        msg: ex.toString(),
        backgroundColor: Colors.red,
      );
    }
  }

  static Future<String> updateUserPassword({
    required String userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final uri = Uri.parse('$_mybaseUrl$_update_password');

      var response = await http.post(uri, body: {
        'current_password': currentPassword.toString(),
        'new_password': newPassword.toString(),
        'user_id': userId.toString(),
      });
      if (response.statusCode == 200) {
        var body = response.body;

        final j = json.decode(body) as Map<String, dynamic>;
        String status = j['status'];
        if (status == 'success') {
          return 'true';
        } else {
          String msg = j['status_msg'];
          return msg;
        }
      } else {
        return showSnackBar(
          title: 'Oops!',
          msg: 'could not connect to server',
          backgroundColor: Colors.red,
        );
      }
    } catch (ex) {
      return showSnackBar(
        title: 'Oops!',
        msg: ex.toString(),
        backgroundColor: Colors.red,
      );
    }
  }

  static Future fetchBankListProvider() async {
    try {
      Map<String, String> header = {};
      header["Authorization"] = 'Bearer $privateKey';
      header["Content-Type"] = 'application/json';
      final uri = Uri.parse('https://api.flutterwave.com/v3/banks/NG');

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

          final data = disData
              .map<bank.Datum>((json) => bank.Datum.fromJson(json))
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

  static Future<String?> updateUserBank({
    required String accountName,
    required String accountNum,
    required String bankName,
    required String bankCode,
    required String my_id,
  }) async {
    try {
      final uri = Uri.parse('$_mybaseUrl$_update_bank_detail');

      var response = await http.post(uri, body: {
        'account_name': accountName.toString(),
        'account_number': accountNum.toString(),
        'bank_code': bankCode.toString(),
        'bank_name': bankName.toString(),
        'user_id': my_id.toString(),
      });
      if (response.statusCode == 200) {
        var body = response.body;

        final j = json.decode(body) as Map<String, dynamic>;
        String status = j['status'];

        if (status == 'success') {
          SharedPreferences prefs = await SharedPreferences.getInstance();

          prefs.setString('account_name', accountName);
          prefs.setString('account_number', accountNum);
          prefs.setString('bank_name', bankName);
          prefs.setString('bank_code', bankCode);

          return 'true';
        } else {
          String msg = j['status_msg'];
          return msg;
        }
      } else {
        return showSnackBar(
          title: 'Oops!',
          msg: 'could not connect to server',
          backgroundColor: Colors.red,
        );
      }
    } catch (ex) {
      return showSnackBar(
        title: 'Oops!',
        msg: ex.toString(),
        backgroundColor: Colors.red,
      );
    }
  }
}
