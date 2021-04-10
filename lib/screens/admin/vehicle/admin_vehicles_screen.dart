import 'package:CampusCar/locator.dart';
import 'package:CampusCar/models/vehicle.dart';
import 'package:CampusCar/screens/admin/vehicle/admin_vehicle_detail_screen.dart';
import 'package:CampusCar/service/admin_service.dart';
import 'package:CampusCar/widgets/loading_screen.dart';
import 'package:CampusCar/widgets/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminVehiclesScreen extends StatefulWidget {
  @override
  _AdminVehiclesScreenState createState() => _AdminVehiclesScreenState();
}

class _AdminVehiclesScreenState extends State<AdminVehiclesScreen> {
  var adminService = locator<AdminService>();
  List<Vehicle> allVehicles;
  var filterValue = 'All';
  List<Vehicle> filteredData;

  @override
  void initState() {
    super.initState();
  }

  Future<List<Vehicle>> getData() async {
    allVehicles = await adminService.getAllVehicles();
    return allVehicles;
  }

  @override
  Widget build(BuildContext context) {
    return MyDrawer(
      child: Container(
        child: Column(
          children: [
            Container(
              child: Text(
                "All Vehicles",
                style: TextStyle(color: Colors.black, fontSize: 24),
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
                                newData = allVehicles
                                    .where((element) => element.isInCampus)
                                    .toList();

                                break;
                              case 'Expired':
                                newData = allVehicles
                                    .where((element) =>
                                        DateTime.parse(element.expires)
                                                    .compareTo(DateTime.now()) >
                                                0
                                            ? false
                                            : true)
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
          DateFormat("dd/MM hh:mm aa").format(DateTime.parse(vehicle.expires)),
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
        DataCell(Text(row.expires)),
        DataCell(Text(row.status)),
        // DataCell(row.action),
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
