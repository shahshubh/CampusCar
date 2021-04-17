import 'dart:io';

import 'package:CampusCar/locator.dart';
import 'package:CampusCar/models/vehicle.dart';
import 'package:CampusCar/screens/admin/vehicle/admin_vehicle_detail_screen.dart';
import 'package:CampusCar/service/admin_service.dart';
import 'package:CampusCar/utils/csv_util.dart';
import 'package:CampusCar/utils/sms_util.dart';
import 'package:CampusCar/utils/utils.dart';
import 'package:CampusCar/widgets/loading_screen.dart';
import 'package:CampusCar/widgets/my_drawer.dart';
import 'package:animated_search_bar/animated_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:downloads_path_provider/downloads_path_provider.dart';


class AdminVehiclesScreen extends StatefulWidget {
  @override
  _AdminVehiclesScreenState createState() => _AdminVehiclesScreenState();
}

class _AdminVehiclesScreenState extends State<AdminVehiclesScreen> {
  var adminService = locator<AdminService>();
  var filterValue = 'All';
  List<Vehicle> filteredData;
  List<Vehicle> allVehicles;
  String filePath;

  final pdf = pw.Document();

  writeOnPdf(List<Vehicle> vehicles) {
    final headers = ['Owner Name', 'License Plate', 'Mobile No.','Model','Role','Expires','Color'];
    final data = vehicles
        .map((vehicle) =>
            [
             vehicle.ownerName, 
             vehicle.licensePlateNo,                           
             vehicle.ownerMobileNo,
             vehicle.model,
             vehicle.role,
             vehicle.expires
             ])
        .toList();
    pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return <pw.Widget>[
            pw.Header(level: 0, child: pw.Text('All Vehicles')),
            pw.Table.fromTextArray(headers: headers, data: data)
          ];
        }
        )
        );
  }

  Future savePdf() async {
    Directory downloadsDirectory =
        await DownloadsPathProvider.downloadsDirectory;
    String documentPath = downloadsDirectory.absolute.path;
    print(documentPath);
    File file = File('$documentPath/Vehicles.pdf');
    file.writeAsBytesSync(pdf.save());
  }

  @override
  void initState() {
    super.initState();
  }

  Future<List<Vehicle>> getData() async {
    var allVeh = await adminService.getAllVehicles();
    setState(() {
      allVehicles = allVeh;
    });
    return allVeh;
  }

  getCsvHandler() async {
    List<List<dynamic>> rows = List<List<dynamic>>();
    rows.add([
      "Name",
      "License Plate",
      "Mobile No.",
      "Model",
      "Role",
      "Expires",
      "Color",
    ]);

    for (int i = 0; i < allVehicles.length; i++) {
      List<dynamic> row = List<dynamic>();
      row.add(allVehicles[i].ownerName);
      row.add(allVehicles[i].licensePlateNo);
      row.add(allVehicles[i].ownerMobileNo);
      row.add(allVehicles[i].model);
      row.add(allVehicles[i].role);
      row.add(DateFormat("dd/MM/yyyy hh:mm aa")
          .format(DateTime.parse(allVehicles[i].expires)));
      row.add(allVehicles[i].color);
      rows.add(row);
    }
    String currDate = DateTime.now().toString();
    String filename = "AllVehicles_$currDate";
    await CsvUtil.saveCsv(rows: rows, filename: filename);
  }

  void searchHandler({String text}) {
    text = text.toLowerCase();
    var newData = allVehicles
        .where((element) =>
            element.ownerName.toLowerCase().contains(text) ||
            element.licensePlateNo.toLowerCase().contains(text) ||
            element.ownerMobileNo.toLowerCase().contains(text))
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
          Fluttertoast.showToast(msg: "Download as CSV");
        },
        onTap: getCsvHandler,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Icon(Icons.file_download),
        ),
      ),
      child: Container(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: AnimatedSearchBar(
                label: "All Vehicles",
                searchDecoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    )),
                labelStyle: TextStyle(color: Colors.black, fontSize: 24),
                onChanged: (text) {
                  searchHandler(text: text);
                },
              ),
            ),
            FutureBuilder(
              future: getData(),
              builder: (context, AsyncSnapshot<List<Vehicle>> snapshot) {
                if (snapshot.hasData) {
                  return PaginatedDataTable(
                    header: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        DropdownButton(
                          value: filterValue,
                          items: <String>[
                            'All',
                            'Expired',
                            'In Campus',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            var newData;
                            switch (newValue) {
                              case 'In Campus':
                                newData = snapshot.data
                                    .where((element) => element.isInCampus)
                                    .toList();

                                break;
                              case 'Expired':
                                newData = snapshot.data
                                    .where((element) =>
                                        Utils.isExpired(element.expires))
                                    .toList();
                                break;
                            }

                            setState(() {
                              filteredData = newData;
                              filterValue = newValue;
                            });
                          },
                        ),
                      ],
                    ),
                    rowsPerPage:
                        snapshot.data.length < 10 ? snapshot.data.length : 10,
                    columns: [
                      DataColumn(label: Text('Owner Name')),
                      DataColumn(label: Text('License Plate')),
                      DataColumn(label: Text('Expires')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Actions')),
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
            FloatingActionButton(
              onPressed: () async {
                writeOnPdf((filteredData != null ? filteredData : allVehicles));
                await savePdf();
              },
              child: Icon(Icons.save),
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
    this.expires,
    this.status,
  );

  final String licensePlateNo;
  final String ownerName;
  final String expires;
  final String status;

  bool selected = false;
}

class _DataSource extends DataTableSource {
  final BuildContext context;
  List<_Row> _rows = [];
  List<Vehicle> data = [];

  void navigateToVehicleDetail({Vehicle vehicle}) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AdminVehicleDetailScreen(vehicle: vehicle)));
  }

  _DataSource(this.context, this.data) {
    data.forEach((Vehicle vehicle) {
      _rows.add(
        _Row(
          vehicle.licensePlateNo,
          vehicle.ownerName,
          vehicle.expires,
          vehicle.isInCampus ? "In Campus" : "-",
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
    String formattedDate =
        DateFormat("dd/MM hh:mm aa").format(DateTime.parse(row.expires));
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Row(
          children: [
            InkWell(
              onTap: () {
                navigateToVehicleDetail(vehicle: data[index]);
              },
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.remove_red_eye,
                  size: 20,
                ),
              ),
            ),
            SizedBox(width: 10),
            Text(row.ownerName),
          ],
        )),
        DataCell(Text(row.licensePlateNo)),
        DataCell(Text(
          formattedDate,
          style: Utils.isExpired(row.expires)
              ? TextStyle(color: Colors.red)
              : null,
        )),
        DataCell(Center(child: Text(row.status))),
        DataCell(
          GestureDetector(
            onTap: () {
              SmsUtil.sendReminderSms(
                number: data[index].ownerMobileNo,
                name: data[index].ownerName,
                expiryDate: data[index].expires,
                licensePlate: data[index].licensePlateNo,
              );
            },
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: FaIcon(FontAwesomeIcons.stopwatch),
              ),
            ),
          ),
        ),
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
