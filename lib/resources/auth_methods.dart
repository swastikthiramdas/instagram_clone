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

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String name,
    required Uint8List file,
  }) async {
    String res = 'Some error occurred';
    try {

      print(email);
      print(password);
      print(username);
      print(name);
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          name.isNotEmpty ) {

        //  Register User
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        print('registration done');

        String photoUrl = await StorageMethod()
            .uploadImageToStorage('profilePic/', file, false);

        print('uploaded photo');
        String uid = cred.user!.uid;

        UserModel user = UserModel(
          followers: [],
          following: [],
          photoUrl: photoUrl,
          uid: uid,
          email: email,
          username: username,
          bio: '',
          name: name,
        );

        _firestore.collection('users').doc(uid).set(user.toJason());
        print('Data Updated in firestore');
        res = 'Success';
      }
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
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
