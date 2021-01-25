import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

List<Map> drawerItems = [
  {'icon': FontAwesomeIcons.home, 'title': 'Home', 'index': 0},
  {'icon': FontAwesomeIcons.plus, 'title': 'New Vehicle', 'index': 1},
  {'icon': FontAwesomeIcons.userAlt, 'title': 'Admin', 'index': 2},
];

class DrawerScreen extends StatefulWidget {
  final Function currentScreenHandler;
  final int currentScreen;
  DrawerScreen(
      {@required this.currentScreenHandler, @required this.currentScreen});

  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff4850df),
      padding: EdgeInsets.only(top: 50, bottom: 70, left: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Container(),
          Row(
            children: [
              // Container(
              //   child: Lottie.asset('assets/gif/fast-furious.json', height: 58),
              //   // color: Colors.black,
              // ),
              SizedBox(
                width: 10,
              ),
              FaIcon(
                FontAwesomeIcons.car,
                color: Colors.white,
                size: 28,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Campus Car',
                style: TextStyle(
                    color: Colors.white, fontSize: 24, fontFamily: 'CarterOne'),
              ),
            ],
          ),
          Column(
            children: drawerItems
                .map((element) => GestureDetector(
                      onTap: () {
                        widget.currentScreenHandler(element['index']);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: widget.currentScreen == element['index']
                                ? Colors.grey[100]
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(30)),
                        // decoration: BoxDecoration(
                        //     border: Border(
                        //         bottom: BorderSide(
                        //   color: Colors.white,
                        // ))),
                        padding: EdgeInsets.only(top: 18, bottom: 18, left: 14),
                        child: Row(
                          children: [
                            Icon(
                              element['icon'],
                              color: widget.currentScreen == element['index']
                                  ? Colors.black
                                  : Colors.white,
                              size: 20,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(element['title'],
                                style: TextStyle(
                                    color:
                                        widget.currentScreen == element['index']
                                            ? Colors.black
                                            : Colors.white,
                                    fontSize: 18)),
                          ],
                        ),
                      ),
                    ))
                .toList(),
          ),
          Row(
            children: [
              Icon(
                Icons.settings,
                color: Colors.white,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Settings',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                width: 2,
                height: 20,
                color: Colors.white,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Log out',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              )
            ],
          )
        ],
      ),
    );
  }
}
