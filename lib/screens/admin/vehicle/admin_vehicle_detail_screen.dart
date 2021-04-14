import 'package:CampusCar/locator.dart';
import 'package:CampusCar/models/log.dart';
import 'package:CampusCar/models/vehicle.dart';
import 'package:CampusCar/screens/admin/vehicle/widgets/avatar.dart';
import 'package:CampusCar/screens/admin/vehicle/widgets/dialog_content.dart';
import 'package:CampusCar/service/admin_service.dart';
import 'package:CampusCar/utils/utils.dart';
import 'package:CampusCar/widgets/vehicle_info.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class AdminVehicleDetailScreen extends StatefulWidget {
  final Vehicle vehicle;
  AdminVehicleDetailScreen({@required this.vehicle});
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
    var allLogs = await adminService.getLogsOfVehicle(
        licensePlate: widget.vehicle.licensePlateNo);
    setState(() {
      data = allLogs;
    });
  }

  void vehicleEditHandler() {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text("Edit Expiry Date"),
        children: [
          DialogContent(
            vehicle: widget.vehicle,
          ),
        ],
      ),
    );
  }

  void showLogs(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Padding(
                        padding: EdgeInsets.all(20),
                        child: FaIcon(FontAwesomeIcons.times)),
                  ),
                ),
                data.length > 0
                    ? PaginatedDataTable(
                        header: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: '${widget.vehicle.licensePlateNo} ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                )),
                            TextSpan(
                                text: ' Logs',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ))
                          ]),
                        ),
                        columns: [
                          DataColumn(label: Text('Time')),
                          DataColumn(label: Text('Direction')),
                        ],
                        source: _DataSource(context, data),
                      )
                    : Center(
                        child: Container(
                          height: MediaQuery.of(context).size.height - 150,
                          child: Text(
                              "No Logs found for ${widget.vehicle.licensePlateNo}"),
                        ),
                      ),
              ],
            ),
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
                avatar: NetworkImage(widget.vehicle.profileImage),
                coverImage: NetworkImage(widget.vehicle.profileImage),
                title: widget.vehicle.ownerName,
                subtitle: widget.vehicle.licensePlateNo,
                actions: <Widget>[
                  MaterialButton(
                    color: Colors.white,
                    shape: CircleBorder(),
                    elevation: 0,
                    child: Icon(Icons.edit),
                    onPressed: vehicleEditHandler,
                  )
                ],
              ),
              const SizedBox(height: 10.0),
              VehicleInfo(
                isAdmin: true,
                showLogs: showLogs,
                isExpired: Utils.isExpired(widget.vehicle.expires),
                vehicle: widget.vehicle,
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
    this.time,
    this.direction,
  );

  final String time;
  final String direction;

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
          DateFormat("dd/MM hh:mm aa").format(DateTime.parse(log.time)),
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
      cells: [
        DataCell(Text(row.time)),
        DataCell(Text(row.direction)),
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
