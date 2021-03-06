import 'package:CampusCar/models/vehicle.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

class VehicleInfo extends StatelessWidget {
  final bool isExpired;
  final Vehicle vehicle;
  VehicleInfo({this.isExpired, this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
            alignment: Alignment.topLeft,
            child: Text(
              "Vehicle Information",
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Card(
            child: Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      ...ListTile.divideTiles(
                        color: Colors.grey,
                        tiles: [
                          ListTile(
                            leading: Icon(Icons.phone),
                            title: Text("Phone"),
                            subtitle: Text(vehicle.ownerMobileNo),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.date_range,
                              color: isExpired ? Colors.red : Colors.grey[550],
                            ),
                            title: Text(
                              "Expires",
                              style: TextStyle(
                                  color: isExpired ? Colors.red : Colors.black),
                            ),
                            subtitle: Text(
                              DateFormat("dd MMMM, yyyy")
                                  .format(DateTime.parse(vehicle.expires)),
                              style: TextStyle(
                                  color: isExpired
                                      ? Colors.red
                                      : Colors.grey[550]),
                            ),
                          ),
                          ListTile(
                            leading: Icon(Icons.person),
                            title: Text("Role"),
                            subtitle: Text(vehicle.role),
                          ),
                          ListTile(
                            leading: FaIcon(
                              FontAwesomeIcons.car,
                            ),
                            title: Text("Model"),
                            subtitle: Text(vehicle.model),
                          ),
                          ListTile(
                            leading: Icon(Icons.color_lens),
                            title: Text("Color"),
                            // subtitle: Text("#455566"),
                            subtitle: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: HexColor(vehicle.color),
                                  ),
                                  height: 20,
                                  width: 20,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(vehicle.color),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
