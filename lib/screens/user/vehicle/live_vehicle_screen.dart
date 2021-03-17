import 'dart:async';
import 'package:CampusCar/components/progress_widget.dart';
import 'package:CampusCar/constants/colors.dart';
import 'package:CampusCar/constants/constants.dart';
import 'package:CampusCar/locator.dart';
import 'package:CampusCar/models/vehicle.dart';
import 'package:CampusCar/screens/user/vehicle/widgets/no_vehicles.dart';
import 'package:CampusCar/screens/user/vehicle/widgets/profile_header.dart';
import 'package:CampusCar/screens/user/vehicle/widgets/vehicle_info.dart';
import 'package:CampusCar/screens/user/vehicle/widgets/vehicle_info_error.dart';
import 'package:CampusCar/service/vehicle_service.dart';
import 'package:CampusCar/widgets/rounded_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LiveVehicle extends StatefulWidget {
  @override
  _LiveVehicleState createState() => _LiveVehicleState();
}

class _LiveVehicleState extends State<LiveVehicle> {
  CollectionReference livevehicles =
      FirebaseFirestore.instance.collection('livevehicles');
  bool isLoading;
  var vehicleService = locator<VehicleService>();

  Timer timer;
  Color appBarIconColor;
  @override
  void initState() {
    super.initState();
    isLoading = false;
    appBarIconColor = Colors.white;
    // timer = Timer.periodic(Duration(seconds: 10), (timer) {
    //   // check if any live vehicles there
    //   // if true
    //   // delete the first doc i.e. the vehicle which is ahead in the queue.
    //   print("DELETE DATA");
    // });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer?.cancel();
    super.dispose();
  }

  void findVehicleHandler({String licensePlate, String timestamp}) async {
    setState(() {
      isLoading = true;
    });
    Vehicle foundVehicle =
        await vehicleService.getVehicle(licensePlateNo: licensePlate);
    if (foundVehicle != null) {
      var isExpired =
          DateTime.parse(foundVehicle.expires).compareTo(DateTime.now()) > 0
              ? false
              : true;
      if (!isExpired) {
        // add logs
      }

      livevehicles.doc(timestamp).update({
        "vehicle": foundVehicle.toMap(),
        "success": true,
        "isExpired": isExpired,
        "isAllowed": !isExpired,
      });
    } else {
      // setState(() {
      //   isLoading = false;
      //   // stateErrorMsg = "Again, No vehicle found with that license number.";
      // });
      livevehicles.doc(timestamp).update({
        "errorMsg": "Again, No vehicle found with that license number.",
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("RENDERED");
    return Scaffold(
      // backgroundColor: Colors.grey.shade100,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // iconTheme: IconThemeData(
        //   color: appBarIconColor,
        // ),
        actions: [
          GestureDetector(
            onTap: () {
              vehicleService.deleteTopmostLiveVehicle();
              Fluttertoast.showToast(msg: "Deleted");
            },
            child: Container(
              color: Colors.transparent,
              child: Padding(
                padding: EdgeInsets.fromLTRB(40, 20, 20, 20),
                child: FaIcon(
                  FontAwesomeIcons.trash,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: vehicleService.liveVehiclesStream(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: circularprogress(color: Colors.black),
            );
          }
          if (snapshot.hasData && snapshot.data.docs.length > 0) {
            var data = snapshot.data.docs[0].data();
            Vehicle vehicle;
            if (data["vehicle"] != null) {
              vehicle = Vehicle.fromMap(data["vehicle"]);
            }

            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  ProfileHeader(
                    avatar: data["isAllowed"] ? checkmarkAnim : crossmarkAnim,
                    coverImage: NetworkImage(vehicle != null
                        ? vehicle.profileImage != null
                            ? vehicle.profileImage
                            : defaultProfileImageUrl
                        : defaultProfileImageUrl),
                    title: vehicle != null ? vehicle.ownerName : "",
                    subtitle: vehicle != null ? vehicle.licensePlateNo : "",
                    timestamp: data["timestamp"],
                  ),
                  const SizedBox(height: 10.0),
                  data["success"]
                      ? VehicleInfo(
                          vehicle: vehicle,
                          isExpired: data["isExpired"],
                        )
                      : VehicleInfoError(
                          isLoading: isLoading,
                          findVehicleHandler: findVehicleHandler,
                          errorMsg: data["errorMsg"],
                          timestamp: data["timestamp"],
                        ),
                ],
              ),
            );
          } else {
            return NoVehicles();
          }
        },
      ),
    );
  }
}
