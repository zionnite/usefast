import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:usefast/constant.dart';
import 'package:usefast/screens/home_screen.dart';
import 'package:usefast/screens/transaction_screen.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  final List _page = [
    const HomeScreen(),
    const TransactionScreen(),
  ];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: _page[_selectedIndex],
      bottomNavigationBar: Container(
        height: 100,
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  _selectedIndex = 0;
                });
              },
              icon: SvgPicture.asset(
                'assets/icons/home.svg',
              ),
            ),
            SizedBox(
              height: 50,
              width: 133,
              child: TextButton(
                onPressed: () {
                  print('hello');
                },
                style: TextButton.styleFrom(
                  foregroundColor: kTextColor,
                  backgroundColor: kSecondaryColor,
                  textStyle: kSFUI16,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(35),
                    ),
                  ),
                ),
                child: const Text('Chat'),
              ),
            ),
            IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  _selectedIndex = 1;
                });
              },
              icon: SvgPicture.asset(
                'assets/icons/wallet.svg',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
