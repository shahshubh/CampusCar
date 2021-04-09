import 'package:CampusCar/locator.dart';
import 'package:CampusCar/models/log.dart';
import 'package:CampusCar/models/vehicle.dart';
import 'package:CampusCar/screens/admin/vehicle/widgets/avatar.dart';
import 'package:CampusCar/service/admin_service.dart';
import 'package:CampusCar/utils/utils.dart';
import 'package:CampusCar/widgets/vehicle_info.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminVehicleDetailScreen extends StatefulWidget {
  @override
  _AdminVehicleDetailScreenState createState() =>
      _AdminVehicleDetailScreenState();
}

class _AdminVehicleDetailScreenState extends State<AdminVehicleDetailScreen> {
  var adminService = locator<AdminService>();
  List<Log> data = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    var allLogs =
        await adminService.getLogsOfVehicle(licensePlate: "MH12DE1433");
    setState(() {
      data = allLogs;
    });
  }

  void showLogs(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: PaginatedDataTable(
            header: Text('Logs'),
            // rowsPerPage: 4,
            columns: [
              DataColumn(label: Text('Vehicle')),
              DataColumn(label: Text('Owner Name')),
              DataColumn(label: Text('Time')),
              DataColumn(label: Text('Direction')),
              DataColumn(label: Text('Action')),
            ],
            source: _DataSource(context, data),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ProfileHeader(
                avatar: NetworkImage(
                    "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/1200px-Image_created_with_a_mobile_phone.png"),
                coverImage: NetworkImage(
                    "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/1200px-Image_created_with_a_mobile_phone.png"),
                title: "Ramesh Mana",
                subtitle: "Manager",
                actions: <Widget>[
                  MaterialButton(
                    color: Colors.white,
                    shape: CircleBorder(),
                    elevation: 0,
                    child: Icon(Icons.edit),
                    onPressed: () {},
                  )
                ],
              ),
              const SizedBox(height: 10.0),
              VehicleInfo(
                isAdmin: true,
                showLogs: showLogs,
                isExpired: true,
                vehicle: Vehicle(
                  licensePlateNo: 'MH12DE1433',
                  color: '#000000',
                  expires: new DateTime.now().toString(),
                  model: 'Ford',
                  ownerMobileNo: '9988786734',
                  ownerName: 'Shubh Shah',
                  profileImage:
                      "https://images.unsplash.com/photo-1511367461989-f85a21fda167?ixid=MXwxMjA3fDB8MHxzZWFyY2h8M3x8cHJvZmlsZXxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&w=1000&q=80",
                  role: "Faculty",
                  isInCampus: false,
                ),
              ),
            ],
          ),
        ));
  }
}

class ProfileHeader extends StatelessWidget {
  final ImageProvider<dynamic> coverImage;
  final ImageProvider<dynamic> avatar;
  final String title;
  final String subtitle;
  final List<Widget> actions;

  const ProfileHeader(
      {Key key,
      @required this.coverImage,
      @required this.avatar,
      @required this.title,
      this.subtitle,
      this.actions})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Ink(
          height: 200,
          decoration: BoxDecoration(
            image: DecorationImage(image: coverImage, fit: BoxFit.cover),
          ),
        ),
        Ink(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.black38,
          ),
        ),
        if (actions != null)
          Container(
            width: double.infinity,
            height: 200,
            padding: const EdgeInsets.only(bottom: 0.0, right: 0.0),
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: actions,
            ),
          ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 160),
          child: Column(
            children: <Widget>[
              Avatar(
                image: avatar,
                radius: 40,
                backgroundColor: Colors.white,
                borderColor: Colors.grey.shade300,
                borderWidth: 4.0,
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.headline5,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 5.0),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ]
            ],
          ),
        )
      ],
    );
  }
}

class _Row {
  _Row(
    this.vehicle,
    this.ownerName,
    this.time,
    this.direction,
    this.action,
  );

  final String vehicle;
  final String ownerName;
  final String time;
  final String direction;
  final Icon action;

  bool selected = false;
}

class _DataSource extends DataTableSource {
  final BuildContext context;
  List<_Row> _rows = [];
  List<Log> data = [];

  _DataSource(this.context, this.data) {
    data.forEach((Log log) {
      _rows.add(
        _Row(
          log.vehicle["licensePlateNo"],
          log.vehicle["ownerName"],
          DateFormat("dd/MM hh:mm aa").format(DateTime.parse(log.time)),
          Utils.numToString(log.direction),
          Icon(Icons.edit),
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
        DataCell(Text(row.vehicle)),
        DataCell(Text(row.ownerName)),
        DataCell(Text(row.time)),
        DataCell(Text(row.direction)),
        DataCell(row.action),
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
