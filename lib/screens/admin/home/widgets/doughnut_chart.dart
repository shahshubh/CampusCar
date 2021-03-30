import 'package:CampusCar/locator.dart';
import 'package:CampusCar/screens/admin/home/widgets/chart_container.dart';
import 'package:CampusCar/service/admin_service.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DoughnutChart extends StatelessWidget {
  final adminService = locator<AdminService>();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: adminService.vehiclesStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Container();
        if (snapshot.hasData && snapshot.data.docs.length > 0) {
          int vehiclesInCampusCount = 0;
          int vehiclesOutCampusCount = 0;
          snapshot.data.docs.forEach((document) {
            if (document.data()['isInCampus'] == true)
              vehiclesInCampusCount = vehiclesInCampusCount + 1;
            else
              vehiclesOutCampusCount = vehiclesOutCampusCount + 1;
          });
          List<_PieData> graphData = [
            new _PieData('In Campus', vehiclesInCampusCount, Colors.redAccent),
            new _PieData(
                'Outside Campus', vehiclesOutCampusCount, Colors.blueAccent)
          ];
          return ChartContainer(
            child: SfCircularChart(
              title: ChartTitle(
                text: 'Vehicle Location',
                textStyle: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
              legend: Legend(isVisible: true),
              series: <DoughnutSeries<_PieData, String>>[
                DoughnutSeries<_PieData, String>(
                  explode: true,
                  pointColorMapper: (_PieData data, _) => data.color,
                  explodeIndex: 0,
                  dataSource: graphData,
                  xValueMapper: (_PieData data, _) => data.xData,
                  yValueMapper: (_PieData data, _) => data.yData,
                  dataLabelMapper: (_PieData data, _) => data.yData.toString(),
                  dataLabelSettings: DataLabelSettings(
                      isVisible: true,
                      textStyle: TextStyle(color: Colors.white)),
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
