import 'package:CampusCar/widgets/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingScreen extends StatelessWidget {
  final String lottieAssetPath;
  LoadingScreen({
    this.lottieAssetPath = 'assets/gif/car-number-plate.json',
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            child: Center(
              child: Lottie.asset(
                lottieAssetPath,
                width: 150,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
