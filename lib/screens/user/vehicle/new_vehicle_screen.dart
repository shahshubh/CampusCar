import 'package:CampusCar/constants/colors.dart';
import 'package:CampusCar/models/vehicle.dart';
import 'package:CampusCar/widgets/custom_input_field.dart';
import 'package:CampusCar/widgets/my_drawer.dart';
import 'package:CampusCar/widgets/new_vehicle_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NewVehicle extends StatefulWidget {
  final Function currentScreenHandler;
  NewVehicle({@required this.currentScreenHandler});
  @override
  _NewVehicleState createState() => _NewVehicleState();
}

class _NewVehicleState extends State<NewVehicle> {
  TextEditingController nameTextController = TextEditingController();
  TextEditingController mobileTextController = TextEditingController();
  TextEditingController licenseTextController = TextEditingController();
  TextEditingController modelTextController = TextEditingController();
  TextEditingController roleTextController = TextEditingController();
  String role = "Visitor";
  Map<String, String> errorText = {"name": ""};
  bool profileImageCheckbox = true;
  var pickedImage;

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

  setErrorText(data) => setState(() {
        errorText = data;
      });

  setProfileImageCheckbox(data) => setState(() {
        profileImageCheckbox = data;
      });

  setPickedImage(data) => setState(() {
        pickedImage = data;
      });

  addVehicleHandler() {
    Vehicle newVehicle = Vehicle(
      ownerName: nameTextController.text,
      licensePlateNo: licenseTextController.text,
      ownerMobileNo: mobileTextController.text,
      model: modelTextController.text,
      role: role == 'Other' ? roleTextController.text : role,
      expires: expiryDate.toString(),
      profileImage: profileImageCheckbox ? "Default Image" : "Selected Image",
      color: "#color",
      isInCampus: true,
    );
    print(newVehicle.toMap());
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
      child: Container(
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
                errorText: errorText,
                profileImageCheckbox: profileImageCheckbox,
                expiryDate: expiryDate,
                setErrorText: setErrorText,
                setExpiryDate: setExpiryDate,
                setProfileImageCheckbox: setProfileImageCheckbox,
                setRole: setRole,
                setPickedImage: setPickedImage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
