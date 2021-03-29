import 'package:CampusCar/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StatsGrid extends StatelessWidget {
  final graphRed = Color(0xffff6a69);
  final graphBlue = Color(0xff7a54ff);
  final graphOrange = Color(0xffff8f61);
  final graphGreen = Color(0xff96da47);
  final graphLightBlue = Color(0xff2ac3ff);

  final numberFormatter = NumberFormat.compact(locale: 'en_US');

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: MediaQuery.of(context).size.height * 0.4,
      height: MediaQuery.of(context).size.height * 0.25,
      child: Column(
        children: <Widget>[
          Flexible(
            child: Row(
              children: <Widget>[
                _buildStatCard('Total Vehicles',
                    numberFormatter.format(1200000), graphRed),
                _buildStatCard(
                    'Permit Expired', numberFormatter.format(1100), graphBlue),
              ],
            ),
          ),
          Flexible(
            child: Row(
              children: <Widget>[
                _buildStatCard(
                    'Total Scans', numberFormatter.format(391900), graphOrange),
                _buildStatCard('Total Vehicle Logs',
                    numberFormatter.format(3587), graphLightBlue),
              ],
            ),
          ),
          // Flexible(
          //   child: Row(
          //     children: <Widget>[
          //       _buildStatCard('Vehicles inside campus',
          //           numberFormatter.format(11047), lightBlue),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  Expanded _buildStatCard(String title, String count, Color color) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(5.0),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: color,
              blurRadius: 12,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              count,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
