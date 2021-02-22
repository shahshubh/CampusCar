import 'package:CampusCar/widgets/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            child: Center(
              child:
                  Lottie.asset('assets/gif/car-number-plate.json', width: 150),
            ),
          ),
        ],
      ),
    );
  }
}
