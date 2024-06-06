import 'package:flutter/material.dart';
import 'package:front_singup/main_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:front_singup/signup_page.dart';

class LoginFormData {
  String? userid;
  String? password;

  LoginFormData({this.userid, this.password});

  Map<String, dynamic> toJson() => {
        "userid": userid,
        "password": password,
      };
}

class LoginForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final formKey = GlobalKey<FormState>();
  LoginFormData formData = LoginFormData();

  @override
  void initState() {
    super.initState();
  }

  void _showDialog(String title, String message) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text('확인'),
            onPressed: () {
              Navigator.of(context).pop();
              if (title == '로그인 성공') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MainScreen()),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void loginToServer() async {
    String jsonResult = jsonEncode(formData.toJson());
    final result = await http.post(
      Uri.http('127.0.0.1:8000', '/user/login/'), // 실제 API URL로 변경
      headers: {'content-type': 'application/json'},
      body: jsonResult,
    );
    if (result.statusCode == 200) {
      _showDialog('로그인 성공', '환영합니다!');
    } else if (result.statusCode == 401) {
      _showDialog('로그인 실패', '아이디 또는 비밀번호가 잘못되었습니다.');
    } else {
      _showDialog('로그인 실패', '알 수 없는 오류가 발생하였습니다.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '반갑습니다 :)',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Text(
                  "피부 타입 분석 및 뷰티 전용 어플인 \n피부 스토리입니다.",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 30),
              TextFormField(
                key: ValueKey(1),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.person),
                  labelText: '아이디',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '아이디를 입력해주세요.';
                  }
                  return null;
                },
                onChanged: (value) {
                  formData.userid = value;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                key: ValueKey(2),
                keyboardType: TextInputType.text,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.lock),
                  labelText: '비밀번호',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '비밀번호를 입력해주세요.';
                  }
                  return null;
                },
                onChanged: (value) {
                  formData.password = value;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    loginToServer();
                  }
                },
                child: Text('로그인'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'ID/PW 찾기',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('아직 회원이 아니신가요?'),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignupForm()),
                      );
                    },
                    child: Text(
                      '가입하기!',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
