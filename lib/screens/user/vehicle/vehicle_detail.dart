import 'package:CampusCar/constants/colors.dart';
import 'package:CampusCar/constants/constants.dart';
import 'package:CampusCar/models/vehicle.dart';
import 'package:CampusCar/service/firebase_service.dart';
import 'package:CampusCar/components/progress_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class VehicleDetail extends StatefulWidget {
  final bool isAllowed;
  final bool isExpired;
  final bool success;
  final String errorMsg;
  final Vehicle vehicle;

  VehicleDetail({
    @required this.vehicle,
    @required this.isAllowed,
    @required this.success,
    this.isExpired,
    this.errorMsg,
  });

  @override
  _VehicleDetailState createState() => _VehicleDetailState();
}

class _VehicleDetailState extends State<VehicleDetail> {
  var stateSuccess, stateErrorMsg, stateIsAllowed, stateIsExpired;
  bool isLoading = false;
  Vehicle stateVehicle;
  FirebaseService firebaseService = new FirebaseService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    stateSuccess = widget.success;
    stateVehicle = widget.vehicle;
    stateIsAllowed = widget.isAllowed;
    stateErrorMsg = widget.errorMsg;
    stateIsExpired = widget.isExpired;
  }

  void findVehicleHandler({String licensePlate}) async {
    setState(() {
      isLoading = true;
    });
    print("Find Vehicle Handler");
    print(licensePlate);
    var isExpired = false;
    Vehicle foundVehicle =
        await firebaseService.getVehicle(licensePlateNo: licensePlate);
    if (foundVehicle != null) {
      if (!isExpired) {
        // add logs
      }
      setState(() {
        isLoading = false;
        stateSuccess = true;
        stateIsExpired = isExpired;
        stateIsAllowed = !isExpired;
        stateVehicle = foundVehicle;
      });
    } else {
      setState(() {
        isLoading = false;
        stateErrorMsg = "Again, No vehicle found with that license number.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String markIcon = stateIsAllowed ? checkmarkAnim : crossmarkAnim;

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
              coverImage: NetworkImage(stateVehicle != null
                  ? stateVehicle.profileImage != null
                      ? stateVehicle.profileImage
                      : defaultProfileImageUrl
                  : defaultProfileImageUrl),
              title: stateVehicle != null ? stateVehicle.ownerName : "",
              subtitle: stateVehicle != null ? stateVehicle.licensePlateNo : "",
            ),
            const SizedBox(height: 10.0),
            stateSuccess
                ? VehicleInfo(
                    vehicle: stateVehicle,
                    isExpired: stateIsExpired,
                  )
                : ErrorVehicleInfo(
                    isLoading: isLoading,
                    findVehicleHandler: findVehicleHandler,
                    errorMsg: stateErrorMsg),
          ],
        ),
      ),
    );
  }
}

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

class ErrorVehicleInfo extends StatelessWidget {
  final String errorMsg;
  final bool isLoading;
  final Function findVehicleHandler;
  ErrorVehicleInfo({
    this.errorMsg,
    this.findVehicleHandler,
    this.isLoading,
  });

  final TextEditingController textEditingController =
      new TextEditingController();

  void searchBtnHandler(context) {
    print(textEditingController.text);
    if (textEditingController.text != "" &&
        textEditingController.text != null) {
      findVehicleHandler(
          licensePlate: textEditingController.text.toUpperCase());
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Input field cannot be empty !!"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.red[100],
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              errorMsg,
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
          SizedBox(
            height: 45,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Material(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  child: TextField(
                    controller: textEditingController,
                    cursorColor: primaryBlue,
                    decoration: InputDecoration(
                      hintText: "Enter License Plate No. ",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          borderSide: BorderSide(
                            width: 1,
                          )),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        borderSide: BorderSide(
                          width: 1,
                          color: primaryBlue,
                        ),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 13),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                width: MediaQuery.of(context).size.width * 0.9,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: FlatButton(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    color: primaryBlue,
                    onPressed: () {
                      if (!isLoading) {
                        searchBtnHandler(context);
                      }
                    },
                    child: isLoading
                        ? circularprogress()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Search",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.search,
                                color: Colors.white,
                              )
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),
        ],
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
              title != ""
                  ? Text(
                      title,
                      style: Theme.of(context).textTheme.headline5,
                    )
                  : Container(),
              if (subtitle != null && subtitle != "") ...[
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
      child: Lottie.asset(
        imageUrl,
        // repeat: false,
      ),
    );
  }
}
