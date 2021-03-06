import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class ProfileHeader extends StatelessWidget {
  final ImageProvider<dynamic> coverImage;
  final String avatar;
  final String title;
  final String subtitle;
  final List<Widget> actions;
  final String timestamp;

  const ProfileHeader({
    Key key,
    @required this.coverImage,
    @required this.avatar,
    @required this.title,
    this.subtitle,
    this.actions,
    this.timestamp,
  }) : super(key: key);
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
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey[100],
                child: Lottie.asset(
                  avatar,
                  // repeat: false,
                ),
              ),
              // Avatar(
              //   imageUrl: avatar,
              // ),
              title != ""
                  ? Text(
                      title,
                      style: Theme.of(context).textTheme.headline5,
                    )
                  : Container(),
              if (subtitle != null && subtitle != "") ...[
                SizedBox(height: 5.0),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ],
              if (timestamp != null && timestamp != "") ...[
                SizedBox(height: 5.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.access_time, size: 20),
                    SizedBox(width: 2.0),
                    Text(
                      DateFormat("hh:mm aa").format(DateTime.parse(timestamp)),
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ],
                )
              ]
            ],
          ),
        )
      ],
    );
  }
}
