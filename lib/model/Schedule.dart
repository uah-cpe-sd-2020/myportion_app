import 'package:cloud_firestore/cloud_firestore.dart';

class Schedule {
  String schedID = '';
  List<int> portion = [];
  List<Timestamp> time = [];

  Schedule({this.schedID, this.portion, this.time});

  /* CLASS FUNCTIONS CAN GO HERE */

  factory Schedule.fromJson(Map<String, dynamic> parsedJson) {
    return new Schedule(
        schedID: parsedJson['id'] ?? parsedJson['scheduleID'] ?? '',
        portion: parsedJson['portion'] ?? '',
        time: parsedJson['time'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.schedID,
      'portion': this.portion,
      'time': this.time,
    };
  }
}
