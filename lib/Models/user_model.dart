
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? email;
  final String? uid;
  final String? username;
  final String? bio;
  final List? followers;
  final List? following;
  final String? photoUrl;

  UserModel({
    required this.followers,
    required this.following,
    required this.photoUrl,
    required this.uid,
    required this.email,
    required this.username,
    required this.bio,
  });

  Map<String, dynamic> toJason() => {
        'username': username,
        'email': email,
        'bio': bio,
        'uid': uid,
        'photoUrl': photoUrl,
        'following': following,
        'followers': followers,
      };

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
      followers: snapshot['followers'],
      following: snapshot['following'],
      photoUrl: snapshot['photoUrl'],
      uid: snapshot['uid'],
      email: snapshot['email'],
      username: snapshot['username'],
      bio: snapshot['bio'],
    );
  }
}
