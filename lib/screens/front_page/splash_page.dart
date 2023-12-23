import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:usefast/constant.dart';

import '../../controller/splash_controller.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final splashController = SplashController().getXID;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    // splashController.startAnimation(context: context);
    splashController.startAnimation();

    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Stack(
        children: [
          Obx(
            () => AnimatedPositioned(
              duration: const Duration(milliseconds: 1600),
              top: splashController.animate.value ? 110 : 400,
              right: splashController.animate.value ? 0 : -50,
              left: splashController.animate.value ? 0 : 0,
              child: Column(
                children: [
                  Stack(
                    children: [
                      Image(
                        fit: BoxFit.contain,
                        image: const AssetImage('assets/images/fast_pay.png'),
                        height: height * 0.6,
                      ),
                      // const Positioned(
                      //   top: 310,
                      //   left: 170,
                      //   child: Text(
                      //     'Trade with ease, get paid fast',
                      //     textAlign: TextAlign.center,
                      //     style: TextStyle(
                      //       fontSize: 13.5,
                      //       color: Colors.white,
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Obx(
          //   () => AnimatedPositioned(
          //     duration: const Duration(milliseconds: 1500),
          //     top: splashController.animate.value ? 0 : 30,
          //     left: splashController.animate.value ? -130 : 0,
          //     child: Image.asset(
          //       'assets/images/rock.png',
          //       color: Colors.white.withOpacity(0.8),
          //       // colorBlendMode: BlendMode.color,
          //       height: 250,
          //     ),
          //   ),
          // ),
          // Obx(
          //   () => AnimatedPositioned(
          //     duration: const Duration(milliseconds: 1500),
          //     top: splashController.animate.value ? 80 : -90,
          //     left: splashController.animate.value ? 30 : -50,
          //     child: Image.asset(
          //       'assets/images/key.png',
          //       // color: Colors.blue.withOpacity(1),
          //       // colorBlendMode: BlendMode.color,
          //       height: 250,
          //       width: 150,
          //     ),
          //   ),
          // ),
          // Obx(
          //   () => AnimatedPositioned(
          //     duration: const Duration(milliseconds: 1500),
          //     top: splashController.animate.value ? 80 : 40,
          //     right: splashController.animate.value ? 0 : -10,
          //     child: Transform.rotate(
          //       angle: 0.5,
          //       child: Image.asset(
          //         'assets/images/home_o.png',
          //         color: Colors.white.withOpacity(1),
          //         // colorBlendMode: BlendMode.color,
          //         height: 250,
          //         width: 200,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
