import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class Pet {
  String petName = '';
  String feederID = '';
  List scheduleFeeding = [];
  String petID;
  bool active = false;
  String petProfilePictureURL = '';
  bool selected = false;
  String appIdentifier = 'Flutter ${Platform.operatingSystem}';

  Pet (
      {this.petName,
        this.feederID,
        this.scheduleFeeding,
        this.petID,
        this.active,
        this.petProfilePictureURL});

  factory Pet.fromJson(Map<String, dynamic> parsedJson) {
    return new Pet(
        petName: parsedJson['petName'] ?? '',
        feederID: parsedJson['feederID'] ?? '',
        active: parsedJson['active'] ?? false,
        scheduleFeeding: parsedJson['scheduleFeeding'] ?? '',
        petID: parsedJson['id'] ?? parsedJson['petID'] ?? '',
        petProfilePictureURL: parsedJson['petProfilePictureURL'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'petName': this.petName,
      'feederID': this.feederID,
      'scheduleFeeding': this.scheduleFeeding,
      'id': this.petID,
      'active': this.active,
      'petProfilePictureURL': this.petProfilePictureURL,
      'appIdentifier': this.appIdentifier
    };
  }
}