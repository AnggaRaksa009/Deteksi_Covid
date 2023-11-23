import 'package:flutter/material.dart';
import 'package:kanker/HomeScreen.dart';
import 'package:kanker/gray.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: GrayScale(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 3),
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
      backgroundColor: const Color(0xff5D79C2),
      body: Center(
        child: Column(
          children: [
            const Spacer(),
            Image.asset('assets/iconSplash.png'),
            const Spacer(),
            Image.asset('assets/footerSplash.png'),
          ],
        ),
      ),
    );
  }
}
