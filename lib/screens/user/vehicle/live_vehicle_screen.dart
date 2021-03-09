import 'dart:async';
import 'package:CampusCar/constants/colors.dart';
import 'package:CampusCar/constants/constants.dart';
import 'package:CampusCar/locator.dart';
import 'package:CampusCar/models/vehicle.dart';
import 'package:CampusCar/screens/user/vehicle/widgets/profile_header.dart';
import 'package:CampusCar/screens/user/vehicle/widgets/vehicle_info.dart';
import 'package:CampusCar/screens/user/vehicle/widgets/vehicle_info_error.dart';
import 'package:CampusCar/service/vehicles_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LiveVehicle extends StatefulWidget {
  @override
  _LiveVehicleState createState() => _LiveVehicleState();
}

class _LiveVehicleState extends State<LiveVehicle> {
  // var vehiclesService = locator<VehicleService>();

  CollectionReference livevehicles =
      FirebaseFirestore.instance.collection('livevehicles');
  bool isLoading = false;
  VehicleService vehicleService = new VehicleService();
  Timer timer;
  Color appBarIconColor;
  @override
  void initState() {
    super.initState();
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

  void setAppBarIconColor(Color color) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        appBarIconColor = color;
      });
    });
  }

  void findVehicleHandler({String licensePlate, String timestamp}) async {
    setState(() {
      isLoading = true;
    });
    print(licensePlate);
    var isExpired = false;
    Vehicle foundVehicle =
        await vehicleService.getVehicle(licensePlateNo: licensePlate);
    if (foundVehicle != null) {
      if (!isExpired) {
        // add logs
      }
      setState(() {
        isLoading = false;
      });
      livevehicles.doc(timestamp).update({
        "vehicle": foundVehicle.toMap(),
        "success": true,
        "isExpired": isExpired,
        "isAllowed": !isExpired,
      });
    } else {
      setState(() {
        isLoading = false;
        // stateErrorMsg = "Again, No vehicle found with that license number.";
      });
      livevehicles.doc(timestamp).update({
        "errorMsg": "Again, No vehicle found with that license number.",
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey.shade100,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: appBarIconColor,
        ),
        actions: [
          GestureDetector(
            onTap: () {
              vehicleService.deleteTopmostLiveVehicle();
            },
            child: Padding(
              padding: EdgeInsets.all(12),
              child: FaIcon(
                FontAwesomeIcons.times,
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream:
            livevehicles.orderBy("timestamp", descending: false).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          // if (snapshot.connectionState == ConnectionState.waiting) {
          //   return Center(
          //     child: Text("Loading.."),
          //   );
          // }
          if (snapshot.hasData && snapshot.data.docs.length > 0) {
            setAppBarIconColor(Colors.white);
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
            setAppBarIconColor(Colors.black);
            return Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "No Vehicles at the Gate",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  Stack(
                    children: [
                      Image.asset(
                        'assets/images/Warning-rafiki.png',
                      ),
                      Image.asset(
                        'assets/images/driver-pana.png',
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
