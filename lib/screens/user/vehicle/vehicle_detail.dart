import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';

const checkmark =
    "https://assets10.lottiefiles.com/private_files/lf30_dCzDJu.json";
const crossmark =
    "https://assets10.lottiefiles.com/private_files/lf30_QYPL9z.json";
const defaultProfileImageUrl =
    "http://s3.amazonaws.com/37assets/svn/765-default-avatar.png";

class VehicleDetail extends StatefulWidget {
  final String numberPlate;
  final String ownerName;
  final String ownerImageUrl;
  final String ownerPhone;
  final String expires;
  final String role;
  final String model;
  final String color;
  final bool isAllowed;
  final bool isExpired;
  final bool success;
  final String errorMsg;

  VehicleDetail({
    this.numberPlate = "",
    this.ownerName = "",
    this.ownerImageUrl,
    this.ownerPhone,
    this.expires,
    this.role,
    this.model,
    this.color,
    @required this.isAllowed,
    this.isExpired,
    @required this.success,
    this.errorMsg,
  });

  @override
  _VehicleDetailState createState() => _VehicleDetailState();
}

class _VehicleDetailState extends State<VehicleDetail> {
  @override
  Widget build(BuildContext context) {
    String markIcon = widget.isAllowed ? checkmark : crossmark;

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
                avatar: markIcon,
                coverImage: NetworkImage(widget.ownerImageUrl != null
                    ? widget.ownerImageUrl
                    : defaultProfileImageUrl),
                title: widget.ownerName,
                subtitle: widget.numberPlate,
              ),
              const SizedBox(height: 10.0),
              widget.success
                  ? VehicleInfo(
                      ownerPhone: widget.ownerPhone,
                      expires: widget.expires,
                      role: widget.role,
                      model: widget.model,
                      color: widget.color,
                      isExpired: widget.isExpired,
                    )
                  : ErrorVehicleInfo(
                      errorMsg: widget.errorMsg,
                    ),
            ],
          ),
        ));
  }
}

class VehicleInfo extends StatelessWidget {
  final String ownerPhone;
  final String expires;
  final String role;
  final String model;
  final String color;
  final bool isExpired;
  VehicleInfo(
      {this.ownerPhone,
      this.expires,
      this.role,
      this.model,
      this.color,
      this.isExpired});

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
                            subtitle: Text(ownerPhone),
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
                              expires,
                              style: TextStyle(
                                  color: isExpired
                                      ? Colors.red
                                      : Colors.grey[550]),
                            ),
                          ),
                          ListTile(
                            leading: Icon(Icons.person),
                            title: Text("Role"),
                            subtitle: Text(role),
                          ),
                          ListTile(
                            leading: FaIcon(
                              FontAwesomeIcons.car,
                            ),
                            title: Text("Model"),
                            subtitle: Text(model),
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
                                    color: Colors.yellow,
                                  ),
                                  height: 20,
                                  width: 20,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(color),
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

class ErrorVehicleInfo extends StatelessWidget {
  final String errorMsg;
  ErrorVehicleInfo({this.errorMsg});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(errorMsg),
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  final ImageProvider<dynamic> coverImage;
  final String avatar;
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
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 160),
          child: Column(
            children: <Widget>[
              Avatar(
                imageUrl: avatar,
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.title,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 5.0),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.subtitle,
                ),
              ]
            ],
          ),
        )
      ],
    );
  }
}

class Avatar extends StatelessWidget {
  final String imageUrl;
  final Color borderColor;
  final Color backgroundColor;
  final double radius;
  final double borderWidth;

  const Avatar(
      {Key key,
      @required this.imageUrl,
      this.borderColor = Colors.white,
      this.backgroundColor = Colors.grey,
      this.radius = 40,
      this.borderWidth = 4.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        radius: radius,
        backgroundColor: Colors.grey[100],
        child: Lottie.network(imageUrl, repeat: false));
  }
}
