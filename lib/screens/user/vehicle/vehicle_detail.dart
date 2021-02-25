import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';

class VehicleDetail extends StatelessWidget {
  final checkmark = "https://assets3.lottiefiles.com/temp/lf20_5tgmik.json";
  final crossmark =
      "https://assets6.lottiefiles.com/private_files/lf30_jq4i7W.json";

  @override
  Widget build(BuildContext context) {
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
                avatar: checkmark,
                coverImage: NetworkImage(
                    "http://s3.amazonaws.com/37assets/svn/765-default-avatar.png"),
                title: "Ramesh Mana",
                subtitle: "MH04AJ8895",
              ),
              const SizedBox(height: 10.0),
              VehicleInfo(),
            ],
          ),
        ));
  }
}

class VehicleInfo extends StatelessWidget {
  final isExpired = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
            alignment: Alignment.topLeft,
            child: Text(
              "Vehicle Information",
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Card(
            child: Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      ...ListTile.divideTiles(
                        color: Colors.grey,
                        tiles: [
                          // ListTile(
                          //   contentPadding: EdgeInsets.symmetric(
                          //       horizontal: 12, vertical: 4),
                          //   leading: Icon(Icons.my_location),
                          //   title: Text("Owner Name"),
                          //   subtitle: Text("Ramesh Mana"),
                          // ),
                          // ListTile(
                          //   leading: Icon(Icons.email),
                          //   title: Text("Email"),
                          //   subtitle: Text("sudeptech@gmail.com"),
                          // ),
                          ListTile(
                            leading: Icon(Icons.phone),
                            title: Text("Phone"),
                            subtitle: Text("99--99876-56"),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.date_range,
                              color: isExpired ? Colors.red : Colors.grey[550],
                            ),
                            title: Text(
                              "Expires",
                              style: TextStyle(
                                  color: isExpired ? Colors.red : Colors.black),
                            ),
                            subtitle: Text(
                              "25th Feb 2022",
                              style: TextStyle(
                                  color: isExpired
                                      ? Colors.red
                                      : Colors.grey[550]),
                            ),
                          ),
                          ListTile(
                            leading: Icon(Icons.person),
                            title: Text("Role"),
                            subtitle: Text("Faculty."),
                          ),
                          ListTile(
                            leading: FaIcon(
                              FontAwesomeIcons.car,
                            ),
                            title: Text("Model"),
                            subtitle: Text("WagonR"),
                          ),
                          ListTile(
                            leading: Icon(Icons.color_lens),
                            title: Text("Color"),
                            // subtitle: Text("#455566"),
                            subtitle: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.yellow,
                                  ),
                                  height: 20,
                                  width: 20,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text("#455566"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  final ImageProvider<dynamic> coverImage;
  final String avatar;
  final String title;
  final String subtitle;
  final List<Widget> actions;

  const ProfileHeader(
      {Key key,
      @required this.coverImage,
      @required this.avatar,
      @required this.title,
      this.subtitle,
      this.actions})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Ink(
          height: 200,
          decoration: BoxDecoration(
            image: DecorationImage(image: coverImage, fit: BoxFit.cover),
          ),
        ),
        Ink(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.black38,
          ),
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 160),
          child: Column(
            children: <Widget>[
              Avatar(
                imageUrl: avatar,
                radius: 40,
                backgroundColor: Colors.white,
                borderColor: Colors.white,
                borderWidth: 4.0,
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.title,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 5.0),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.subtitle,
                ),
              ]
            ],
          ),
        )
      ],
    );
  }
}

class Avatar extends StatelessWidget {
  final String imageUrl;
  final Color borderColor;
  final Color backgroundColor;
  final double radius;
  final double borderWidth;

  const Avatar(
      {Key key,
      @required this.imageUrl,
      this.borderColor = Colors.grey,
      this.backgroundColor,
      this.radius = 30,
      this.borderWidth = 5})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius + borderWidth,
      backgroundColor: borderColor,
      child: CircleAvatar(
          radius: radius,
          backgroundColor: backgroundColor != null
              ? backgroundColor
              : Theme.of(context).primaryColor,
          child: Lottie.network(imageUrl)),
    );
  }
}
