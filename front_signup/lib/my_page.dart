import 'package:flutter/material.dart';
import 'package:front_singup/board_page.dart';
import 'package:front_singup/home_page.dart';
import 'package:front_singup/pibu_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  int _selectedIndex = 4;
  String nickname = '닉네임';
  String skinType = '피부 타입';

  final List<Widget> _pages = [
    Cosmetic(),
    Board(),
    Home(),
    MyPage(),
  ];

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nickname = prefs.getString('nickname') ?? '닉네임';
      skinType = prefs.getString('skinType') ?? '피부 타입';
    });
  }

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
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 140,
        backgroundColor: const Color.fromARGB(255, 244, 244, 244),
        centerTitle: true,
        title: Image.asset('assets/PIBUSTORY_biglogo.png', height: 95),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey[300],
                  child: Icon(Icons.person, size: 40, color: Colors.white),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '$nickname 님',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(skinType),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 32),
            ListTile(
              leading: Icon(Icons.person, color: Colors.purple),
              title: Text('프로필 편집'),
              onTap: () {
                // 프로필 편집 페이지로 이동
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.edit, color: Colors.purple),
              title: Text('내가 쓴 글'),
              onTap: () {
                // 내가 쓴 글 페이지로 이동
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.comment, color: Colors.purple),
              title: Text('내가 쓴 댓글'),
              onTap: () {
                // 내가 쓴 댓글 페이지로 이동
              },
            ),
          ],
        ),
      ),
    );
  }
}
