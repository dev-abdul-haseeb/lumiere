import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lumiere/src/core/constants/constants.dart';
import 'package:lumiere/src/data/models/user_model.dart';

class UserRemoteDatasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel> createUser(UserModel user) async {
    try {
      await _firestore
          .collection(AppConstants.userCollection)
          .doc(user.user_id)
          .set(user.toMap());

      return user;

    } on FirebaseException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<UserModel> getUserById(String uid) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.userCollection)
          .doc(uid)
          .get();

      if (!doc.exists) {
        throw Exception("User not found");
      }

      UserModel userModel = UserModel.fromMap(doc.data()!);
      userModel.copyWith(user_id: uid);

      return userModel;

    } on FirebaseException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      await _firestore
          .collection(AppConstants.userCollection)
          .doc(user.user_id)
          .update(user.toMap());

    } on FirebaseException catch (e) {
      throw Exception(e.message);
    }
  }
}