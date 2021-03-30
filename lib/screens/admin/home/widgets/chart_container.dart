import 'package:flutter/material.dart';

class ChartContainer extends StatelessWidget {
  final Widget child;
  ChartContainer({@required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300],
            blurRadius: 15,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.95,
            child: child,
          ),
        ],
      ),
    );
  }
}
