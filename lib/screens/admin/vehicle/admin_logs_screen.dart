import 'package:CampusCar/models/log.dart';
import 'package:CampusCar/screens/admin/vehicle/admin_vehicle_detail_screen.dart';
import 'package:CampusCar/widgets/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:CampusCar/constants/colors.dart';
import 'package:CampusCar/locator.dart';
import 'package:CampusCar/models/vehicle.dart';
import 'package:CampusCar/screens/admin/vehicle/admin_vehicle_detail_screen.dart';
import 'package:CampusCar/service/admin_service.dart';
import 'package:CampusCar/utils/sms_util.dart';
import 'package:CampusCar/utils/utils.dart';
import 'package:CampusCar/widgets/loading_screen.dart';
import 'package:CampusCar/widgets/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class AdminLogsScreen extends StatefulWidget {
  @override
  _AdminLogsScreenState createState() => _AdminLogsScreenState();
}

class _AdminLogsScreenState extends State<AdminLogsScreen> {
  
  var adminService = locator<AdminService>();
  var filterValue = 'All';
  List<Log> filteredData;

  @override
  void initState() {
    super.initState();
  }

  Future<List<Log>> getData() async {
    var allLogs = await adminService.getAllLogs();
    return allLogs;
  }

  @override
  Widget build(BuildContext context) {
    return MyDrawer(
      title: "Logs Screen",
      child: GestureDetector(
        onTap: () {},
        child: Container(
          child: Column(
            children: [
              Container(child: Text("PAGE")),
              FutureBuilder(
                future: getData(),
                builder: (context, AsyncSnapshot<List<Log>> snapshot) {
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
                                      .where((element) => element.vehicle['isInCampus'])
                                      .toList();

                                  break;
                                case 'Expired':
                                  newData = snapshot.data
                                      .where((element) =>
                                          Utils.isExpired(element.vehicle['expires']))
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
                          minHeight: MediaQuery.of(context).size.height - 95),
                      child: LoadingScreen(),
                    );
                  }
                },
              ),
            ],
          ),
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

