import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'constant.dart';
import 'controller/account_controller.dart';
import 'controller/flutterwave_bill_controller.dart';
import 'controller/onboarding_controller.dart';
import 'controller/splash_controller.dart';
import 'controller/trade_controller.dart';
import 'controller/transaction_controller.dart';
import 'screens/front_page/splash_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(TradeController());
  Get.put(TransactionController());
  Get.put(AccountController());
  Get.put(FlutterWaveBillController());
  Get.put(SplashController());
  Get.put(OnboardingCongroller());

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
    RestartWidget(
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            iconTheme: IconThemeData(color: Colors.white),
            titleTextStyle: TextStyle(color: Colors.white),
          ),
        ),
        home: const MyApp(),
      ),
    ),
  );
}

class RestartWidget extends StatefulWidget {
  RestartWidget({required this.child});

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()!.restartApp();
  }

  @override
  State<RestartWidget> createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
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
      // home: const BottomBar(),
      // home: const CreatePinPage(),
      home: SplashPage(),
    );
  }
}
