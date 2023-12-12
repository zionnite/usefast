import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usefast/model/account_model.dart';
import 'package:usefast/model/user_model.dart';
import 'package:usefast/screens/front_page/login_page.dart';
import 'package:usefast/services/api_services.dart';
import 'package:usefast/util/common.dart';
import 'package:uuid/uuid.dart';

class AccountController extends GetxController {
  AccountController get getXID => Get.find<AccountController>();

  // final lockSession = LockSession().getXID;
  // final lockSession = Get.put(LockSession);

  var accountStatusCounter = <AccountModel>[].obs;
  var isDashboardProcessing = 'null'.obs;
  final _uuid = const Uuid();

  var disUsersList = <AccountModel>[].obs;
  var usersList = <UsersModel>[].obs;
  var isUserFetching = false.obs;

  @override
  void onInit() async {
    super.onInit();
  }

  getWallet(userId, adminStatus) async {
    var seeker = await ApiServices.getWalletDetail(userId, adminStatus);
    if (seeker != null) {
      isDashboardProcessing.value = 'yes';
      accountStatusCounter.value = seeker.cast<AccountModel>();
    } else {
      isDashboardProcessing.value = 'no';
    }
  }

  depositUserFund({
    required String userId,
    required String amount,
  }) async {
    var seeker = await ApiServices.depositUserFund(
      userId: userId,
      amount: amount,
    );
    if (seeker != null) {
      accountStatusCounter.value = seeker.cast<AccountModel>();
      return 'Transaction successful';
    } else {
      return seeker;
    }
  }

  verifyTransaction({
    required String userId,
    required String txRef,
    required String transactionId,
    required String amount,
  }) async {
    var seeker = await ApiServices.verifyTransaction(
      userId: userId,
      txRef: txRef,
      transactionId: transactionId,
    );
    if (seeker == 'success') {
      var data = depositUserFund(userId: userId, amount: amount);
      return data;
    } else {
      return seeker;
    }
  }

  verifyTransactionPin({
    required String userId,
    required String transactionPin,
    required String amount,
    required String network,
    required String phoneNumber,
    required String billerCode,
    required String billerName,
    required String itemCode,
    required bool isAirtime,
  }) async {
    var ref = _uuid.v1();
    //connect to server and verify pin
    var seeker = await ApiServices.verifyPin(
      userId: userId,
      amount: amount,
      pin: transactionPin,
    );
    if (seeker == 'ok') {
      //validate inputed detils
      var validate = await ApiServices.validateInputDetails(
        phoneNumber: phoneNumber,
        billerCode: billerCode,
        billerName: billerName,
        itemCode: itemCode,
      );

      if (validate == 'success') {
        //deduct amount from wallet balance
        var debit = await ApiServices.debitWallet(
          userId: userId,
          amount: amount,
          ref: ref,
          billType: billerName,
          customer: phoneNumber,
        );

        if (debit == 'done') {
          //perform Bill Purchase
          var action = await ApiServices.createBillPurchase(
            phoneNumber: phoneNumber,
            billerCode: billerCode,
            billerName: billerName,
            itemCode: itemCode,
            country: 'NG',
            amount: amount,
            isAirtime: isAirtime,
            ref: ref,
          );

          if (action == 'success') {
            //add to transaction history
            var transHistory = await ApiServices.addToTransactionHistory(
              userId: userId,
              amount: amount,
              ref: ref,
              billType: billerName,
              customer: phoneNumber,
            );
            if (transHistory != null) {
              accountStatusCounter.value = transHistory.cast<AccountModel>();
              return 'successful';
            }

            return 'successful'; //
          } else {
            //refund user money
            //could not complete transaction
            var refundTrans = await ApiServices.refundWallet(
              userId: userId,
              amount: amount,
              ref: ref,
              billType: billerName,
              customer: phoneNumber,
            );
            if (refundTrans != null) {
              accountStatusCounter.value = refundTrans.cast<AccountModel>();
              return 'not_successful';
            }

            return action;
          }
        }
        return debit;
      }
      return validate;
    }
    return seeker;
  }

