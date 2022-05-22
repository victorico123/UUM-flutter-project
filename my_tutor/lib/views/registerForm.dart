// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart' as p;
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  // ignore: prefer_typing_uninitialized_variables
  var _image, _imageExt;
  final _formKey = GlobalKey<FormState>();
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
            keyboardType: title == "Phone Number"
                ? TextInputType.number
                : TextInputType.multiline,
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

  Widget _submitButton() {
    return GestureDetector(
      onTap: () => {_onSubmit()},
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: const Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color.fromARGB(255, 72, 212, 251),
                  Color.fromARGB(255, 16, 133, 228)
                ])),
        child: const Text(
          'Register Now',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
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

  Widget _uploadPictureWidget() {
    return Center(
        child: Column(
      children: [
        const Text(
          "Profile Picture",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        const SizedBox(
          height: 20,
        ),
        _image == null
            ? const Text("Pick Image for Profile Picture",
                style: TextStyle(color: Colors.red))
            : Image.file(_image),
        const SizedBox(
          height: 20,
        ),
        FloatingActionButton(
            onPressed: _galleryPicker,
            tooltip: "Pick Image for Profile Picture",
            child: const Icon(Icons.photo_camera_back))
      ],
    ));
  }

  _galleryPicker() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 200,
      maxWidth: 200,
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _imageExt = p.extension(pickedFile.path);
      });
    }
  }

  Widget _formWidget() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          _entryField("Email", _emailController),
          _entryField("Name", _nameController),
          _entryField("Phone Number", _phoneController),
          _entryField("Password", _passwordController, isPassword: true),
          _entryField("Home Address", _addressController),
        ],
      ),
    );
  }

  _onSubmit() {
    if (_formKey.currentState!.validate() && _image != null) {
      _formKey.currentState!.save();
      _insertUser();
    }
  }

  void _insertUser() {
    String _email = _emailController.text;
    String _name = _nameController.text;
    String _phone = _phoneController.text;
    String _password = _passwordController.text;
    String _address = _addressController.text;
    String base64Image = base64Encode(_image!.readAsBytesSync());
    http.post(Uri.parse("http://10.19.105.124/myTutorAPI/register.php"), body: {
      "email": _email,
      "name": _name,
      "phone": _phone,
      "password": _password,
      "address": _address,
      "image": base64Image,
      "imageExt": _imageExt,
    }).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        Navigator.of(context).pop();
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
                    const SizedBox(
                      height: 40,
                    ),
                    _formWidget(),
                    const SizedBox(
                      height: 20,
                    ),
                    _uploadPictureWidget(),
                    const SizedBox(
                      height: 20,
                    ),
                    _submitButton(),
                    SizedBox(height: height * .05),
                  ],
                ),
              ),
            ),
            Positioned(top: 30, left: 0, child: _backButton()),
          ],
        ),
      ),
    );
  }
}
