import 'package:CampusCar/constants/constants.dart';
import 'package:CampusCar/models/vehicle.dart';
import 'package:CampusCar/screens/user/vehicle/widgets/profile_header.dart';
import 'package:CampusCar/widgets/vehicle_info.dart';
import 'package:CampusCar/screens/user/vehicle/widgets/vehicle_info_error.dart';
import 'package:CampusCar/service/vehicle_service.dart';
import 'package:flutter/material.dart';
import 'package:CampusCar/locator.dart';

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
  var vehicleService = locator<VehicleService>();
  var stateSuccess, stateErrorMsg, stateIsAllowed, stateIsExpired;
  bool isLoading = false;
  Vehicle stateVehicle;

  @override
  void initState() {
    super.initState();
    stateSuccess = widget.success;
    stateVehicle = widget.vehicle;
    stateIsAllowed = widget.isAllowed;
    stateErrorMsg = widget.errorMsg;
    stateIsExpired = widget.isExpired;
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
        await vehicleService.addLog(vehicle: foundVehicle);
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
