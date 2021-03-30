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

  Future<Feeder> getFeederFromPet(String pid) async {
    QuerySnapshot feederCollection = await firestore
        .collection(USERS)
        .doc(FireStoreUtils.userID)
        .collection(FEEDERS)
        .get();
    for (var doc in feederCollection.docs) {
      QuerySnapshot petCollection = await firestore
          .collection(USERS)
          .doc(FireStoreUtils.userID)
          .collection(FEEDERS)
          .doc(doc.id)
          .collection(PETS)
          .get();
      for (var pet in petCollection.docs) {
        if (pet.data()["id"] == pid) {
          FireStoreUtils.feederID = doc.data()["id"];
          return Feeder.fromJson(doc.data());
        }
      }
    }
    return null;
  }

  Future<List<dynamic>> getFeederList() async {
    List<Feeder> temp = [];
    QuerySnapshot feederCollection = await firestore
        .collection(USERS)
        .doc(FireStoreUtils.userID)
        .collection(FEEDERS)
        .get();
    for (var doc in feederCollection.docs) {
      temp.add(new Feeder.fromJson(doc.data()));
    }
    return temp;
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

  Future<bool> removeFeeder(Feeder feeder) async {
    try {
      await firestore
          .collection(USERS)
          .doc(FireStoreUtils.userID)
          .collection(FEEDERS)
          .doc(feeder.id)
          .delete();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
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

  Future<List<dynamic>> getPetList() async {
    List<Pet> temp = [];
    QuerySnapshot petCollection = await firestore
        .collection(USERS)
        .doc(FireStoreUtils.userID)
        .collection(FEEDERS)
        .doc(FireStoreUtils.feederID)
        .collection(PETS)
        .get();
    for (var doc in petCollection.docs) {
      temp.add(new Pet.fromJson(doc.data()));
    }
    return temp;
  }

  Future<List<dynamic>> getAllPets() async {
    List<Pet> temp = [];
    QuerySnapshot feederCollection = await firestore
        .collection(USERS)
        .doc(FireStoreUtils.userID)
        .collection(FEEDERS)
        .get();
    for (var doc in feederCollection.docs) {
      QuerySnapshot petCollection = await firestore
          .collection(USERS)
          .doc(FireStoreUtils.userID)
          .collection(FEEDERS)
          .doc(doc.id)
          .collection(PETS)
          .get();
      for (var pet in petCollection.docs) {
        temp.add(new Pet.fromJson(pet.data()));
      }
    }
    return temp;
  }

  Future<Pet> getPetFromSchedule(String sid) async {
    QuerySnapshot feederCollection = await firestore
        .collection(USERS)
        .doc(FireStoreUtils.userID)
        .collection(FEEDERS)
        .get();
    for (var doc in feederCollection.docs) {
      QuerySnapshot petCollection = await firestore
          .collection(USERS)
          .doc(FireStoreUtils.userID)
          .collection(FEEDERS)
          .doc(doc.id)
          .collection(PETS)
          .get();
      for (var pet in petCollection.docs) {
        QuerySnapshot schedCollection = await firestore
            .collection(USERS)
            .doc(FireStoreUtils.userID)
            .collection(FEEDERS)
            .doc(doc.id)
            .collection(PETS)
            .doc(pet.id)
            .collection(SCHEDULES)
            .get();
        for (var sched in schedCollection.docs) {
          if (sched.data()["id"] == sid) {
            FireStoreUtils.feederID = doc.data()["id"];
            FireStoreUtils.petID = pet.data()["id"];
            return Pet.fromJson(pet.data());
          }
        }
      }
    }
    return null;
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
    Pet temp = await firestore
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
    FireStoreUtils.petID = temp.id;
    return temp;
  }

  Future<bool> removePet(Pet pet) async {
    try {
      await firestore
          .collection(USERS)
          .doc(FireStoreUtils.userID)
          .collection(FEEDERS)
          .doc(FireStoreUtils.feederID)
          .collection(PETS)
          .doc(pet.id)
          .delete();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
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

  Future<List<dynamic>> getAllSchedules() async {
    List<Schedule> temp = [];
    QuerySnapshot feederCollection = await firestore
        .collection(USERS)
        .doc(FireStoreUtils.userID)
        .collection(FEEDERS)
        .get();
    for (var doc in feederCollection.docs) {
      QuerySnapshot petCollection = await firestore
          .collection(USERS)
          .doc(FireStoreUtils.userID)
          .collection(FEEDERS)
          .doc(doc.id)
          .collection(PETS)
          .get();
      for (var pet in petCollection.docs) {
        QuerySnapshot scheduleCollection = await firestore
            .collection(USERS)
            .doc(FireStoreUtils.userID)
            .collection(FEEDERS)
            .doc(doc.id)
            .collection(PETS)
            .doc(pet.id)
            .collection(SCHEDULES)
            .get();
        for (var schedule in scheduleCollection.docs) {
          temp.add(new Schedule.fromJson(schedule.data()));
        }
      }
    }
    return temp;
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
      schedule.id = document.id;
      return schedule;
    });
  }

  Future<Schedule> updateSchedule(schedule) async {
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

  Future<bool> removeSchedule(Schedule schedule) async {
    try {
      await firestore
          .collection(USERS)
          .doc(FireStoreUtils.userID)
          .collection(FEEDERS)
          .doc(FireStoreUtils.feederID)
          .collection(PETS)
          .doc(FireStoreUtils.petID)
          .collection(SCHEDULES)
          .doc(schedule.id)
          .delete();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
