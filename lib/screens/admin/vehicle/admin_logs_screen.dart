import 'package:CampusCar/models/log.dart';
import 'package:CampusCar/screens/admin/vehicle/admin_vehicle_detail_screen.dart';
import 'package:CampusCar/screens/admin/vehicle/widgets/download_dialog_content.dart';
import 'package:CampusCar/utils/export_util.dart';
import 'package:CampusCar/widgets/my_drawer.dart';
import 'package:animated_search_bar/animated_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:CampusCar/locator.dart';
import 'package:CampusCar/models/vehicle.dart';
import 'package:CampusCar/service/admin_service.dart';
import 'package:CampusCar/utils/utils.dart';
import 'package:CampusCar/widgets/loading_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class AdminLogsScreen extends StatefulWidget {
  @override
  _AdminLogsScreenState createState() => _AdminLogsScreenState();
}

class _AdminLogsScreenState extends State<AdminLogsScreen> {
  var adminService = locator<AdminService>();
  List<Log> filteredData;
  List<Log> allLogs;
  String filePath;

  @override
  void initState() {
    super.initState();
  }

  Future<List<Log>> getData() async {
    var data = await adminService.getAllLogs();
    setState(() {
      allLogs = data;
    });
    return data;
  }

  void downloadPdfHandler() {
    var logs = filteredData != null ? filteredData : allLogs;

    final headers = [
      'Owner Name',
      'License Plate',
      'Time',
      'Direction',
      'Mobile No.',
    ];
    final data = logs
        .map((log) => [
              log.vehicle['ownerName'],
              log.vehicle['licensePlateNo'],
              DateFormat("dd/MM/yyyy hh:mm aa")
                  .format(DateTime.parse(log.time)),
              Utils.numToString(log.direction),
              log.vehicle['ownerMobileNo'],
            ])
        .toList();

    String currDate = DateTime.now().toString();
    String filename = "Logs_$currDate";
    ExportUtil.saveAsPdf(
        data: data, headers: headers, filename: filename, pdfTitle: "All Logs");
  }

  downloadCsvHandler() async {
    var logs = filteredData != null ? filteredData : allLogs;
    List<List<dynamic>> rows = [];
    rows.add([
      "Name",
      "License Plate",
      "Time",
      "Direction",
      "Mobile No.",
      "Model",
      "Role",
      "Expires"
    ]);

    for (int i = 0; i < logs.length; i++) {
      List<dynamic> row = [];
      row.add(logs[i].vehicle["ownerName"]);
      row.add(logs[i].vehicle["licensePlateNo"]);
      row.add(DateFormat("dd/MM/yyyy hh:mm aa")
          .format(DateTime.parse(logs[i].time)));
      row.add(Utils.numToString(logs[i].direction));
      row.add(logs[i].vehicle["ownerMobileNo"]);
      row.add(logs[i].vehicle["model"]);
      row.add(logs[i].vehicle["role"]);
      row.add(DateFormat("dd/MM/yyyy hh:mm aa")
          .format(DateTime.parse(logs[i].vehicle["expires"])));

      rows.add(row);
    }

    String currDate = DateTime.now().toString();
    String filename = "Logs_$currDate";
    await ExportUtil.saveAsCsv(rows: rows, filename: filename);
  }

  void showDownloadDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => DownloadDialogContent(
        downloadCsvHandler: downloadCsvHandler,
        downloadPdfHandler: downloadPdfHandler,
      ),
    );
  }

  void searchHandler({String text, List<Log> data}) {
    text = text.toLowerCase();
    var newData = data
        .where((element) =>
            element.vehicle["ownerName"].toLowerCase().contains(text) ||
            element.vehicle["licensePlateNo"].toLowerCase().contains(text) ||
            element.vehicle["ownerMobileNo"].toLowerCase().contains(text) ||
            DateFormat("dd/MM/yyyy hh:mm aa")
                .format(DateTime.parse(element.time))
                .toLowerCase()
                .contains(text))
        .toList();
    setState(() {
      filteredData = newData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MyDrawer(
      rightIcon: GestureDetector(
        onLongPress: () {
          Fluttertoast.showToast(msg: "Download as Csv or Pdf");
        },
        onTap: showDownloadDialog,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Icon(Icons.file_download),
        ),
      ),
      child: Container(
        child: Column(
          children: [
            FutureBuilder(
              future: getData(),
              builder: (context, AsyncSnapshot<List<Log>> snapshot) {
                if (snapshot.hasData) {
                  return PaginatedDataTable(
                    header: Row(
                      children: [
                        Expanded(
                          child: AnimatedSearchBar(
                            searchDecoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                )),
                            label: "Vehicle Logs",
                            labelStyle:
                                TextStyle(color: Colors.black, fontSize: 24),
                            onChanged: (text) {
                              searchHandler(text: text, data: snapshot.data);
                            },
                          ),
                        ),
                      ],
                    ),
                    rowsPerPage:
                        snapshot.data.length < 10 ? snapshot.data.length : 10,
                    columns: [
                      DataColumn(label: Text('Owner Name')),
                      DataColumn(label: Text('License Plate')),
                      DataColumn(label: Text('Time')),
                      DataColumn(label: Text('Direction')),
                    ],
                    source: _DataSource(context,
                        filteredData != null ? filteredData : snapshot.data),
                  );
                } else if (snapshot.hasError) {
                  return Container(
                    alignment: Alignment.center,
                    constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height - 95),
                    child: Text("Some Error Occured !!"),
                  );
                } else {
                  return Container(
                    alignment: Alignment.center,
                    constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height - 145),
                    child: LoadingScreen(
                        lottieAssetPath: "assets/gif/loading-animation.json"),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Row {
  _Row(
    this.licensePlateNo,
    this.ownerName,
    this.time,
    this.direction,
  );

  final String licensePlateNo;
  final String ownerName;
  final String time;
  final String direction;

  bool selected = false;
}

class _DataSource extends DataTableSource {
  final BuildContext context;
  List<_Row> _rows = [];
  List<Log> data = [];

  void navigateToVehicleDetail({Vehicle vehicle}) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AdminVehicleDetailScreen(vehicle: vehicle)));
  }

  _DataSource(this.context, this.data) {
    data.forEach((Log log) {
      _rows.add(
        _Row(
          log.vehicle['licensePlateNo'],
          log.vehicle['ownerName'],
          DateFormat("dd/MM/yyyy hh:mm aa").format(DateTime.parse(log.time)),
          Utils.numToString(log.direction),
        ),
      );
    });
  }

  int _selectedCount = 0;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= _rows.length) return null;
    final row = _rows[index];

    return DataRow.byIndex(
      index: index,
      // selected: row.selected,
      // onSelectChanged: (value) {
      //   if (row.selected != value) {
      //     _selectedCount += value ? 1 : -1;
      //     assert(_selectedCount >= 0);
      //     row.selected = value;
      //     notifyListeners();
      //   }
      // },
      cells: [
        DataCell(Text(row.ownerName)),
        DataCell(Text(row.licensePlateNo)),
        DataCell(Text(
          row.time,
        )),
        DataCell(Center(child: Text(row.direction))),
      ],
    );
  }

  @override
  int get rowCount => _rows.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;
}
