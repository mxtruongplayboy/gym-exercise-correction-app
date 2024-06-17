import 'package:flutter/material.dart';
import 'package:gym_excercise_correction/model/BottomNavItem.dart';
import 'package:gym_excercise_correction/notification.dart';
import 'package:gym_excercise_correction/views/account.dart';
import 'package:gym_excercise_correction/views/history.dart';
import 'package:gym_excercise_correction/views/home.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAPI().subscribeToTopics();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<BottomNavItem> bottomNavItems = [
    BottomNavItem(
        icon: const Icon(
          Icons.home,
        ),
        label: 'Home'),
    BottomNavItem(
        icon: const Icon(
          Icons.history_rounded,
        ),
        label: 'History'),
    BottomNavItem(
        icon: const Icon(
          Icons.account_circle_rounded,
        ),
        label: 'Account'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomePage(),
          const HistoryPage(),
          AccountPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.blue,
        unselectedFontSize: 10,
        selectedFontSize: 10,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          for (var i = 0; i < bottomNavItems.length; i++)
            BottomNavigationBarItem(
              icon: bottomNavItems.elementAt(i).icon ?? const Icon(Icons.error),
              label: bottomNavItems.elementAt(i).label,
            )
        ],
      ),
    );
  }
}
