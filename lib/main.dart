import 'package:CampusCar/screens/SplashScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Campus Car',
      theme: ThemeData(scaffoldBackgroundColor: Colors.grey[300]),
      home: SplashScreen(),
    );
  }
}
