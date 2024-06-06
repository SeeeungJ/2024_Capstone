import 'package:flutter/material.dart';
import 'package:front_singup/login_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupFormData {
  String? userid;
  String? password;
  String? name;
  String? nickname;
  String? gender;
  String? phone;
  String? email;

  SignupFormData({
    this.userid,
    this.password,
    this.name,
    this.nickname,
    this.gender,
    this.phone,
    this.email,
  });

  Map<String, dynamic> toJson() => {
        "userid": userid,
        "password": password,
        "name": name,
        "nickname": nickname,
        "gender": gender,
        "phone": phone,
        "email": email,
      };
}

class SignupForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final formKey = GlobalKey<FormState>();
  SignupFormData formData = SignupFormData();

  final TextEditingController useridController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  String _selectedGender = 'Male';

  @override
  void dispose() {
    useridController.dispose();
    passwordController.dispose();
    nameController.dispose();
    nicknameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> checkUserId() async {
    String jsonResult = jsonEncode({"userid": formData.userid});
    final result = await http.post(
      Uri.http('127.0.0.1:8000', '/user/userid_check/'),
      headers: {'content-type': 'application/json'},
      body: jsonResult,
    );
    if (result.statusCode == 200) {
      _showCheckDialog('사용 가능한 아이디입니다.');
    } else {
      _showCheckDialog('아이디가 이미 사용 중입니다.');
    }
  }

  Future<void> checkNickname() async {
    String jsonResult = jsonEncode({"nickname": formData.nickname});
    final result = await http.post(
      Uri.http('127.0.0.1:8000', '/user/nickname_check/'),
      headers: {'content-type': 'application/json'},
      body: jsonResult,
    );
    if (result.statusCode == 200) {
      _showCheckDialog('사용 가능한 닉네임입니다.');
    } else {
      _showCheckDialog('닉네임이 이미 사용 중입니다.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 80),
              // Image.asset(
              //   'assets/logo.png', // 로고 이미지 경로에 맞게 변경
              //   height: 100,
              // ),
              SizedBox(height: 20),
              Text(
                '회원가입',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              _buildTextField(useridController, 'ID', Icons.account_circle_outlined, false),
              _buildCheckButton(checkUserId, 'Check ID'),
              _buildTextField(passwordController, 'Password', Icons.lock_open_outlined, true),
              _buildTextField(nameController, 'Name', Icons.account_circle_outlined, false),
              _buildTextField(nicknameController, 'Nickname', Icons.account_circle_outlined, false),
              _buildCheckButton(checkNickname, 'Check Nickname'),
              _buildGenderRadio(),
              _buildTextField(phoneController, 'Phone', Icons.phone, false),
              _buildTextField(emailController, 'Email', Icons.mail_outline, false),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: addTaskToServer,
                child: Text('Signup'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText, IconData icon, bool obscureText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onChanged: (value) {
          switch (labelText) {
            case 'ID':
              formData.userid = value;
              break;
            case 'Password':
              formData.password = value;
              break;
            case 'Name':
              formData.name = value;
              break;
            case 'Nickname':
              formData.nickname = value;
              break;
            case 'Phone':
              formData.phone = value;
              break;
            case 'Email':
              formData.email = value;
              break;
          }
        },
      ),
    );
  }

  Widget _buildCheckButton(Function checkFunction, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        onPressed: () => checkFunction(),
        child: Text(label),
      ),
    );
  }

  Widget _buildGenderRadio() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: ListTile(
            title: const Text('Male'),
            leading: Radio<String>(
              value: 'Male',
              groupValue: _selectedGender,
              onChanged: (String? value) {
                setState(() {
                  _selectedGender = value!;
                  formData.gender = value;
                });
              },
            ),
          ),
        ),
        Expanded(
          child: ListTile(
            title: const Text('Female'),
            leading: Radio<String>(
              value: 'Female',
              groupValue: _selectedGender,
              onChanged: (String? value) {
                setState(() {
                  _selectedGender = value!;
                  formData.gender = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  void _showCheckDialog(String message) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
        actions: [
          TextButton(
            child: const Text('확인'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _showDialog(String message) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
        actions: [
          TextButton(
            child: const Text('확인'),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginForm()),
              );
            },
          ),
        ],
      ),
    );
  }

  void addTaskToServer() async {
    String jsonResult = jsonEncode(formData.toJson());
    final result = await http.post(
      // Uri.http('10.0.2.2:8000', '/user/info/'),
      Uri.http('127.0.0.1:8000', '/user/info/'),
      headers: {'content-type': 'application/json'},
      body: jsonResult,
    );
    if (result.statusCode == 201) {
      _showDialog('회원가입에 성공했습니다.');
      useridController.clear();
      passwordController.clear();
      nameController.clear();
      nicknameController.clear();
      phoneController.clear();
      emailController.clear();
      setState(() {
        _selectedGender = 'Male';
      });
    } else {
      _showCheckDialog('회원가입에 실패했습니다.');
    }
  }
}
