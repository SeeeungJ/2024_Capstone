import 'package:flutter/material.dart';
import 'package:front_singup/board_page.dart'; // board_backup.dart 파일 import
import 'package:front_singup/pibu_page.dart'; // 퍼스널 컬러 페이지 파일 import
import 'package:front_singup/my_page.dart'; // 마이 페이지 파일 import
import 'package:front_singup/shared_preferences.dart'; // shared_preferences.dart 파일 import

void main() {
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 199, 187, 222),
        hintColor: const Color.fromARGB(255, 199, 187, 222),
      ),
      home: Home(),
    ),
  );
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 2;

  final List<Widget> _pages = [
    Cosmetic(),
    Board(),
    HomeContent(), // 홈 컨텐츠를 별도의 위젯으로 분리
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

    if (_selectedIndex != 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => _pages[_selectedIndex]),
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Home()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 140,
          backgroundColor: const Color.fromARGB(255, 244, 244, 244),
          centerTitle: true,
          title: Image.asset('assets/PIBUSTORY_biglogo.png', height: 95),
          bottom: TabBar(
            indicatorColor: const Color.fromARGB(255, 121, 86, 185),
            unselectedLabelColor: Colors.black,
            labelColor: Colors.white,
            tabs: [
              Container(
                color: const Color.fromARGB(255, 199, 187, 222),
                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 1.0),
                child: const Tab(text: '건성'),
              ),
              Container(
                color: const Color.fromARGB(255, 199, 187, 222),
                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 1.0),
                child: const Tab(text: '중성'),
              ),
              Container(
                color: const Color.fromARGB(255, 199, 187, 222),
                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 1.0),
                child: const Tab(text: '지성'),
              ),
            ],
          ),
        ),
        body: const SafeArea(
          child: TabBarView(
            children: [
              Center(child: Text('건성')),
              Center(child: Text('중성')),
              Center(child: Text('지성')),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getUserInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final userInfo = snapshot.data as Map<String, String>;
          return Center(
            child: Text('환영합니다, ${userInfo['nickname']}님!'),
          );
        }
      },
    );
  }

  Future<Map<String, String>> _getUserInfo() async {
    SharedPrefs prefs = SharedPrefs();
    String? userid = await prefs.getUserId();
    String? nickname = await prefs.getNickname();
    return {'userid': userid!, 'nickname': nickname!};
  }
}
