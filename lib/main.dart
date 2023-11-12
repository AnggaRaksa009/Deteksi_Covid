import 'package:flutter/material.dart';
import 'package:kanker/HomeScreen.dart';
import 'package:kanker/gray.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GrayScale(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(seconds: 3),
      () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) =>
                HomeScreen(), // Gunakan HomeScreen dari file yang diimpor
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff5D79C2),
      body: Center(
        child: Column(
          children: [
            Spacer(),
            Image.asset('assets/iconSplash.png'),
            Spacer(),
            Image.asset('assets/footerSplash.png'),
          ],
        ),
      ),
    );
  }
}
