import 'dart:math';

import 'package:CampusCar/widgets/custom_input_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class NewVehicleForm extends StatelessWidget {
  final bool isAdmin;
  final TextEditingController nameTextController;
  final TextEditingController mobileTextController;
  final TextEditingController licenseTextController;
  final TextEditingController modelTextController;
  final TextEditingController roleTextController;
  final String role;
  final Map<String, String> errorText;
  final bool profileImageCheckbox;
  final DateTime expiryDate;
  final Function setExpiryDate;
  final Function setRole;
  final Function setErrorText;
  final Function setProfileImageCheckbox;
  final Function setPickedImage;
  NewVehicleForm({
    @required this.isAdmin,
    @required this.nameTextController,
    @required this.mobileTextController,
    @required this.licenseTextController,
    @required this.modelTextController,
    @required this.roleTextController,
    @required this.role,
    @required this.errorText,
    @required this.profileImageCheckbox,
    @required this.expiryDate,
    @required this.setExpiryDate,
    @required this.setErrorText,
    @required this.setProfileImageCheckbox,
    @required this.setRole,
    @required this.setPickedImage,
  });

  final picker = ImagePicker();

  void getImage({String source}) async {
    ImageSource imageSource = ImageSource.camera;
    var pickedFile = await picker.getImage(source: imageSource);
    if (pickedFile != null) {
      setPickedImage(pickedFile);
    }
  }

  void selectDate(context) async {
    if (isAdmin) {
      final DateTime newDate = await showDatePicker(
        context: context,
        initialDate: expiryDate,
        firstDate: DateTime(2019, 1),
        lastDate: DateTime(2030, 7),
        helpText: 'Select a date',
      );
      if (newDate != null) {
        setExpiryDate(newDate);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomInputField(
          controller: nameTextController,
          labelText: "Name",
          errorText: errorText["name"] != "" ? errorText["name"] : null,
        ),
        SizedBox(height: 20),

        CustomInputField(
          controller: mobileTextController,
          labelText: "Mobile No.",
          errorText: errorText["mobile"] != "" ? errorText["mobile"] : null,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 20),

        CustomInputField(
          controller: licenseTextController,
          labelText: "License Plate No.",
          errorText: errorText["name"] != "" ? errorText["name"] : null,
        ),
        SizedBox(height: 20),

        //role
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Role"),
            DropdownButton(
              value: role,
              items: <String>[
                'Visitor',
                'Faculty',
                'Staff',
                'College Fest',
                'Other'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setRole(newValue);
              },
            ),
          ],
        ),
        role == 'Other'
            ? CustomInputField(
                controller: roleTextController,
                labelText: "Role",
                errorText: errorText["name"] != "" ? errorText["name"] : null,
              )
            : Container(),
        SizedBox(height: 20),

        CustomInputField(
          controller: modelTextController,
          labelText: "Model",
          errorText: errorText["name"] != "" ? errorText["name"] : null,
        ),
        SizedBox(height: 20),

        // color
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Color"),
          ],
        ),

        //expires
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Expires"),
            Container(
              child: Row(
                children: [
                  Text(
                    DateFormat("dd, MMMM yyyy hh:mm aa")
                        .format(DateTime.parse(expiryDate.toString())),
                    style:
                        TextStyle(color: isAdmin ? Colors.black : Colors.grey),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.calendar_today,
                      color: isAdmin ? Colors.black : Colors.grey,
                    ),
                    onPressed: () {
                      selectDate(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),

        //profile
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Auto select default profile image"),
            Checkbox(
              onChanged: (value) {
                setProfileImageCheckbox(value);
              },
              value: profileImageCheckbox,
            ),
          ],
        ),
        profileImageCheckbox != true
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Profile Image"),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      getImage();
                    },
                  ),
                ],
              )
            : Container(),
      ],
    );
  }
}
