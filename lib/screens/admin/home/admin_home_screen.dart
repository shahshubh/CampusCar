import 'package:CampusCar/widgets/my_drawer.dart';
import 'package:flutter/material.dart';

class AdminHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyDrawer(
      title: "Admin Home",
      child: Container(
        child: Text("ADMIN HOME PAGE"),
      ),
    );
  }
}