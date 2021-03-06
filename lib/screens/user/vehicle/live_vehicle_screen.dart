import 'package:CampusCar/constants/constants.dart';
import 'package:CampusCar/models/vehicle.dart';
import 'package:CampusCar/screens/user/vehicle/widgets/profile_header.dart';
import 'package:CampusCar/screens/user/vehicle/widgets/vehicle_info.dart';
import 'package:CampusCar/screens/user/vehicle/widgets/vehicle_info_error.dart';
import 'package:CampusCar/service/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LiveVehicle extends StatefulWidget {
  @override
  _LiveVehicleState createState() => _LiveVehicleState();
}

class _LiveVehicleState extends State<LiveVehicle> {
  CollectionReference livevehicles =
      FirebaseFirestore.instance.collection('livevehicles');
  bool isLoading = false;
  FirebaseService firebaseService = new FirebaseService();

  void findVehicleHandler({String licensePlate, String timestamp}) async {
    setState(() {
      isLoading = true;
    });
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
        // iconTheme: IconThemeData(
        //   color: Colors.black, //change your color here
        // ),
        // title: Text(
        //   "Live",
        //   style: TextStyle(color: Colors.black),
        // ),
        // centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              FirebaseFirestore.instance
                  .collection("livevehicles")
                  .orderBy("timestamp", descending: false)
                  .limit(1)
                  .get()
                  .then((snapshot) {
                for (DocumentSnapshot doc in snapshot.docs) {
                  doc.reference.delete();
                }
              });
            },
            child: Padding(
              padding: EdgeInsets.all(12),
              child: FaIcon(FontAwesomeIcons.times),
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
            return Center(
              child: Text("No DATA"),
            );
          }
          // return ListView(
          //     children: snapshot.data.docs.map((DocumentSnapshot document) {
          //       return new ListTile(
          //         title: new Text(document.data()['name']),
          //         subtitle: new Text(document.data()['timestamp']),
          //       );
          //     }).toList(),
          //   );
        },
      ),
    );
  }
}
