import 'package:CampusCar/widgets/my_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
          Container(child: Text("New Vehicle")),
        ],
      ),
    );
  }
}
