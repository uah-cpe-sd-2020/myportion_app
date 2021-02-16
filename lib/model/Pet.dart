import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class Pet {
  String rfid = '';
  Timestamp dob = Timestamp.fromDate(new DateTime.utc(0, 0, 0, 0, 0, 0));
  String petID;
  String name = '';
  String type = '';
  num lbs = 0;

  Pet({this.rfid, this.dob, this.petID, this.name, this.type, this.lbs});

  /* CLASS FUNCTIONS CAN GO HERE */

  factory Pet.fromJson(Map<String, dynamic> parsedJson) {
    return new Pet(
        rfid: parsedJson['RFID'] ?? '',
        dob: parsedJson['dob'],
        petID: parsedJson['id'] ?? parsedJson['petID'] ?? '',
        name: parsedJson['name'] ?? '',
        type: parsedJson['type'] ?? '',
        lbs: parsedJson['lbs'] ?? 0);
  }

  Map<String, dynamic> toJson() {
    return {
      'RFID': this.rfid,
      'dob': this.dob,
      'id': this.petID,
      'name': this.name,
      'type': this.type,
      'lbs': this.lbs,
    };
  }
}
