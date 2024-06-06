import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class Cosmetic extends StatefulWidget {
  @override
  _CosmeticState createState() => _CosmeticState();
}

class _CosmeticState extends State<Cosmetic> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? analysisResult;
  double? analysisProbability;
  CameraController? _cameraController;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initializeCamera();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _cameraController?.dispose();
    super.dispose();
  }

  void _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _cameraController = CameraController(
      firstCamera,
      ResolutionPreset.high,
    );

    _initializeControllerFuture = _cameraController!.initialize();
    setState(() {});
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;

      final tempDir = await getTemporaryDirectory();
      final imagePath = join(tempDir.path, '${DateTime.now()}.png');
      await _cameraController!.takePicture(imagePath);

      final result = await _analyzePicture(File(imagePath));
      setState(() {
        analysisResult = result['predicted_category'];
        analysisProbability = result['probability'];
      });
    } catch (e) {
      print(e);
    }
  }

  Future<Map<String, dynamic>> _analyzePicture(File image) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://yourserver.com/analyze/'), // 서버 URL로 변경
    );
    request.files.add(await http.MultipartFile.fromPath('image', image.path));
    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final data = jsonDecode(responseData);
      return data;
    } else {
      return {'predicted_category': '분석 실패', 'probability': 0.0};
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 65,
          backgroundColor: const Color.fromARGB(255, 244, 244, 244),
          centerTitle: false,
          title: Image.asset('assets/PIBUSTORY_logo.png', height: 30),
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: const Color.fromARGB(255, 121, 86, 185),
            unselectedLabelColor: Colors.black,
            labelColor: Colors.white,
            tabs: [
              Container(
                color: const Color.fromARGB(255, 199, 187, 222),
                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 1.0),
                child: const Tab(text: '  피부 타입\n화장품 추천'),
              ),
              Container(
                color: const Color.fromARGB(255, 199, 187, 222),
                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 1.0),
                child: const Tab(text: '퍼스널 컬러\n 상세 보기'),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildSkinTypeTab(),
              Center(child: Text('퍼스널 컬러 상세 보기 화면')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkinTypeTab() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          color: Colors.grey[300],
          width: double.infinity,
          height: 200,
          child: analysisResult == null
              ? Center(child: Text('어떻게 찍는지 예시 사진'))
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('분석 결과: $analysisResult'),
                      Text('확률: ${(analysisProbability! * 100).toStringAsFixed(2)}%'),
                    ],
                  ),
                ),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () async {
            await _takePicture();
          },
          style: ElevatedButton.styleFrom(
            primary: Color.fromARGB(255, 199, 187, 222),
          ),
          child: Text('사진 촬영'),
        ),
      ],
    );
  }
}
