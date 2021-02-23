import 'package:cloud_firestore/cloud_firestore.dart';

class Pet {
  String rfid = '';
  Timestamp dob = Timestamp.now();
  String id;
  String name = '';
  String type = '';
  num lbs = 0;

  Pet({this.rfid, this.dob, this.id, this.name, this.type, this.lbs});

  /* CLASS FUNCTIONS CAN GO HERE */

  factory Pet.fromJson(Map<String, dynamic> parsedJson) {
    return new Pet(
        rfid: parsedJson['rfid'] ?? '',
        dob: parsedJson['dob'],
        id: parsedJson['id'] ?? '',
        name: parsedJson['name'] ?? '',
        type: parsedJson['type'] ?? '',
        lbs: parsedJson['lbs'] ?? 0);
  }

  Map<String, dynamic> toJson() {
    return {
      'rfid': this.rfid,
      'dob': this.dob,
      'id': this.id,
      'name': this.name,
      'type': this.type,
      'lbs': this.lbs,
    };
  }
}
