import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:myportion_app/constants.dart';
import 'package:myportion_app/model/User.dart';
import 'package:myportion_app/model/Feeder.dart';
import 'package:myportion_app/model/Alert.dart';
import 'package:myportion_app/model/Pet.dart';
import 'package:myportion_app/model/Schedule.dart';

class FireStoreUtils {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  Reference storage = FirebaseStorage.instance.ref();
  static String userID;
  static String feederID;
  static String petID;

  /*USER*/
  Future<User> getCurrentUser(String uid) async {
    DocumentSnapshot userDocument =
        await firestore.collection(USERS).doc(uid).get();
    if (userDocument != null && userDocument.exists) {
      FireStoreUtils.userID = uid;
      print(uid);
      return User.fromJson(userDocument.data());
    } else {
      return null;
    }
  }

  static Future<User> updateCurrentUser(User user) async {
    FireStoreUtils.userID = user.id;
    return await firestore
        .collection(USERS)
        .doc(user.id)
        .set(user.toJson(), SetOptions(merge: true))
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
        .doc(FireStoreUtils.userID)
        .collection(FEEDERS)
        .doc(fid)
        .get();
    if (feederDocument != null && feederDocument.exists) {
      FireStoreUtils.feederID = fid;
      return Feeder.fromJson(feederDocument.data());
    } else {
      return null;
    }
  }

  Future<Feeder> addFeeder(Feeder feeder) async {
    Feeder temp = await firestore
        .collection(USERS)
        .doc(FireStoreUtils.userID)
        .collection(FEEDERS)
        .add(feeder.toJson())
        .then((document) {
      feeder.id = document.id;
      return feeder;
    });
    FireStoreUtils.feederID = temp.id;
    return temp;
  }

  Future<Feeder> updateFeeder(Feeder feeder) async {
    return await firestore
        .collection(USERS)
        .doc(FireStoreUtils.userID)
        .collection(FEEDERS)
        .doc(feeder.id)
        .set(feeder.toJson(), SetOptions(merge: true))
        .then((document) {
      return feeder;
    });
  }

  /*NOTIFICATION*/
  Future<Alert> getNotification(String nid) async {
    DocumentSnapshot alertDocument = await firestore
        .collection(USERS)
        .doc(FireStoreUtils.userID)
        .collection(ALERTS)
        .doc(nid)
        .get();
    if (alertDocument != null && alertDocument.exists) {
      return Alert.fromJson(alertDocument.data());
    } else {
      return null;
    }
  }

  Future<Alert> updateNotification(Alert alert) async {
    return await firestore
        .collection(USERS)
        .doc(FireStoreUtils.userID)
        .collection(ALERTS)
        .doc(alert.id)
        .set(alert.toJson(), SetOptions(merge: true))
        .then((document) {
      return alert;
    });
  }

  /*PET*/
  Future<Pet> getPet(String pid) async {
    DocumentSnapshot petDocument = await firestore
        .collection(USERS)
        .doc(FireStoreUtils.userID)
        .collection(FEEDERS)
        .doc(FireStoreUtils.feederID)
        .collection(PETS)
        .doc(pid)
        .get();
    if (petDocument != null && petDocument.exists) {
      FireStoreUtils.petID = pid;
      return Pet.fromJson(petDocument.data());
    } else {
      return null;
    }
  }

  Future<Pet> addPet(Pet pet) async {
    Pet temp = await firestore
        .collection(USERS)
        .doc(FireStoreUtils.userID)
        .collection(FEEDERS)
        .doc(FireStoreUtils.feederID)
        .collection(PETS)
        .add(pet.toJson())
        .then((document) {
      pet.id = document.id;
      return pet;
    });
    FireStoreUtils.petID = temp.id;
    return temp;
  }

  Future<Pet> updatePet(Pet pet) async {
    return await firestore
        .collection(USERS)
        .doc(FireStoreUtils.userID)
        .collection(FEEDERS)
        .doc(FireStoreUtils.feederID)
        .collection(PETS)
        .doc(pet.id)
        .set(pet.toJson(), SetOptions(merge: true))
        .then((document) {
      return pet;
    });
  }

  /*SCHEDULE*/
  Future<Schedule> getSchedule(String sid) async {
    DocumentSnapshot scheduleDocument = await firestore
        .collection(USERS)
        .doc(FireStoreUtils.userID)
        .collection(FEEDERS)
        .doc(FireStoreUtils.feederID)
        .collection(PETS)
        .doc(FireStoreUtils.petID)
        .collection(SCHEDULES)
        .doc(sid)
        .get();
    if (scheduleDocument != null && scheduleDocument.exists) {
      return Schedule.fromJson(scheduleDocument.data());
    } else {
      return null;
    }
  }

  Future<Schedule> addSchedule(Schedule schedule) async {
    return await firestore
        .collection(USERS)
        .doc(FireStoreUtils.userID)
        .collection(FEEDERS)
        .doc(FireStoreUtils.feederID)
        .collection(PETS)
        .doc(FireStoreUtils.petID)
        .collection(SCHEDULES)
        .add(schedule.toJson())
        .then((document) {
      return schedule;
    });
  }

  Future<Schedule> updateSchedule(Schedule schedule) async {
    return await firestore
        .collection(USERS)
        .doc(FireStoreUtils.userID)
        .collection(FEEDERS)
        .doc(FireStoreUtils.feederID)
        .collection(PETS)
        .doc(FireStoreUtils.petID)
        .collection(SCHEDULES)
        .doc(schedule.id)
        .set(schedule.toJson(), SetOptions(merge: true))
        .then((document) {
      return schedule;
    });
  }
}
