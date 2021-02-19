import 'package:cloud_firestore/cloud_firestore.dart';

class Alert {
  String id;
  String message = '';
  Timestamp time = Timestamp.now();

  Alert({this.id, this.message, this.time});

  /* CLASS FUNCTIONS CAN GO HERE */

  factory Alert.fromJson(Map<String, dynamic> parsedJson) {
    return new Alert(
        id: parsedJson['id'] ?? '',
        message: parsedJson['message'] ?? '',
        time: parsedJson['time']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'message': this.message,
      'time': this.time,
    };
  }
}
