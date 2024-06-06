import 'package:flutter/material.dart';
import 'package:front_singup/pibu_page.dart';
import 'package:front_singup/home_page.dart';
import 'package:front_singup/my_page.dart';


void main() {
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 199, 187, 222),
        hintColor: const Color.fromARGB(255, 199, 187, 222),
      ),
      home: Board(),
    ),
  );
}

class Board extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Board> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
      Cosmetic(),
      Board(),
      Home(),
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
    if (index == _selectedIndex) return;

    setState(() {
      _selectedIndex = index;
    });

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => _pages[_selectedIndex]),
    );
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 199, 187, 222),
          centerTitle: true,
          title: Image.asset('assets/PIBUSTORY_logo.png', height: 45),
          bottom: TabBar(
            indicatorColor: const Color.fromARGB(255, 162, 132, 218),
            unselectedLabelColor: Colors.black,
            tabs: [
              const Tab(text: '최근 이야기'),
              const Tab(text: '피부 고민'),
              const Tab(text: '화장품 추천'),
            ],
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // Implement search logic here if needed
              },
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'about') {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('About'),
                      content: const Text('This is a QnA app'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem<String>(
                  value: 'about',
                  child: Row(
                    children: [
                      Icon(Icons.info),
                      Text('About'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        body: SafeArea(
          child: TabBarView(
            children: [
              Center(child: Text('최근 이야기')),
              Center(child: Text('피부 고민')),
              Center(child: Text('화장품 추천')),
            ],
          ),
        ),
      ),
    );
  }
}