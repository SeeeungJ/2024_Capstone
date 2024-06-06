import 'package:flutter/material.dart';
import 'package:front_singup/board_page.dart';
import 'package:front_singup/home_page.dart';
import 'package:front_singup/mycosmetic_page.dart';
import 'package:front_singup/my_page.dart';
import 'package:front_singup/pibu_page.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 2; // 홈 페이지가 기본으로 선택되도록 설정

  final List<Widget> _pages = [
    Cosmetic(),
    Board(),
    Home(),
    MyCosmeticPage(),
    MyPage(),
  ];

  final List<Icon> selectedIcons = [
    const Icon(Icons.palette, color: Color.fromARGB(255, 199, 187, 222)),
    const Icon(Icons.message, color: Color.fromARGB(255, 199, 187, 222)),
    const Icon(Icons.home, color: Color.fromARGB(255, 199, 187, 222)),
    const Icon(Icons.brush, color: Color.fromARGB(255, 199, 187, 222)),
    const Icon(Icons.person, color: Color.fromARGB(255, 199, 187, 222)),
  ];

  final List<Icon> unselectedIcons = [
    const Icon(Icons.palette),
    const Icon(Icons.message),
    const Icon(Icons.home),
    const Icon(Icons.brush),
    const Icon(Icons.person),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: _selectedIndex == 0 ? selectedIcons[0] : unselectedIcons[0],
            label: '퍼스널 컬러',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 1 ? selectedIcons[1] : unselectedIcons[1],
            label: '게시판',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 2 ? selectedIcons[2] : unselectedIcons[2],
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 3 ? selectedIcons[3] : unselectedIcons[3],
            label: '화장품 관리',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 4 ? selectedIcons[4] : unselectedIcons[4],
            label: '마이 페이지',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color.fromARGB(255, 199, 187, 222),
      ),
    );
  }
}
