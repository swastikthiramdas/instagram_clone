import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/resources/storage_methods.dart';

import '../Models/user_model.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel> getUser() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();
    return UserModel.fromSnap(snap);
  }

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List? file,
  }) async {
    String res = 'Some error occurred';
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        //  Register User
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        String photoUrl = await StorageMethod()
            .uploadImageToStorage('profilePic/', file!, false);
        final String uid = cred.user!.uid;

        UserModel user = UserModel(
            followers: [],
            following: [],
            photoUrl: photoUrl,
            uid: uid,
            email: email,
            username: username,
            bio: bio);

        _firestore.collection('users').doc(uid).set(user.toJason());

        res = 'Success';
      }
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  Future<String> loginUser(
      {required String email, required String password}) async {
    String ref = 'Something went wrong';
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        _auth.signInWithEmailAndPassword(email: email, password: password);
        ref = 'Success';
      } else {
        ref = 'Enter Details';
      }
    } catch (err) {
      ref = err.toString();
    }
    return ref;
  }
}
