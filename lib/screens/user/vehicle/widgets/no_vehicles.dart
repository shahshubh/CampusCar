import 'package:CampusCar/constants/colors.dart';
import 'package:CampusCar/widgets/rounded_button.dart';
import 'package:flutter/material.dart';

class NoVehicles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "No Vehicles at the Gate",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          Stack(
            children: [
              Image.asset(
                'assets/images/warning.png',
              ),
              Image.asset(
                'assets/images/car2.png',
              ),
            ],
          ),
          RoundedButton(
            child: Text("Go Back", style: TextStyle(color: Colors.white)),
            press: () {
              Navigator.pop(context);
            },
            color: lightBlue,
          )
        ],
      ),
    );
  }
}
