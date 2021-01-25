import 'package:CampusCar/screens/home/drawer_screen.dart';
import 'package:CampusCar/screens/home/home_screen.dart';
import 'package:CampusCar/screens/home/new_vehicle.dart';
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
        return HomeScreen(
          currentScreenHandler: changeCurrentScreen,
        );
        break;
      case 1:
        return NewVehicle(
          currentScreenHandler: changeCurrentScreen,
        );
        break;

      default:
        return HomeScreen(
          currentScreenHandler: changeCurrentScreen,
        );
        break;
    }
  }

  changeCurrentScreen(int index) {
    print(index);
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
