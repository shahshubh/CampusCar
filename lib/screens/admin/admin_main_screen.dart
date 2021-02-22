import 'package:CampusCar/screens/admin/drawer/admin_drawer_screen.dart';
import 'package:CampusCar/screens/admin/home/admin_add_vehicle.dart';
import 'package:CampusCar/screens/admin/home/admin_home_page.dart';
import 'package:CampusCar/screens/admin/home/admin_login.dart';
import 'package:flutter/material.dart';

class AdminMainScreen extends StatefulWidget {
  @override
  _AdminMainScreenState createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  int currentScreen = 0;

  getTheScreen() {
    switch (currentScreen) {
      case 0:
        return AdminHomeScreen();
        break;
      case 1:
        return AdminAddVehicle();
        break;

      case 2:
        return AdminLogin();
        break;

      default:
        return AdminAddVehicle();
        break;

      // default:
      //   return AdminHomeScreen(
      //     currentScreenHandler: changeCurrentScreen,
      //   );
      //   break;
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
          AdminDrawerScreen(
              currentScreenHandler: changeCurrentScreen,
              currentScreen: currentScreen),
          getTheScreen(),
        ],
      ),
    );
  }
}
