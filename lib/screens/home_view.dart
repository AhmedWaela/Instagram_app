import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/screens.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens.elementAt(selectedIndex),
      bottomNavigationBar: GNav(
          textStyle: const TextStyle(color: Colors.white),
          tabMargin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          onTabChange: (value) {
            setState(() {
              selectedIndex = value;
            });
          },
          selectedIndex: selectedIndex,
          hoverColor: const Color.fromRGBO(121, 100, 41, 220),
          gap: 8,
          iconSize: 24,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          duration: const Duration(milliseconds: 400),
          tabBackgroundColor: const Color(0xff1b0064),
          color: const Color(0xffc5d8f3),
          tabs: const [
            GButton(
              iconActiveColor: Colors.white,
              icon: Icons.home,
              text: 'Home',
            ),
            GButton(
              iconActiveColor: Colors.white,
              icon: Icons.lightbulb,
              text: 'Tracks',
            ),
            GButton(
              iconActiveColor: Colors.white,
              icon: CupertinoIcons.person_alt_circle,
              text: 'Profile',
            ),
          ]),
    );
  }
}
