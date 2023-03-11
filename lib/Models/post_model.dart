
import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String? discription;
  final String? uid;
  final String? username;
  final String? postId;
  final datePublish;
  final String? postUrl;
  final String? profileImage;
  final likes;

  PostModel({
    required this.discription,
    required this.uid,
    required this.username,
    required this.postId,
    required this.datePublish,
    required this.postUrl,
    required this.profileImage,
    required this.likes,
  });

  Map<String, dynamic> toJason() => {
    'username': username,
    'discription': discription,
    'postId': postId,
    'uid': uid,
    'postUrl': postUrl,
    'profileImage': profileImage,
    'likes': likes,
    'datePublish': datePublish,
  };

  static PostModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return PostModel(
      username: snapshot['username'],
      discription: snapshot['discription'],
      postId: snapshot['postId'],
      uid: snapshot['uid'],
      postUrl: snapshot['postUrl'],
      profileImage: snapshot['profileImage'],
      likes: snapshot['likes'],
      datePublish: snapshot['datePublish'],
    );
  }
}
