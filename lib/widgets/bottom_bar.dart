import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:usefast/constant.dart';
import 'package:usefast/screens/home_screen.dart';
import 'package:usefast/screens/profile_page.dart';
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
    const ProfilePage(),
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
              color:
                  (_selectedIndex == 0) ? Colors.white : Colors.grey.shade700,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  _selectedIndex = 0;
                });
              },
              icon: const Icon(Icons.home_filled),
            ),
            IconButton(
              color:
                  (_selectedIndex == 1) ? Colors.white : Colors.grey.shade700,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  _selectedIndex = 1;
                });
              },
              icon: const Icon(Icons.bar_chart),
            ),
            IconButton(
              color:
                  (_selectedIndex == 2) ? Colors.white : Colors.grey.shade700,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  _selectedIndex = 2;
                });
              },
              icon: const Icon(Icons.person),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
