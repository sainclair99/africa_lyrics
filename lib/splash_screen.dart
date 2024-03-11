import 'package:flutter/material.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
    // return Scaffold(
    //   backgroundColor: Colors.white,
    //   body: Container(
    //     decoration: BoxDecoration(
    //       image: DecorationImage(
    //         fit: BoxFit.fill,
    //         image: AssetImage("assets/images/background_clear.jpg"),
    //       ),
    //     ),
    //     child: Center(
    //       child: Image.asset(
    //         "assets/images/logo-circle.jpg",
    //         height: 60,
    //         width: 60,
    //       ),
    //     ),
    //   ),
    // );
  }
}
