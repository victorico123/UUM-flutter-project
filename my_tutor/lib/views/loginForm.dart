import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:my_tutor/model/user.dart';
import 'dart:convert';
import 'package:my_tutor/global.dart' as gb;

import 'package:my_tutor/views/HomeScreen.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController =
      TextEditingController(text: "");
  final TextEditingController _passwordController =
      TextEditingController(text: "");
  bool _isCheckedSavePassword = false;
  final _formKey = GlobalKey<FormState>();
  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    readFromStorage();
  }

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: const Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            const Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _entryField(String title, TextEditingController myContoller,
      {bool isPassword = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: myContoller,
            obscureText: isPassword,
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration(
                border: InputBorder.none,
                fillColor: Color(0xfff3f3f4),
                filled: true),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter ' + title + ' field.';
              }
              return null;
            },
          )
        ],
      ),
    );
  }

  Widget _remmberWidget() {
    return Row(
      children: [
        Checkbox(
          activeColor: const Color(0xff00C8E8),
          value: _isCheckedSavePassword,
          onChanged: (bool? value) {
            _onRememberMeChanged(value!);
          },
        ),
        const Text("Remember Me",
            style: TextStyle(
              color: Color(0xff646464),
              fontSize: 12,
            ))
      ],
    );
  }

  void _onRememberMeChanged(bool value) {
    _isCheckedSavePassword = value;
    setState(() {
      if (_isCheckedSavePassword) {
        _saveRemoveCreds(true);
      } else {
        _saveRemoveCreds(false);
      }
    });
  }

  void _saveRemoveCreds(bool value) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String email = _emailController.text;
      String password = _passwordController.text;
      if (value) {
        await _storage.write(key: "KEY_EMAIL", value: email);
        await _storage.write(key: "KEY_PASSWORD", value: password);
      } else {
        await _storage.write(key: "KEY_EMAIL", value: '');
        await _storage.write(key: "KEY_PASSWORD", value: '');
      }
    } else {
      Fluttertoast.showToast(
          msg: "Failed to Remember Me",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      _isCheckedSavePassword = false;
    }
  }

  Future<void> readFromStorage() async {
    var email = await _storage.read(key: "KEY_EMAIL") ?? '';
    var pass = await _storage.read(key: "KEY_PASSWORD") ?? '';
    if (email != '') {
      setState(() {
        _emailController.text = email;
        _passwordController.text = pass;
        _isCheckedSavePassword = true;
      });
    }
  }

  void _validateUser() {
    String email = _emailController.text;
    String password = _passwordController.text;
    http.post(Uri.parse("http://10.19.48.148/myTutorAPI/login.php"),
        body: {"email": email, "password": password}).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        gb.globaUser = User.fromJson(data['data']);
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => HomeScreen()));
      } else {
        Fluttertoast.showToast(
            msg: data['status'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
    });
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _validateUser();
    }
  }

  Widget _submitButton() {
    return GestureDetector(
      onTap: () => _onSubmit(),
      child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(vertical: 15),
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color.fromARGB(255, 72, 212, 251),
                    Color.fromARGB(255, 16, 133, 228)
                  ])),
          child: const Text(
            'Login',
            style: TextStyle(fontSize: 20, color: Colors.white),
          )),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'My',
          style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w700,
              color: Color.fromARGB(255, 16, 133, 228)),
          children: [
            TextSpan(
                text: 'Tutor',
                style: GoogleFonts.arizonia(
                    textStyle: const TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 16, 133, 228),
                )))
          ]),
    );
  }

  Widget _formWidget() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          _entryField("Email", _emailController),
          _entryField("Password", _passwordController, isPassword: true),
          _remmberWidget(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SizedBox(
      height: height,
      child: Stack(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: height * .15),
                  _title(),
                  const SizedBox(height: 40),
                  _formWidget(),
                  // Container(
                  //   padding: const EdgeInsets.symmetric(vertical: 10),
                  //   alignment: Alignment.centerRight,
                  //   child: const Text('Forgot Password ?',
                  //       style: TextStyle(
                  //           fontSize: 14, fontWeight: FontWeight.w500)),
                  // ),
                  const SizedBox(height: 20),
                  _submitButton(),
                ],
              ),
            ),
          ),
          Positioned(top: 30, left: 0, child: _backButton()),
        ],
      ),
    ));
  }
}
