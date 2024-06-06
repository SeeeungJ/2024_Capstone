import 'package:flutter/material.dart';

class MyCosmeticPage extends StatefulWidget {
  @override
  _MyCosmeticPageState createState() => _MyCosmeticPageState();
}

class _MyCosmeticPageState extends State<MyCosmeticPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Image.asset('assets/PIBUSTORY_logo.png', height: 30),
            SizedBox(width: 8),
            Text('나의 화장품 목록', style: TextStyle(color: Colors.black)),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Color.fromARGB(255, 199, 187, 222),
          unselectedLabelColor: Colors.grey,
          labelColor: Color.fromARGB(255, 199, 187, 222),
          tabs: [
            Tab(text: '사용중'),
            Tab(text: '사용 대기'),
            Tab(text: '사용 완료'),
            Tab(text: '추가하기'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildUsingCosmeticsPage(),
          _buildWaitingCosmeticsPage(),
          _buildCompletedCosmeticsPage(),
          _buildAddCosmeticsPage(),
        ],
      ),
    );
  }

  Widget _buildUsingCosmeticsPage() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        _buildCosmeticItem('사진', '제품 이름, 유통기한'),
        _buildCosmeticItem('사진', '제품 이름, 유통기한'),
        _buildCosmeticItem('사진', '제품 이름, 유통기한'),
      ],
    );
  }

  Widget _buildWaitingCosmeticsPage() {
    return Center(
      child: Text('사용 대기 화장품 목록이 여기에 표시됩니다.'),
    );
  }

  Widget _buildCompletedCosmeticsPage() {
    return Center(
      child: Text('사용 완료 화장품 목록이 여기에 표시됩니다.'),
    );
  }

  Widget _buildAddCosmeticsPage() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            color: Colors.grey[300],
            width: double.infinity,
            height: 200,
            child: Center(child: Text('어떻게 찍는지 예시 사진')),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  // 사진 불러오기 기능 추가
                },
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 199, 187, 222),
                ),
                child: Text('사진 불러오기'),
              ),
              ElevatedButton(
                onPressed: () {
                  // 직접 촬영 기능 추가
                },
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 199, 187, 222),
                ),
                child: Text('직접 촬영'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCosmeticItem(String image, String details) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      color: Color.fromARGB(255, 199, 187, 222),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              color: Colors.grey,
              child: Center(child: Text(image)),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(details),
            ),
          ],
        ),
      ),
    );
  }
}
