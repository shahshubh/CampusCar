import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

circularprogress({Color color = Colors.white}) {
  return SizedBox(
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(color),
    ),
    height: 30.0,
    width: 30.0,
  );
}

linearprogress() {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 12.0),
    child: LinearProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.lightBlueAccent),
    ),
  );
}
