import 'dart:async';
import 'package:CampusCar/widgets/MyFadeIn.dart';
import 'package:flutter/material.dart';
import 'package:CampusCar/screens/HomeScreen.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final splashDelay = 6;

  @override
  void initState() {
    super.initState();
    _loadWidget();
  }

  _loadWidget() async {
    var _duration = Duration(seconds: splashDelay);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: MyFadeIn(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(
                height: 40,
              ),
              Container(
                child: Text("Campus Car",
                    style: TextStyle(
                        fontFamily: 'CarterOne',
                        fontSize: 40,
                        color: Color(0xff4850df))),
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        child: Lottie.asset('assets/gif/fast-furious.json'),
                        // color: Colors.black,
                      ),
                      Positioned(
                        top: 20,
                        child: Lottie.asset('assets/gif/cam-cctv.json',
                            height: 80),
                      ),
                    ],
                  ),
                ],
              ),
            ]),
          ),
        ],
      ),
    ));
  }
}
