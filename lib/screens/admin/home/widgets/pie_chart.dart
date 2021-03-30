import 'package:CampusCar/locator.dart';
import 'package:CampusCar/service/admin_service.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PieChart extends StatelessWidget {
  final adminService = locator<AdminService>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: adminService.vehiclesStream(),
      builder: (context, snapshot) {
        List<_PieData> graphData = [];
        Map<String, int> data = {};

        if (snapshot.connectionState == ConnectionState.waiting)
          return Container();
        if (snapshot.hasData && snapshot.data.docs.length > 0) {
          snapshot.data.docs.forEach((document) {
            String role = document.data()['role'];
            if (data[role] != null) {
              data.update(role, (value) => value + 1);
            } else {
              data[role] = 1;
            }
          });
          int i = 0;
          List<Color> allColors = [
            Colors.red[100],
            Colors.blueAccent,
            Colors.red[400],
          ];
          data.forEach((key, value) {
            // if colors are less then repeat from start
            if (i + 1 >= allColors.length) i = 0;
            graphData.add(_PieData(key, value, allColors[i++]));
          });
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[300],
                  blurRadius: 15,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: SfCircularChart(
                    title: ChartTitle(
                      text: 'Vehicle Owner Roles',
                      textStyle: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    legend: Legend(isVisible: true),
                    series: <PieSeries<_PieData, String>>[
                      PieSeries<_PieData, String>(
                        explodeGesture: ActivationMode.singleTap,
                        explode: true,
                        pointColorMapper: (_PieData data, _) => data.color,
                        dataSource: graphData,
                        xValueMapper: (_PieData data, _) => data.xData,
                        yValueMapper: (_PieData data, _) => data.yData,
                        dataLabelMapper: (_PieData data, _) =>
                            data.yData.toString(),
                        dataLabelSettings: DataLabelSettings(
                            isVisible: true,
                            textStyle: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}

class _PieData {
  _PieData(this.xData, this.yData, this.color);
  final String xData;
  final int yData;
  final Color color;
}
