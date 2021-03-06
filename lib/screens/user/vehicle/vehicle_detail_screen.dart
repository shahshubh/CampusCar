import 'package:CampusCar/constants/constants.dart';
import 'package:CampusCar/models/vehicle.dart';
import 'package:CampusCar/screens/user/vehicle/widgets/profile_header.dart';
import 'package:CampusCar/screens/user/vehicle/widgets/vehicle_info.dart';
import 'package:CampusCar/screens/user/vehicle/widgets/vehicle_info_error.dart';
import 'package:CampusCar/service/firebase_service.dart';
import 'package:flutter/material.dart';

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
                : VehicleInfoError(
                    isLoading: isLoading,
                    findVehicleHandler: findVehicleHandler,
                    errorMsg: stateErrorMsg),
          ],
        ),
      ),
    );
  }
}

// class Avatar extends StatelessWidget {
//   final String imageUrl;
//   final Color borderColor;
//   final Color backgroundColor;
//   final double radius;
//   final double borderWidth;

//   const Avatar(
//       {Key key,
//       @required this.imageUrl,
//       this.borderColor = Colors.white,
//       this.backgroundColor = Colors.grey,
//       this.radius = 40,
//       this.borderWidth = 4.0})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return CircleAvatar(
//       radius: radius,
//       backgroundColor: Colors.grey[100],
//       child: Lottie.asset(
//         imageUrl,
//         // repeat: false,
//       ),
//     );
//   }
// }
