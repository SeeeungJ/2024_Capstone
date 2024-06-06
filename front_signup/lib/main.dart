import 'package:flutter/material.dart';
import 'package:front_singup/login_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginForm(), // 처음 화면을 LoginForm으로 설정
    );
  }
}
