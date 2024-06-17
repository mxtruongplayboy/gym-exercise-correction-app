import 'package:flutter/material.dart';
import 'package:gym_excercise_correction/model/BottomNavItem.dart';
import 'package:gym_excercise_correction/views/check.dart';

import '../widgets/exercise_guide.dart';

class ExerciseDetail extends StatefulWidget {
  const ExerciseDetail(
      {super.key, required this.title, required this.imageUrl});

  final String title;
  final String imageUrl;

  @override
  State<ExerciseDetail> createState() => _ExerciseDetailState();
}

class _ExerciseDetailState extends State<ExerciseDetail> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<BottomNavItem> bottomNavItems = [
    BottomNavItem(
        icon: const Icon(
          Icons.newspaper_rounded,
        ),
        label: 'Guide'),
    BottomNavItem(
        icon: const Icon(
          Icons.check_circle_sharp,
        ),
        label: 'Check'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 140.0,
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          elevation: 0,
          flexibleSpace: Container(
            width: MediaQuery.of(context).size.width,
            height: 140.0,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              image: DecorationImage(
                image: AssetImage(widget.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            ExerciseGuide(
              title: widget.title,
            ),
            CheckPage(title: widget.title,),
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
                icon:
                    bottomNavItems.elementAt(i).icon ?? const Icon(Icons.error),
                label: bottomNavItems.elementAt(i).label,
              )
          ],
        ),
      ),
    );
  }
}
