import 'package:CampusCar/constants/colors.dart';
import 'package:CampusCar/widgets/custom_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DownloadDialogContent extends StatelessWidget {
  final downloadCsvHandler;
  final downloadPdfHandler;
  DownloadDialogContent(
      {@required this.downloadCsvHandler, @required this.downloadPdfHandler});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 125,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                downloadCsvHandler();
              },
              child: CustomIconButton(
                icon: FaIcon(
                  FontAwesomeIcons.fileCsv,
                  color: Colors.white,
                  size: 26,
                ),
                bgColor: primaryBlue,
                text: "Csv",
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                downloadPdfHandler();
              },
              child: CustomIconButton(
                icon: FaIcon(
                  FontAwesomeIcons.filePdf,
                  color: Colors.white,
                  size: 26,
                ),
                bgColor: primaryBlue,
                text: "Pdf",
              ),
            )
          ],
        ),
      ),
    );
  }
}
