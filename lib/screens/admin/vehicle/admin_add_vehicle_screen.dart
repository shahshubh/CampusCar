// AdminAddVehicleScreen
import 'dart:io';

import 'package:CampusCar/constants/colors.dart';
import 'package:CampusCar/constants/constants.dart';
import 'package:CampusCar/locator.dart';
import 'package:CampusCar/models/vehicle.dart';
import 'package:CampusCar/service/vehicle_service.dart';
import 'package:CampusCar/utils/utils.dart';
import 'package:CampusCar/widgets/my_drawer.dart';
import 'package:CampusCar/widgets/new_vehicle_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:CampusCar/widgets/loading_screen.dart';

class AdminAddVehicleScreen extends StatefulWidget {
  final Function currentScreenHandler;
  AdminAddVehicleScreen({@required this.currentScreenHandler});
  @override
  _AdminAddVehicleScreenState createState() => _AdminAddVehicleScreenState();
}

class _AdminAddVehicleScreenState extends State<AdminAddVehicleScreen> {
  var vehicleService = locator<VehicleService>();

  TextEditingController nameTextController = TextEditingController();
  TextEditingController mobileTextController = TextEditingController();
  TextEditingController licenseTextController = TextEditingController();
  TextEditingController modelTextController = TextEditingController();
  TextEditingController roleTextController = TextEditingController();
  String role = "Visitor";
  bool profileImageCheckbox = true;
  var pickedImage;
  Color color = Colors.red;
  bool isLoading = false;

  static DateTime currDate = DateTime.now();
  DateTime expiryDate = currDate
      .subtract(Duration(
        hours: currDate.hour,
        minutes: currDate.minute,
        seconds: currDate.second,
        milliseconds: currDate.millisecond,
        microseconds: currDate.microsecond,
      ))
      .add(Duration(days: 1));

  setExpiryDate(data) => setState(() {
        expiryDate = data;
      });

  setRole(data) => setState(() {
        role = data;
      });

  setProfileImageCheckbox(data) => setState(() {
        profileImageCheckbox = data;
      });

  setPickedImage(data) => setState(() {
        pickedImage = data;
      });

  setColor(data) => setState(() {
        color = data;
      });

  void clearFormHandler() {
    setState(() {
      nameTextController.text = "";
      mobileTextController.text = "";
      licenseTextController.text = "";
      modelTextController.text = "";
      roleTextController.text = "";
      role = "Visitor";
      profileImageCheckbox = true;
      pickedImage = null;
      color = Colors.red;
    });
  }

  bool newVehicleFormValidator() {
    if (nameTextController.text.isEmpty) {
      Utils.showFlashMsg(
        context: context,
        message: "Name is required field.",
        color: errorColor,
      );
      return false;
    } else if (mobileTextController.text.isEmpty ||
        mobileTextController.text.length != 10) {
      Utils.showFlashMsg(
        context: context,
        message: "Please enter valid Mobile Number.",
        color: errorColor,
      );
      return false;
    } else if (licenseTextController.text.isEmpty ||
        licenseTextController.text.length <= 4) {
      Utils.showFlashMsg(
        context: context,
        message: "Please enter valid License Plate.",
        color: errorColor,
      );
      return false;
    } else if (modelTextController.text.isEmpty) {
      Utils.showFlashMsg(
        context: context,
        message: "Model is required field.",
        color: errorColor,
      );
      return false;
    } else if (role == 'Other' && roleTextController.text.isEmpty) {
      Utils.showFlashMsg(
        context: context,
        message: "Role is required field.",
        color: errorColor,
      );
      return false;
    } else if (color == null) {
      Utils.showFlashMsg(
        context: context,
        message: "Color is required.",
        color: errorColor,
      );
      return false;
    } else if (!profileImageCheckbox && pickedImage == null) {
      Utils.showFlashMsg(
        context: context,
        message:
            "Please click a picture or select the checkbox for default profile pic.",
        color: errorColor,
      );
      return false;
    }
    return true;
  }

  addVehicleHandler() async {
    String numberPlate = licenseTextController.text.toUpperCase();
    if (newVehicleFormValidator()) {
      setState(() {
        isLoading = true;
      });

      // check is already any vehicle is there with this license plate
      var foundVehicle =
          await vehicleService.getVehicle(licensePlateNo: numberPlate);
      if (foundVehicle != null) {
        Utils.showFlashMsg(
          context: context,
          color: errorColor,
          message:
              'Vehicle with license plate no. $numberPlate is already registered.',
        );
        setState(() {
          isLoading = false;
        });
        return;
      }

      // upload profile image to firebase storage if checkbox is NOT checked.
      String profileImageUrl = defaultProfileImageUrl;
      if (!profileImageCheckbox) {
        String res = await vehicleService.uploadImageToFirestoreAndStorage(
            File(pickedImage.path), numberPlate);
        if (res == 'Error') {
          Utils.showFlashMsg(
              context: context,
              color: errorColor,
              message:
                  'Some error while uploading image. Using default image for profile.');
        } else {
          profileImageUrl = res;
        }
      }

      Vehicle newVehicle = Vehicle(
        ownerName: nameTextController.text,
        licensePlateNo: licenseTextController.text.toUpperCase(),
        ownerMobileNo: mobileTextController.text,
        model: modelTextController.text,
        role: role == 'Other' ? roleTextController.text : role,
        expires: expiryDate.toString(),
        profileImage: profileImageUrl,
        color: '#${color.value.toRadixString(16)}',
        isInCampus: false,
      );

      try {
        // add vehicle to firebase
        await vehicleService.addVehicle(vehicle: newVehicle);
        Utils.showFlashMsg(
          context: context,
          message: 'Successfully added vehicle - ${newVehicle.licensePlateNo}.',
          color: successColor,
        );

        // add log of the vehicle
        await vehicleService.addLog(vehicle: newVehicle);
        clearFormHandler();
      } catch (e) {
        print(e);
        Utils.showFlashMsg(
          context: context,
          message: e.toString(),
          color: errorColor,
        );
      }

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyDrawer(
      // rightIcon: IconButton(
      //   icon: FaIcon(FontAwesomeIcons.check),
      //   onPressed: () {
      //     addVehicleHandler();
      //   },
      // ),
      child: isLoading
          ? Container(
              alignment: Alignment.center,
              constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 95),
              child: LoadingScreen(),
            )
          : Container(
              child: Column(
                children: <Widget>[
                  Container(
                    child: Text(
                      "Add New Vehicle",
                      style: TextStyle(color: Colors.black, fontSize: 24),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(20),
                    child: NewVehicleForm(
                      isAdmin: true,
                      nameTextController: nameTextController,
                      licenseTextController: licenseTextController,
                      mobileTextController: mobileTextController,
                      modelTextController: modelTextController,
                      roleTextController: roleTextController,
                      role: role,
                      color: color,
                      pickedImage: pickedImage,
                      profileImageCheckbox: profileImageCheckbox,
                      expiryDate: expiryDate,
                      setExpiryDate: setExpiryDate,
                      setProfileImageCheckbox: setProfileImageCheckbox,
                      setRole: setRole,
                      setPickedImage: setPickedImage,
                      setColor: setColor,
                    ),
                  ),
                  InkWell(
                    onTap: addVehicleHandler,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
                      padding: EdgeInsets.all(20),
                      alignment: Alignment.center,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: primaryBlue,
                      ),
                      child: Text('Add Vehicle',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w300)),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
