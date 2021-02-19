import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:myportion_app/model/User.dart';
import 'package:myportion_app/model/Feeder.dart';
import 'package:myportion_app/model/Alert.dart';
import 'package:myportion_app/model/Pet.dart';
import 'package:myportion_app/model/Schedule.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('User Class and Services', () {
    test('User Constructs Properly', () {
      User user = new User(
          email: "JohnSmith@email.com",
          firstName: "John",
          lastName: "Smith",
          phoneNumber: "1231231234",
          userID: "user",
          profilePictureURL: 'pic.png',
          active: false,
          lastOnlineTimestamp:
              Timestamp.fromDate(new DateTime.utc(1969, 7, 20, 20, 18, 04)));
      expect(user.email, "JohnSmith@email.com");
      expect(user.firstName, "John");
      expect(user.lastName, "Smith");
      expect(user.phoneNumber, "1231231234");
      expect(user.userID, "user");
      expect(user.profilePictureURL, "pic.png");
      expect(user.active, false);
      expect(user.lastOnlineTimestamp,
          Timestamp.fromDate(new DateTime.utc(1969, 7, 20, 20, 18, 04)));
    });

    test("User fromJson", () {
      User user = User.fromJson({
        'email': "JohnSmith@email.com",
        'firstName': "John",
        'lastName': "Smith",
        'phoneNumber': "1231231234",
        'id': "user",
        'profilePictureURL': 'pic.png',
        'active': false,
        'lastOnlineTimestamp':
            Timestamp.fromDate(new DateTime.utc(1969, 7, 20, 20, 18, 04)),
        'appIdentifier': 'Flutter ${Platform.operatingSystem}'
      });
      expect(user.email, "JohnSmith@email.com");
      expect(user.firstName, "John");
      expect(user.lastName, "Smith");
      expect(user.phoneNumber, "1231231234");
      expect(user.userID, "user");
      expect(user.profilePictureURL, "pic.png");
      expect(user.active, false);
      expect(user.lastOnlineTimestamp,
          Timestamp.fromDate(new DateTime.utc(1969, 7, 20, 20, 18, 04)));
    });

    test('User toJson()', () {
      User user = new User(
          email: "JohnSmith@email.com",
          firstName: "John",
          lastName: "Smith",
          phoneNumber: "1231231234",
          userID: "user",
          profilePictureURL: 'pic.png',
          active: false,
          lastOnlineTimestamp:
              Timestamp.fromDate(new DateTime.utc(1969, 7, 20, 20, 18, 04)));
      expect(user.toJson(), {
        'email': "JohnSmith@email.com",
        'firstName': "John",
        'lastName': "Smith",
        'phoneNumber': "1231231234",
        'id': "user",
        'profilePictureURL': 'pic.png',
        'active': false,
        'lastOnlineTimestamp':
            Timestamp.fromDate(new DateTime.utc(1969, 7, 20, 20, 18, 04)),
        'appIdentifier': 'Flutter ${Platform.operatingSystem}'
      });
    });

    test("User Fullname", () {
      User user = new User(firstName: "John", lastName: "Smith");
      expect(user.fullName(), "John Smith");
    });
  });

  group('Feeder Class and Services', () {
    test('Feeder Constructs Properly', () {
      Feeder feeder = new Feeder(
          feederID: "feeder", modelNum: "Mark1", name: "Feedtron3000");
      expect(feeder.feederID, "feeder");
      expect(feeder.modelNum, "Mark1");
      expect(feeder.name, "Feedtron3000");
    });

    test('Feeder fromJson', () {
      Feeder feeder = Feeder.fromJson(
          {'id': "feeder", 'modelNumber': "Mark1", 'name': "Feedtron3000"});
      expect(feeder.feederID, "feeder");
      expect(feeder.modelNum, "Mark1");
      expect(feeder.name, "Feedtron3000");
      ;
    });

    test('Feeder toJson', () {
      Feeder feeder = new Feeder(
          feederID: "feeder", modelNum: "Mark1", name: "Feedtron3000");
      expect(feeder.toJson(),
          {'id': "feeder", 'modelNumber': "Mark1", 'name': "Feedtron3000"});
    });
  });

  group('Pet Class and Services', () {
    test('Pet Constructs Properly', () {
      Pet pet = new Pet(
          rfid: "ABC123",
          dob: Timestamp.fromDate(new DateTime.utc(1969, 7, 20, 20, 18, 04)),
          petID: "pet",
          name: "Spot",
          type: "Dog",
          lbs: 29);
      expect(pet.rfid, "ABC123");
      expect(pet.dob,
          Timestamp.fromDate(new DateTime.utc(1969, 7, 20, 20, 18, 04)));
      expect(pet.petID, "pet");
      expect(pet.name, "Spot");
      expect(pet.type, "Dog");
      expect(pet.lbs, 29);
    });

    test('Pet fromJson', () {
      Pet pet = Pet.fromJson({
        'RFID': "ABC123",
        'dob': Timestamp.fromDate(new DateTime.utc(1969, 7, 20, 20, 18, 04)),
        'id': "pet",
        'name': "Spot",
        'type': "Dog",
        'lbs': 29,
      });
      expect(pet.rfid, "ABC123");
      expect(pet.dob,
          Timestamp.fromDate(new DateTime.utc(1969, 7, 20, 20, 18, 04)));
      expect(pet.petID, "pet");
      expect(pet.name, "Spot");
      expect(pet.type, "Dog");
      expect(pet.lbs, 29);
    });

    test('Pet toJson', () {
      Pet pet = new Pet(
          rfid: "ABC123",
          dob: Timestamp.fromDate(new DateTime.utc(1969, 7, 20, 20, 18, 04)),
          petID: "pet",
          name: "Spot",
          type: "Dog",
          lbs: 29);
      expect(pet.toJson(), {
        'RFID': "ABC123",
        'dob': Timestamp.fromDate(new DateTime.utc(1969, 7, 20, 20, 18, 04)),
        'id': "pet",
        'name': "Spot",
        'type': "Dog",
        'lbs': 29,
      });
    });
  });

  group('Schedule Class and Services', () {
    test('Schedule Constructs Properly', () {
      Schedule sched = new Schedule(schedID: "sched", portion: [
        1,
        2,
        3,
        4,
        5
      ], time: [
        Timestamp.fromDate(new DateTime.utc(1969, 7, 20, 20, 18, 04)),
        Timestamp.fromDate(new DateTime.utc(1969, 7, 20, 20, 18, 05)),
        Timestamp.fromDate(new DateTime.utc(1969, 7, 20, 20, 18, 06)),
        Timestamp.fromDate(new DateTime.utc(1969, 7, 20, 20, 18, 07)),
        Timestamp.fromDate(new DateTime.utc(1969, 7, 20, 20, 18, 08))
      ]);
      expect(sched.schedID, "sched");
      expect(sched.portion, [1, 2, 3, 4, 5]);
      expect(sched.time, [
        Timestamp.fromDate(new DateTime.utc(1969, 7, 20, 20, 18, 04)),
        Timestamp.fromDate(new DateTime.utc(1969, 7, 20, 20, 18, 05)),
        Timestamp.fromDate(new DateTime.utc(1969, 7, 20, 20, 18, 06)),
        Timestamp.fromDate(new DateTime.utc(1969, 7, 20, 20, 18, 07)),
        Timestamp.fromDate(new DateTime.utc(1969, 7, 20, 20, 18, 08))
      ]);
    });

    test('Schedule fromJson', () {
      Schedule sched = Schedule.fromJson({
        'id': "sched",
        'portion': [1, 2, 3, 4, 5],
        'time': [
          Timestamp.fromDate(new DateTime.utc(1969, 7, 20, 20, 18, 04)),
          Timestamp.fromDate(new DateTime.utc(1969, 7, 20, 20, 18, 05)),
          Timestamp.fromDate(new DateTime.utc(1969, 7, 20, 20, 18, 06)),
          Timestamp.fromDate(new DateTime.utc(1969, 7, 20, 20, 18, 07)),
          Timestamp.fromDate(new DateTime.utc(1969, 7, 20, 20, 18, 08))
        ]
      });
      expect(sched.schedID, "sched");
      expect(sched.portion, [1, 2, 3, 4, 5]);
      expect(sched.time, [
        Timestamp.fromDate(new DateTime.utc(1969, 7, 20, 20, 18, 04)),
        Timestamp.fromDate(new DateTime.utc(1969, 7, 20, 20, 18, 05)),
        Timestamp.fromDate(new DateTime.utc(1969, 7, 20, 20, 18, 06)),
        Timestamp.fromDate(new DateTime.utc(1969, 7, 20, 20, 18, 07)),
        Timestamp.fromDate(new DateTime.utc(1969, 7, 20, 20, 18, 08))
      ]);
    });

    test('Schedule toJson', () {
      Schedule sched = new Schedule(schedID: "sched", portion: [
        1,
        2,
        3,
        4,
        5
      ], time: [
        Timestamp.fromDate(new DateTime.utc(1969, 7, 20, 20, 18, 04)),
        Timestamp.fromDate(new DateTime.utc(1969, 7, 20, 20, 18, 05)),
        Timestamp.fromDate(new DateTime.utc(1969, 7, 20, 20, 18, 06)),
        Timestamp.fromDate(new DateTime.utc(1969, 7, 20, 20, 18, 07)),
        Timestamp.fromDate(new DateTime.utc(1969, 7, 20, 20, 18, 08))
      ]);
      expect(sched.toJson(), {
        'id': "sched",
        'portion': sched.portion,
        'time': sched.time,
      });
    });
  });

  group('Alert Class and Services', () {
    test('Alert Constructs Properly', () {
      Alert alert = new Alert(
          alertID: "alert",
          message: "Spot's food has been dispensed",
          time: Timestamp.fromDate(new DateTime.utc(1969, 7, 20, 20, 18, 08)));
      expect(alert.alertID, "alert");
      expect(alert.message, "Spot's food has been dispensed");
      expect(alert.time,
          Timestamp.fromDate(new DateTime.utc(1969, 7, 20, 20, 18, 08)));
    });

    test('Alert fromJson', () {
      Alert alert = Alert.fromJson({
        'id': "alert",
        'message': "Spot's food has been dispensed",
        'time': Timestamp.fromDate(new DateTime.utc(1969, 7, 20, 20, 18, 08)),
      });
      expect(alert.alertID, "alert");
      expect(alert.message, "Spot's food has been dispensed");
      expect(alert.time,
          Timestamp.fromDate(new DateTime.utc(1969, 7, 20, 20, 18, 08)));
    });

    test('Alert toJson', () {
      Alert alert = new Alert(
          alertID: "alert",
          message: "Spot's food has been dispensed",
          time: Timestamp.fromDate(new DateTime.utc(1969, 7, 20, 20, 18, 08)));
      expect(alert.toJson(), {
        'id': "alert",
        'message': "Spot's food has been dispensed",
        'time': Timestamp.fromDate(new DateTime.utc(1969, 7, 20, 20, 18, 08)),
      });
    });
  });
}
