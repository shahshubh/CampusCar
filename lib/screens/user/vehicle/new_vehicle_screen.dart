import 'dart:io';

import 'package:CampusCar/constants/colors.dart';
import 'package:CampusCar/constants/constants.dart';
import 'package:CampusCar/locator.dart';
import 'package:CampusCar/models/vehicle.dart';
import 'package:CampusCar/service/vehicle_service.dart';
import 'package:CampusCar/utils/utils.dart';
import 'package:CampusCar/widgets/custom_input_field.dart';
import 'package:CampusCar/widgets/my_drawer.dart';
import 'package:CampusCar/widgets/new_vehicle_form.dart';
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:CampusCar/widgets/loading_screen.dart';


class NewVehicle extends StatefulWidget {
  final Function currentScreenHandler;
  NewVehicle({@required this.currentScreenHandler});
  @override
  _NewVehicleState createState() => _NewVehicleState();
}

class _NewVehicleState extends State<NewVehicle> {
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

  void clearFormHandler(){
    setState((){
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
    
    if (newVehicleFormValidator()) {
      setState((){
        isLoading = true;
      });
      String profileImageUrl = defaultProfileImageUrl;

      // upload profile image to firebase storage.
      if (!profileImageCheckbox) {
        print("Uploading profile pic");
        String res = await vehicleService.uploadImageToFirestoreAndStorage(
            File(pickedImage.path), licenseTextController.text.toUpperCase());
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
        isInCampus: true,
      );

      // add vehicle to firebase
      try {
        vehicleService.addVehicle(vehicle: newVehicle);
        Utils.showFlashMsg(
          context: context,
          message: 'Successfully added vehicle - ${newVehicle.licensePlateNo}.',
          color: successColor,
        );
        clearFormHandler();
      } catch (e) {
        print(e);
        Utils.showFlashMsg(
          context: context,
          message: e.toString(),
          color: errorColor,
        );
      }
      setState((){
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyDrawer(
      rightIcon: IconButton(
        icon: FaIcon(FontAwesomeIcons.check),
        onPressed: () {
          addVehicleHandler();
        },
      ),
      child: isLoading ? Container(
              alignment: Alignment.center,
              constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 95),
              child: LoadingScreen(),
            ) : Container(
        constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 95),
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
                isAdmin: false,
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
            
          ],
        ),
      ),
    );
  }
}
