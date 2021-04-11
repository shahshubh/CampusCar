import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:sms/sms.dart';

class SmsUtil {
  static String formatDate(String date) {
    return DateFormat("dd/MM/yyyy hh:mm aa").format(DateTime.parse(date));
  }

  static void sendSms({String number, String msg, bool showSuccessMsg = true}) {
    SmsSender sender = new SmsSender();
    SmsMessage smsMessage = new SmsMessage(number, msg);
    sender.sendSms(smsMessage);
    smsMessage.onStateChanged.listen((state) {
      if (state == SmsMessageState.Sent && showSuccessMsg) {
        Fluttertoast.showToast(msg: "Message Sent");
      }
    });
  }

  static void sendReminderSms(
      {String number, String name, String expiryDate, String licensePlate}) {
    expiryDate = formatDate(expiryDate);
    String messageTxt =
        "Hello $name,\nThis is custom reminder sent to you since your campus access for vehicle: $licensePlate expires on $expiryDate.";
    sendSms(number: number, msg: messageTxt);
  }

  static void sendWelcomeSms(
      {String number, String name, String expiryDate, String licensePlate}) {
    expiryDate = formatDate(expiryDate);
    String messageTxt =
        "Hello $name \nWelcome to Campus Car.\nYour registration for vehicle $licensePlate is successful and valid till  $expiryDate.";
    sendSms(number: number, msg: messageTxt, showSuccessMsg: false);
  }
}
