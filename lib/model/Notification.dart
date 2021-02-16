import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class Notification {
  String notifID;
  String message = '';
  Timestamp time = Timestamp.fromDate(new DateTime.utc(0, 0, 0, 0, 0, 0));

  Notification({this.notifID, this.message, this.time});

  /* CLASS FUNCTIONS CAN GO HERE */

  factory Notification.fromJson(Map<String, dynamic> parsedJson) {
    return new Notification(
        notifID: parsedJson['id'] ?? parsedJson['notificationID'] ?? '',
        message: parsedJson['message'] ?? '',
        time: parsedJson['time']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.notifID,
      'message': this.message,
      'time': this.time,
    };
  }
}
