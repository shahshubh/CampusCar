import 'package:CampusCar/locator.dart';
import 'package:CampusCar/screens/admin/home/widgets/chart_container.dart';
import 'package:CampusCar/service/admin_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LineChart extends StatelessWidget {
  final adminService = locator<AdminService>();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: adminService.dailyScansStream(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Container();

        if (snapshot.hasData && snapshot.data.docs.length > 0) {
          List<_ScansData> graphData = [];
          snapshot.data.docs.forEach((document) {
            graphData.add(
              _ScansData(
                DateTime.parse(document.data()['timestamp']),
                document.data()['count'],
              ),
            );
          });

          return ChartContainer(
            child: SfCartesianChart(
              primaryXAxis:
                  CategoryAxis(majorGridLines: MajorGridLines(width: 0)),
              primaryYAxis:
                  NumericAxis(majorGridLines: MajorGridLines(width: 0)),
              title: ChartTitle(
                text: 'Daily Scans',
                textStyle: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
              // legend: Legend(isVisible: true),

              tooltipBehavior: TooltipBehavior(enable: true),
              series: <LineSeries<_ScansData, String>>[
                LineSeries<_ScansData, String>(
                  name: 'Daily Scans',
                  // color: ,
                  dataSource: graphData,
                  xValueMapper: (_ScansData data, _) =>
                      DateFormat("dd/MM/yy").format(data.date),
                  yValueMapper: (_ScansData data, _) => data.count,
                  dataLabelSettings: DataLabelSettings(isVisible: true),
                )
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

class _ScansData {
  _ScansData(this.date, this.count);
  final DateTime date;
  final int count;
}
