import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gym_excercise_correction/firebase_options.dart';
import 'package:gym_excercise_correction/model/BottomNavItem.dart';
import 'package:gym_excercise_correction/views/account.dart';
import 'package:gym_excercise_correction/views/history.dart';
import 'package:gym_excercise_correction/views/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gym Exercise Correction',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

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
        children: const [
          HomePage(),
          HistoryPage(),
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
