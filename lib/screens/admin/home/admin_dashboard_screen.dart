import 'package:CampusCar/screens/admin/home/widgets/line_chart.dart';
import 'package:CampusCar/screens/admin/home/widgets/stats_grid.dart';
import 'package:CampusCar/widgets/my_drawer.dart';
import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatefulWidget {
  @override
  _AdminDashboardScreenState createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return MyDrawer(
      // title: "Dashboard",
      child: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Container(
                child: Text(
                  "Dashboard",
                  style: TextStyle(color: Colors.black, fontSize: 24),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: StatsGrid(),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(10.0),
            //   child: LineChart(),
            // ),
          ],
        ),
      ),
    );
  }
}
