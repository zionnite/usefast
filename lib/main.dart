import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:get/get.dart';
import 'package:usefast/screens/front_page/lock_page.dart';

import 'constant.dart';
import 'controller/account_controller.dart';
import 'controller/flutterwave_bill_controller.dart';
import 'controller/lock_session.dart';
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
  Get.put(LockSession());

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

  bool enabledLaunch = false;
  Duration backgroundLockLatency = const Duration(seconds: 30);

  final _navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> _navKey = GlobalKey<NavigatorState>();

  runApp(
    AppLock(
      builder: (Object? arg) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            appBarTheme: const AppBarTheme(
              iconTheme: IconThemeData(color: Colors.white),
              titleTextStyle: TextStyle(color: Colors.white),
            ),
          ),
          home: MyApp(),

          // navigatorKey: Get.key,
          navigatorKey: _navKey,
        );
      },
      enabled: enabledLaunch,
      backgroundLockLatency: backgroundLockLatency,
      lockScreen: const LockPage(),
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
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypto Wallet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'SFUIDisplay',
        scaffoldBackgroundColor: kPrimaryColor,
      ),
      home: SplashPage(),
    );
  }
}