  purchaseBill({
    required String userId,
    required String amount,
    required String network,
    required String phoneNumber,
    required String billerCode,
    required String billerName,
    required String itemCode,
    required bool isAirtime,
  }) async {
    var ref = _uuid.v1();
    //validate inputed detils
    var validate = await ApiServices.validateInputDetails(
      phoneNumber: phoneNumber,
      billerCode: billerCode,
      billerName: billerName,
      itemCode: itemCode,
    );

    if (validate == 'success') {
      //deduct amount from wallet balance
      var debit = await ApiServices.debitWallet(
        userId: userId,
        amount: amount,
        ref: ref,
        billType: billerName,
        customer: phoneNumber,
      );

      if (debit == 'done') {
        //perform Bill Purchase
        var action = await ApiServices.createBillPurchase(
          phoneNumber: phoneNumber,
          billerCode: billerCode,
          billerName: billerName,
          itemCode: itemCode,
          country: 'NG',
          amount: amount,
          isAirtime: isAirtime,
          ref: ref,
        );

        if (action == 'success') {
          //add to transaction history
          var transHistory = await ApiServices.addToTransactionHistory(
            userId: userId,
            amount: amount,
            ref: ref,
            billType: billerName,
            customer: phoneNumber,
          );
          if (transHistory != null) {
            accountStatusCounter.value = transHistory.cast<AccountModel>();
            return 'successful';
          }

          return 'successful'; //
        } else {
          //refund user money
          //could not complete transaction
          var refundTrans = await ApiServices.refundWallet(
            userId: userId,
            amount: amount,
            ref: ref,
            billType: billerName,
            customer: phoneNumber,
          );
          if (refundTrans != null) {
            accountStatusCounter.value = refundTrans.cast<AccountModel>();
            return 'not_successful';
          }

          return action;
        }
      }
      return debit;
    }
    return validate;
  }

  //

