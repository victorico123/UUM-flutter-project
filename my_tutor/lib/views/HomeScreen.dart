import 'package:flutter/material.dart';
import 'package:my_tutor/views/homepages/CoursePage.dart';
import 'package:my_tutor/views/homepages/FavouritePage.dart';
import 'package:my_tutor/views/homepages/ProfilePage.dart';
import 'package:my_tutor/views/homepages/SubscribePage.dart';
import 'package:my_tutor/views/homepages/TutorPage.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  final pages = [
    CoursePage(),
    TutorPage(),
    SubscribePage(),
    FavouritePage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.blue,
          showUnselectedLabels: false,
          iconSize: 30,
          currentIndex: currentIndex,
          onTap: (index) => setState(() => currentIndex = index),
          // ignore: prefer_const_literals_to_create_immutables
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.book_sharp),
              label: 'Subjects',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.people_sharp),
              label: 'Tutors',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.thumb_up_sharp),
              label: 'Subscribe',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.star_sharp),
              label: 'Favourite',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_sharp),
              label: 'Profile',
            ),
          ]),
    );
  }
}
