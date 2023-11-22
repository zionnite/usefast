import 'package:get/get.dart';
import 'package:usefast/model/account_model.dart';
import 'package:usefast/services/api_services.dart';
import 'package:uuid/uuid.dart';

class AccountController extends GetxController {
  AccountController get getXID => Get.find<AccountController>();

  var accountStatusCounter = <AccountModel>[].obs;
  var isDashboardProcessing = 'null'.obs;
  final _uuid = const Uuid();

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

  verifyAccountDeposit({
    required String userId,
    required String txRef,
    required String transactionId,
  }) async {
    var seeker = await ApiServices.verifyAccountDeposit(
      userId: userId,
      txRef: txRef,
      transactionId: transactionId,
    );
    if (seeker != null) {
      print('was successfull');
      accountStatusCounter.value = seeker.cast<AccountModel>();
    } else {
      print('wrong');
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
}