  Future<bool> signUp({
    required String userName,
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    String? msg;
    String status = await ApiServices.signUp(
      userName: userName,
      fullName: fullName,
      email: email,
      phone: phone,
      password: password,
      // userType: usersType,
    );
    if (status == 'true') {
      msg = 'Account Creation was successful...';
      showSnackBar(
          title: 'Account Creation', msg: msg, backgroundColor: Colors.blue);
      return true;
    } else {
      msg = '';
      showSnackBar(
          title: 'Account Creation', msg: status, backgroundColor: Colors.blue);
      return false;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    String? msg;
    String status = await ApiServices.login(
      email: email,
      password: password,
    );
    if (status == 'true') {
      msg = 'Login Successful...';
      showSnackBar(title: 'Success', msg: msg, backgroundColor: Colors.blue);
      return true;
    } else {
      msg = '';
      showSnackBar(title: 'Oops', msg: status, backgroundColor: Colors.blue);
      return false;
    }
  }

  Future<bool> resetPassword({
    required String email,
  }) async {
    String? msg;
    String status = await ApiServices.resetPassword(
      email: email,
    );
    if (status == 'true') {
      msg =
          'An Email has been Sent to the provided email for further instruction!...';
      showSnackBar(
          title: 'Congratulation', msg: msg, backgroundColor: Colors.blue);
      return true;
    } else {
      msg = '';
      showSnackBar(title: 'Oops', msg: status, backgroundColor: Colors.blue);
      return false;
    }
  }

  getDisUser(var userId) async {
    usersList.clear();
    isUserFetching(true);
    var seeker = await ApiServices.getDisUser(userId);
    if (seeker != null) {
      isUserFetching(false);
      usersList.value = seeker.cast<UsersModel>();
    } else {
      isUserFetching(false);
    }
  }

  Future updateUserBio({
    required String fullName,
    //required String email,
    required String phone,
    required String age,
    // required String address,
    required String sex,
    required String my_id,
  }) async {
    String? msg;
    String? status = await ApiServices.updateUserBio(
      fullName: fullName,
      phone: phone,
      age: age,
      sex: sex,
      my_id: my_id,
    );
    if (status == 'true') {
      //msg = 'Update Successful...';
      //showSnackBar(title: 'Success', msg: msg, backgroundColor: Colors.blue);
      return true;
    } else {
      //msg = 'Could not update Profile';
      //showSnackBar(title: 'Oops', msg: msg, backgroundColor: Colors.blue);
      return status;
    }
  }

  Future updateUserEmail({
    required String userId,
    required String newEmail,
  }) async {
    String? msg;
    String status = await ApiServices.updateUserEmail(
      userId: userId,
      newEmail: newEmail,
    );
    if (status == 'true') {
      return true;
    } else {
      return status;
    }
  }

  Future updateUserPassword({
    required String userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    String? msg;
    String status = await ApiServices.updateUserPassword(
      userId: userId,
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
    if (status == 'true') {
      return true;
    } else {
      return status;
    }
  }

  Future<bool> updateUserBank1({
    required String accountName,
    required String accountNum,
    required String bankName,
    required String bankCode,
    required String my_id,
  }) async {
    String? msg;
    String? status = await ApiServices.updateUserBank(
      accountName: accountName,
      accountNum: accountNum,
      bankName: bankName,
      bankCode: bankCode,
      my_id: my_id,
    );
    if (status == 'true') {
      msg = 'Update Successful...';
      showSnackBar(title: 'Success', msg: msg, backgroundColor: Colors.blue);
      return true;
    } else {
      msg = 'Could not update Profile';
      showSnackBar(title: 'Oops', msg: msg, backgroundColor: Colors.blue);
      return false;
    }
  }

  uploadImage(var userId, File imageName) async {
    var status =
        await ApiServices.uploadUserImage(userId: userId, image: imageName);

    String? msg;

    if (status != true) {
      msg = 'Image Uploaded';
      //showSnackBar(title: 'Product', msg: msg, backgroundColor: Colors.blue);

      return status;
    } else {
      return false;
    }
  }

  Future<bool> verifyBank({
    required String accountNum,
    required String bankCode,
    required String my_id,
  }) async {
    String? msg;
    String status = await ApiServices.verifyBank(
      accountNum: accountNum,
      bankCode: bankCode,
      my_id: my_id,
    );
    if (status == 'true') {
      msg = 'Verify Successful...';

      showSnackBar(title: 'Success', msg: msg, backgroundColor: Colors.blue);
      return true;
    } else if (status == 'fail') {
      msg = 'Verify Successful, but could not update your profile';
      showSnackBar(title: 'Oops', msg: msg, backgroundColor: Colors.blue);
      return false;
    } else {
      msg =
          'Could not verify bank account detail, pls try updating your bank details and come try again';
      showSnackBar(title: 'Oops', msg: msg, backgroundColor: Colors.blue);
      return false;
    }
  }

  void logoutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("isUserLogin");
    prefs.remove("user_id");
    prefs.remove("user_name");
    prefs.remove("full_name");
    prefs.remove("email");
    prefs.remove("image_name");
    prefs.remove("user_status");
    prefs.remove("phone");
    prefs.remove("age");
    prefs.remove("sex");
    prefs.remove("address");
    prefs.remove("date_created");
    prefs.remove("account_name");
    prefs.remove("account_number");
    prefs.remove("bank_name");
    prefs.remove("bank_code");
    prefs.remove("current_balance");
    prefs.remove("prop_counter");
    prefs.remove("admin_status");
    prefs.remove("isbank_verify");
    prefs.remove("login_status");
    prefs.remove("isGuestLogin");
    prefs.remove("fingerprintAuth");

    Get.offAll(() => const LoginPage());
  }

  checkForUpdate(var userId) async {
    bool seeker = await ApiServices.checkIfBan(userId);
    if (seeker) {
      String msg =
          'Your account has violated what we stand for as a result, your account its now Ban. If you think this is a glitch, try writing us';
      showSnackBar(title: 'Oops', msg: msg, backgroundColor: Colors.red);
      logoutUser();
    }
  }

  deleteAccount(var userId) async {
    bool seeker = await ApiServices.deleteAccount(userId);
    if (seeker) {
      String msg = 'We are sad to see you go';
      showSnackBar(
          title: 'Account Deleted', msg: msg, backgroundColor: Colors.red);
      //logoutUser();
      return true;
    } else {
      String msg = 'Could not perform operation, please try again later!';
      showSnackBar(title: 'Oops!', msg: msg, backgroundColor: Colors.red);
      return false;
    }
  }

  Future<bool> updateTransactionPin({
    required String pin,
    required String userId,
  }) async {
    String? msg;
    String status = await ApiServices.updateTransactionPin(
      pin: pin,
      userId: userId,
    );
    if (status == 'true') {
      msg = 'Your Pin for Transaction has been updated...';
      showSnackBar(
          title: 'Congratulation', msg: msg, backgroundColor: Colors.blue);
      return true;
    } else {
      msg = '';
      showSnackBar(title: 'Oops', msg: status, backgroundColor: Colors.blue);
      return false;
    }
  }

  Future updateUserBank({
    required String accountName,
    required String accountNum,
    required String bankName,
    required String bankCode,
    required String my_id,
  }) async {
    String? msg;
    String? status = await ApiServices.updateUserBank(
      accountNum: accountNum,
      accountName: accountName,
      bankName: bankName,
      bankCode: bankCode,
      my_id: my_id,
    );
    if (status == 'true') {
      return true;
    } else {
      return status;
    }
  }

  verifyJustTransactionPin({
    required String userId,
    required String transactionPin,
    required String amount,
  }) async {
    var ref = _uuid.v1();
    //connect to server and verify pin
    var seeker = await ApiServices.verifyPin(
      userId: userId,
      amount: amount,
      pin: transactionPin,
    );

    return seeker;
  }

  verifyBalanceWithdraw({
    required String userId,
    required String amount,
  }) async {
    var seeker =
        await ApiServices.verifyWithdraw(userId: userId, amount: amount);
    if (seeker != null) {
      accountStatusCounter.value = seeker.cast<AccountModel>();
      return 'Fund Requested sent';
    } else {
      return 'unknown error encountered';
    }
  }

  verifyWithdraw({
    required String userId,
    required String transactionPin,
    required String amount,
  }) async {
    var ref = _uuid.v1();
    //connect to server and verify pin
    var seeker = await ApiServices.verifyPin(
      userId: userId,
      amount: amount,
      pin: transactionPin,
    );

    if (seeker == 'ok') {
      var action = await verifyBalanceWithdraw(userId: userId, amount: amount);
      return action;
    } else {
      return seeker;
    }
  }
}
