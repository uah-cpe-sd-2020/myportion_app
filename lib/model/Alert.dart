import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class Alert {
  String alertID;
  String message = '';
  Timestamp time = Timestamp.now();

  Alert({this.alertID, this.message, this.time});

  /* CLASS FUNCTIONS CAN GO HERE */

  factory Alert.fromJson(Map<String, dynamic> parsedJson) {
    return new Alert(
        alertID: parsedJson['id'] ?? parsedJson['notificationID'] ?? '',
        message: parsedJson['message'] ?? '',
        time: parsedJson['time']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.alertID,
      'message': this.message,
      'time': this.time,
    };
  }
}
