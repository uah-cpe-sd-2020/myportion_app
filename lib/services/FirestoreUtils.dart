import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:myportion_app/constants.dart';
import 'package:myportion_app/model/User.dart';
import 'package:myportion_app/model/Feeder.dart';
import 'package:myportion_app/model/Notification.dart';
import 'package:myportion_app/model/Pet.dart';
import 'package:myportion_app/model/Schedule.dart';

class FireStoreUtils {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  Reference storage = FirebaseStorage.instance.ref();
  String userID;
  String feederID;
  String petID;

  /*USER*/
  Future<User> getCurrentUser(String uid) async {
    DocumentSnapshot userDocument =
        await firestore.collection(USERS).doc(uid).get();
    if (userDocument != null && userDocument.exists) {
      this.userID = uid;
      return User.fromJson(userDocument.data());
    } else {
      return null;
    }
  }

  static Future<User> updateCurrentUser(User user) async {
    return await firestore
        .collection(USERS)
        .doc(user.userID)
        .set(user.toJson())
        .then((document) {
      return user;
    });
  }

  Future<String> uploadUserImageToFireStorage(File image, String userID) async {
    Reference upload = storage.child("images/$userID.png");
    UploadTask uploadTask = upload.putFile(image);
    var downloadUrl =
        await (await uploadTask.whenComplete(() {})).ref.getDownloadURL();
    return downloadUrl.toString();
  }

  /*FEEDER*/
  Future<Feeder> getFeeder(String fid) async {
    DocumentSnapshot feederDocument = await firestore
        .collection(USERS)
        .doc(this.userID)
        .collection(FEEDERS)
        .doc(fid)
        .get();
    if (feederDocument != null && feederDocument.exists) {
      this.feederID = fid;
      return Feeder.fromJson(feederDocument.data());
    } else {
      return null;
    }
  }

  Future<Feeder> updateFeeder(Feeder feeder) async {
    return await firestore
        .collection(USERS)
        .doc(this.userID)
        .collection(FEEDERS)
        .doc(feeder.feederID)
        .set(feeder.toJson())
        .then((document) {
      return feeder;
    });
  }

  /*NOTIFICATION*/
  Future<Notification> getNotification(String nid) async {
    DocumentSnapshot notificationDocument = await firestore
        .collection(USERS)
        .doc(this.userID)
        .collection(NOTIFICATIONS)
        .doc(nid)
        .get();
    if (notificationDocument != null && notificationDocument.exists) {
      return Notification.fromJson(notificationDocument.data());
    } else {
      return null;
    }
  }

  Future<Notification> updateNotification(Notification notification) async {
    return await firestore
        .collection(USERS)
        .doc(this.userID)
        .collection(NOTIFICATIONS)
        .doc(notification.notifID)
        .set(notification.toJson())
        .then((document) {
      return notification;
    });
  }

  /*PET*/
  Future<Pet> getPet(String pid) async {
    DocumentSnapshot petDocument = await firestore
        .collection(USERS)
        .doc(this.userID)
        .collection(FEEDERS)
        .doc(this.feederID)
        .collection(PETS)
        .doc(pid)
        .get();
    if (petDocument != null && petDocument.exists) {
      this.petID = pid;
      return Pet.fromJson(petDocument.data());
    } else {
      return null;
    }
  }

  Future<Pet> updatePet(Pet pet) async {
    return await firestore
        .collection(USERS)
        .doc(this.userID)
        .collection(FEEDERS)
        .doc(this.feederID)
        .collection(PETS)
        .doc(pet.petID)
        .set(pet.toJson())
        .then((document) {
      return pet;
    });
  }

  /*SCHEDULE*/
  Future<Schedule> getSchedule(String sid) async {
    DocumentSnapshot scheduleDocument = await firestore
        .collection(USERS)
        .doc(this.userID)
        .collection(FEEDERS)
        .doc(this.feederID)
        .collection(PETS)
        .doc(this.petID)
        .collection(SCHEDULES)
        .doc(sid)
        .get();
    if (scheduleDocument != null && scheduleDocument.exists) {
      return Schedule.fromJson(scheduleDocument.data());
    } else {
      return null;
    }
  }

  Future<Schedule> updateSchedule(Schedule schedule) async {
    return await firestore
        .collection(USERS)
        .doc(this.userID)
        .collection(FEEDERS)
        .doc(this.feederID)
        .collection(PETS)
        .doc(this.petID)
        .collection(SCHEDULES)
        .doc(schedule.schedID)
        .set(schedule.toJson())
        .then((document) {
      return schedule;
    });
  }
}
