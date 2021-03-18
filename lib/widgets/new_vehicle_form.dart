import 'dart:io';
import 'dart:math';

import 'package:CampusCar/widgets/custom_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class NewVehicleForm extends StatefulWidget {
  final bool isAdmin;
  final TextEditingController nameTextController;
  final TextEditingController mobileTextController;
  final TextEditingController licenseTextController;
  final TextEditingController modelTextController;
  final TextEditingController roleTextController;
  final String role;
  final Color color;
  final pickedImage;
  final bool profileImageCheckbox;
  final DateTime expiryDate;
  final Function setExpiryDate;
  final Function setRole;
  final Function setProfileImageCheckbox;
  final Function setPickedImage;
  final Function setColor;
  NewVehicleForm({
    @required this.isAdmin,
    @required this.nameTextController,
    @required this.mobileTextController,
    @required this.licenseTextController,
    @required this.modelTextController,
    @required this.roleTextController,
    @required this.role,
    @required this.color,
    @required this.pickedImage,
    @required this.profileImageCheckbox,
    @required this.expiryDate,
    @required this.setExpiryDate,
    @required this.setProfileImageCheckbox,
    @required this.setRole,
    @required this.setPickedImage,
    @required this.setColor,
  });

  @override
  _NewVehicleFormState createState() => _NewVehicleFormState();
}

class _NewVehicleFormState extends State<NewVehicleForm> {
  final picker = ImagePicker();
  Color tempColor = Colors.red;

  void _openDialog(String title, Widget content, context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(6.0),
          title: Text(title),
          content: content,
          actions: [
            FlatButton(
              child: Text('CANCEL'),
              onPressed: Navigator.of(context).pop,
            ),
            FlatButton(
              child: Text('SUBMIT'),
              onPressed: () {
                widget.setColor(tempColor);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _openColorPicker(context) async {
    _openDialog(
        "Color picker",
        MaterialColorPicker(
          // allowShades: false,
          selectedColor: widget.color,
          onColorChange: (color) {
            print(color);
            setState(() {
              tempColor = color;
            });
          },
          // onMainColorChange: (color) => print(color),
          colors: [Colors.red, Colors.green],
          // onBack: () => print("Back button pressed"),
        ),
        context);
  }

  void getImage({String source}) async {
    ImageSource imageSource = ImageSource.camera;
    var pickedFile = await picker.getImage(source: imageSource);
    if (pickedFile != null) {
      widget.setPickedImage(pickedFile);
    }
  }

  void selectDate(context) async {
    if (widget.isAdmin) {
      final DateTime newDate = await showDatePicker(
        context: context,
        initialDate: widget.expiryDate,
        firstDate: DateTime(2019, 1),
        lastDate: DateTime(2030, 7),
        helpText: 'Select a date',
      );
      if (newDate != null) {
        widget.setExpiryDate(newDate);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomInputField(
          controller: widget.nameTextController,
          labelText: "Name",
        ),
        SizedBox(height: 20),

        CustomInputField(
          controller: widget.mobileTextController,
          labelText: "Mobile No.",
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 20),

        CustomInputField(
          controller: widget.licenseTextController,
          labelText: "License Plate No.",
        ),
        SizedBox(height: 20),

        //role
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Role"),
            DropdownButton(
              value: widget.role,
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
                widget.setRole(newValue);
              },
            ),
          ],
        ),
        widget.role == 'Other'
            ? CustomInputField(
                controller: widget.roleTextController,
                labelText: "Role",
              )
            : Container(),
        SizedBox(height: 20),

        CustomInputField(
          controller: widget.modelTextController,
          labelText: "Model",
        ),
        SizedBox(height: 20),

        // color
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Color"),
            CircleColor(
              circleSize: 25.0,
              color: widget.color,
              onColorChoose: () {
                _openColorPicker(context);
              },
            ),
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
                        .format(DateTime.parse(widget.expiryDate.toString())),
                    style: TextStyle(
                        color: widget.isAdmin ? Colors.black : Colors.grey),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.calendar_today,
                      color: widget.isAdmin ? Colors.black : Colors.grey,
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
                widget.setProfileImageCheckbox(value);
              },
              value: widget.profileImageCheckbox,
            ),
          ],
        ),
        widget.profileImageCheckbox != true
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

        widget.profileImageCheckbox != true && widget.pickedImage != null
            ? Container(
                child: Image.file(
                  File(widget.pickedImage.path),
                  height: 100,
                ),
              )
            : Container(),
      ],
    );
  }
}
