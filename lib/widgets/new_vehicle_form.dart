import 'dart:io';
import 'dart:math';

import 'package:CampusCar/constants/colors.dart';
import 'package:CampusCar/widgets/custom_icon_button.dart';
import 'package:CampusCar/widgets/custom_input_field.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  final Function setIsInCampus;

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
    this.setIsInCampus,
  });

  @override
  _NewVehicleFormState createState() => _NewVehicleFormState();
}

class _NewVehicleFormState extends State<NewVehicleForm> {
  final picker = ImagePicker();
  Color tempColor = Colors.red;
  TextStyle labelStyle = TextStyle(fontWeight: FontWeight.w300, fontSize: 16);

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
        "Pick your Car Color",
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
          // colors: [Colors.red, Colors.green, Colors.grey],
          // onBack: () => print("Back button pressed"),
        ),
        context);
  }

  void getImage({@required ImageSource imageSource}) async {
    var pickedFile =
        await picker.getImage(source: imageSource, imageQuality: 50);
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
            Text("Role", style: labelStyle),
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
            Text("Color", style: labelStyle),
            CircleColor(
              circleSize: 30.0,
              color: widget.color,
              onColorChoose: () {
                _openColorPicker(context);
              },
            ),
          ],
        ),
        SizedBox(height: 20),

        //expires
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Expires", style: labelStyle),
            Container(
              child: Row(
                children: [
                  Text(
                    DateFormat("dd, MMMM yyyy hh:mm aa")
                        .format(DateTime.parse(widget.expiryDate.toString())),
                    style: TextStyle(
                        color: widget.isAdmin ? Colors.black : Colors.grey),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                    child: InkWell(
                      child: Icon(
                        Icons.calendar_today,
                        color: widget.isAdmin ? Colors.black : Colors.grey,
                      ),
                      onTap: () {
                        selectDate(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 20),

        //Is in campus
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Is inside campus ?", style: labelStyle),
            Switch(
              value: false,
              activeColor: primaryBlue,
              onChanged: (bool value) {
                widget.setIsInCampus(value);
              },
            ),
          ],
        ),
        SizedBox(height: 20),

        //profile
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Auto select default profile image", style: labelStyle),
            CircularCheckBox(
              materialTapTargetSize: MaterialTapTargetSize.padded,
              activeColor: primaryBlue,
              onChanged: (value) {
                widget.setProfileImageCheckbox(value);
              },
              value: widget.profileImageCheckbox,
            ),
          ],
        ),
        widget.profileImageCheckbox != true && widget.pickedImage != null
            ? Container(
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(15),
                ),
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Stack(
                    fit: StackFit.passthrough,
                    children: [
                      Image.file(
                        File(widget.pickedImage.path),
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        right: 0,
                        child: IconButton(
                          icon: FaIcon(
                            FontAwesomeIcons.times,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            widget.setPickedImage(null);
                          },
                        ),
                      )
                    ],
                  ),
                ),
              )
            : Container(),
        widget.profileImageCheckbox != true
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Profile Image", style: labelStyle),
                  IconButton(
                    icon: FaIcon(FontAwesomeIcons.image, size: 28),
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              height: 125,
                              // color: lightBlue,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  // mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                        getImage(
                                            imageSource: ImageSource.camera);
                                      },
                                      child: CustomIconButton(
                                        icon: FaIcon(
                                          FontAwesomeIcons.camera,
                                          color: Colors.white,
                                          size: 26,
                                        ),
                                        bgColor: primaryBlue,
                                        text: "Camera",
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                        getImage(
                                            imageSource: ImageSource.gallery);
                                      },
                                      child: CustomIconButton(
                                        icon: FaIcon(
                                          FontAwesomeIcons.images,
                                          color: Colors.white,
                                          size: 26,
                                        ),
                                        bgColor: primaryBlue,
                                        text: "Gallery",
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                  ),
                ],
              )
            : Container(),
      ],
    );
  }
}
