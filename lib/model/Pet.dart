import 'package:cloud_firestore/cloud_firestore.dart';

class Pet {
  String rfid = '';
  String dob = '';
  String id;
  String name = '';
  String type = '';
  num lbs = 0;
  String petProfilePictureURL = '';

  Pet(
      {this.rfid,
      this.dob,
      this.id,
      this.name,
      this.type,
      this.lbs,
      this.petProfilePictureURL});

  /* CLASS FUNCTIONS CAN GO HERE */

  factory Pet.fromJson(Map<String, dynamic> parsedJson) {
    return new Pet(
        rfid: parsedJson['rfid'] ?? '',
        dob: parsedJson['dob'],
        id: parsedJson['id'] ?? '',
        name: parsedJson['name'] ?? '',
        type: parsedJson['type'] ?? '',
        lbs: parsedJson['lbs'] ?? 0,
        petProfilePictureURL: parsedJson['petProfilePictureURL'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'rfid': this.rfid,
      'dob': this.dob,
      'id': this.id,
      'name': this.name,
      'type': this.type,
      'lbs': this.lbs,
      'petProfilePictureURL': this.petProfilePictureURL,
    };
  }
}
