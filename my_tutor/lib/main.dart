import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_tutor/views/HomeScreen.dart';
import 'package:my_tutor/views/landingForm.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MainSplashScreen(),
    );
  }
}

class MainSplashScreen extends StatefulWidget {
  const MainSplashScreen({Key? key}) : super(key: key);

  @override
  State<MainSplashScreen> createState() => _MainSplashScreenState();
}

class _MainSplashScreenState extends State<MainSplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {});
      // Navigator.of(context).push(LandingFormRoute());
      Navigator.push(context, FadeRoute(page: const LandingForm()));

      // Navigator.of(context)
      //     .push(MaterialPageRoute(builder: (context) => HomeScreen()));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                Color.fromARGB(255, 72, 212, 251),
                Color.fromARGB(255, 16, 133, 228)
              ])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(height: 200),
              Text('My Tutor',
                  style: GoogleFonts.arizonia(
                      textStyle: const TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ))),
              SizedBox(
                height: 200,
                child: Image.asset(
                  'assets/logo.png',
                  fit: BoxFit.cover,
                ),
              ),
              Container(height: 150),
              const LinearProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}

class FadeRoute extends PageRouteBuilder {
  final Widget page;
  FadeRoute({required this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createdHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
