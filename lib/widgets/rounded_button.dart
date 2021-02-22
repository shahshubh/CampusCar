import 'package:CampusCar/constants/colors.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final Function press;
  final Widget child;
  final Color color;
  const RoundedButton({
    Key key,
    this.child,
    this.press,
    this.color = primaryBlue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.6,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: FlatButton(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          color: color,
          onPressed: press,
          child: child,
        ),
      ),
    );
  }
}
