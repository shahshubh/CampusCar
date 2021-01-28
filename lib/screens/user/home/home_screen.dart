import 'package:CampusCar/widgets/my_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

List<BoxShadow> shadowList = [
  BoxShadow(color: Colors.grey[200], blurRadius: 30, offset: Offset(0, 10))
];

class HomeScreen extends StatefulWidget {
  final Function currentScreenHandler;
  HomeScreen({@required this.currentScreenHandler});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return MyDrawer(
      child: Column(
        children: [
          Container(
            height: 260,
          ),
          Container(height: 120, child: Text("Home Screen")),
          // GestureDetector(
          //   onTap: () {
          //     // Navigator.push(context,
          //     //     MaterialPageRoute(builder: (context) => Screen2()));
          //   },
          //   child: Container(
          //     height: 240,
          //     margin: EdgeInsets.symmetric(horizontal: 20),
          //     child: Row(
          //       children: [
          //         Expanded(
          //           child: Stack(
          //             children: [
          //               Container(
          //                 decoration: BoxDecoration(
          //                   color: Colors.blueGrey[300],
          //                   borderRadius: BorderRadius.circular(20),
          //                   boxShadow: shadowList,
          //                 ),
          //                 margin: EdgeInsets.only(top: 50),
          //               ),
          //               Align(
          //                 child: Hero(tag: 1, child: Container()),
          //               )
          //             ],
          //           ),
          //         ),
          //         Expanded(
          //             child: Container(
          //           margin: EdgeInsets.only(top: 60, bottom: 20),
          //           decoration: BoxDecoration(
          //               color: Colors.white,
          //               boxShadow: shadowList,
          //               borderRadius: BorderRadius.only(
          //                   topRight: Radius.circular(20),
          //                   bottomRight: Radius.circular(20))),
          //         ))
          //       ],
          //     ),
          //   ),
          // ),
          Container(
            height: 260,
          ),
        ],
      ),
    );
  }
}
