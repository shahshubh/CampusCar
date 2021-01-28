import 'package:CampusCar/widgets/my_drawer.dart';
import 'package:flutter/material.dart';

class AdminAddVehicle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyDrawer(
      title: "Admin Add Vehicle",
      child: Container(
        height: 800,
        child: Text("ADMIN ADD VEHICLE"),
      ),
    );
  }
}
