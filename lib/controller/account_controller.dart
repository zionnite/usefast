import 'package:get/get.dart';
import 'package:usefast/model/account_model.dart';
import 'package:usefast/services/api_services.dart';

class AccountController extends GetxController {
  AccountController get getXID => Get.find<AccountController>();

  var accountStatusCounter = <AccountModel>[].obs;
  var isDashboardProcessing = 'null'.obs;

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
    required String transactionPin,
    required String amount,
    required String network,
    required String phoneNumber,
    required String billerCode,
    required String billerName,
    required String itemCode,
    required bool isAirtime,
  }) {
    //connect to server and verify pin
    //check if user balance grater than the amount to purchase, if true deduct from wallet
    //pass to purchase bill
    //validate imputed details
    //create a bill payment

    print('came here $transactionPin');
  }

  purchaseBill({
    required String amount,
    required String network,
    required String phoneNumber,
    required String billerCode,
    required String billerName,
    required String itemCode,
    required bool isAirtime,
  }) {
    //ver
    print('came here purchase airtime');
  }
}
