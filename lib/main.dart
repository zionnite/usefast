import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'constant.dart';
import 'controller/account_controller.dart';
import 'controller/flutterwave_bill_controller.dart';
import 'controller/trade_controller.dart';
import 'controller/transaction_controller.dart';
import 'widgets/bottom_bar.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(TradeController());
  Get.put(TransactionController());
  Get.put(AccountController());
  Get.put(FlutterWaveBillController());

  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
    ),
  );

  runApp(
    const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypto Wallet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'SFUIDisplay',
        scaffoldBackgroundColor: kPrimaryColor,
      ),
      home: const BottomBar(),
    );
  }
}
