import 'package:CampusCar/locator.dart';
import 'package:CampusCar/screens/splash/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage('assets/images/warning.png'), context);
    precacheImage(AssetImage('assets/images/car2.png'), context);
    precacheImage(AssetImage('assets/images/car-home.png'), context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Campus Car',
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      home: SplashScreen(),
    );
  }
}
