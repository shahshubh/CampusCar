import 'package:CampusCar/widgets/my_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

List<BoxShadow> shadowList = [
  BoxShadow(color: Colors.grey[200], blurRadius: 30, offset: Offset(0, 10))
];

class NewVehicle extends StatefulWidget {
  final Function currentScreenHandler;
  NewVehicle({@required this.currentScreenHandler});
  @override
  _NewVehicleState createState() => _NewVehicleState();
}

class _NewVehicleState extends State<NewVehicle> {
  @override
  Widget build(BuildContext context) {
    return MyDrawer(
      title: "New Vehicle",
      child: Column(
        children: [
          Container(height: 640, child: Text("New Vehicle")),
          // Container(
          //   height: 240,
          // ),
          // Container(
          //   height: 240,
          // ),
          // SizedBox(
          //   height: 50,
          // )
        ],
      ),
    );
  }
}
