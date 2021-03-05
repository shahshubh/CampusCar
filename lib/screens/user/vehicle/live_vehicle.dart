import 'package:CampusCar/widgets/my_drawer.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text(
          "Live",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
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
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: StreamBuilder(
        stream:
            livevehicles.orderBy("timestamp", descending: false).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Text("Loading.."),
            );
          }
          if (snapshot.hasData && snapshot.data.docs.length > 0) {
            return ListView(
              children: snapshot.data.docs.map((DocumentSnapshot document) {
                return new ListTile(
                  title: new Text(document.data()['name']),
                  subtitle: new Text(document.data()['timestamp']),
                );
              }).toList(),
            );
          } else {
            return Center(
              child: Text("No DATA"),
            );
          }
        },
      ),
    );
  }
}
