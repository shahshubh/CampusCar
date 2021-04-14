import 'package:CampusCar/screens/user/drawer/drawer_screen.dart';
import 'package:CampusCar/screens/user/home/home_screen.dart';
import 'package:CampusCar/screens/user/vehicle/new_vehicle_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentScreen = 0;

  getTheScreen() {
    switch (currentScreen) {
      case 0:
        return HomeScreen();
        break;
      case 1:
        return NewVehicle();
        break;
      default:
        return HomeScreen();
        break;
    }
  }

  changeCurrentScreen(int index) {
    setState(() {
      currentScreen = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          DrawerScreen(
              currentScreenHandler: changeCurrentScreen,
              currentScreen: currentScreen),
          getTheScreen(),
        ],
      ),
    );
  }
}
