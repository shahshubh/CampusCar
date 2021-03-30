import 'package:CampusCar/components/progress_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LineChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('scans').snapshots(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
          // Center(
          //   child: circularprogress(color: Colors.black),
          // );
        }

        if (snapshot.hasData && snapshot.data.docs.length > 0) {
          List<ScansData> graphData = [];
          snapshot.data.docs.forEach((DocumentSnapshot document) {
            graphData.add(
              ScansData(
                DateTime.parse(document.data()['timestamp']),
                document.data()['count'],
              ),
            );
          });

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
                bottomLeft: Radius.circular(20.0),
              ),
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
                    series: <LineSeries<ScansData, String>>[
                      LineSeries<ScansData, String>(
                        name: 'Daily Scans',
                        // color: ,
                        dataSource: graphData,
                        xValueMapper: (ScansData data, _) =>
                            DateFormat("dd/MM/yy").format(data.date),
                        yValueMapper: (ScansData data, _) => data.count,
                        dataLabelSettings: DataLabelSettings(isVisible: true),
                      )
                    ],
                  ),
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

class ScansData {
  ScansData(this.date, this.count);
  final DateTime date;
  final int count;
}
