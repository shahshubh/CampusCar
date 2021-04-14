import 'package:CampusCar/locator.dart';
import 'package:CampusCar/screens/splash/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await DotEnv.load(fileName: ".env");
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
