import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/Models/post_model.dart';
import 'package:instagram_clone/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirebaseMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(
    Uint8List file,
    String uid,
    String discription,
    String username,
    String profileImage,
  ) async {
    String ref = 'Something went wrong';
    try {
      final ImageUrl =
          await StorageMethod().uploadImageToStorage('post', file, true);

      String postId = const Uuid().v1();
      PostModel post = PostModel(
        discription: discription,
        uid: uid,
        username: username,
        postId: postId,
        datePublish: DateTime.now(),
        postUrl: ImageUrl,
        profileImage: profileImage,
        likes: [],
      );

      _firestore.collection('post').doc(postId).set(post.toJason());

      ref = 'success';
    } catch (err) {
      ref = err.toString();
    }

    return ref;
  }

  Future<void> ButtonlikePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('post').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('post').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> PostComment(
    String postId,
    String text,
    String uid,
    String name,
    String profilePic,
  ) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection('post')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now()
        });
      } else {
        print('Text is empty');
      }
    } catch (e) {
      print(e.toString());
    }
  }

//  Delete Post
  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('post').doc(postId).delete();
    } catch (e) {
      print(e.toString());
    }
  }


  Future<void> followUser(String uid , String followId) async {
    try{
      DocumentSnapshot snap = await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];
      
      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({'followers' : FieldValue.arrayRemove([uid])});

        await _firestore.collection('users').doc(uid).update({'following' : FieldValue.arrayRemove([followId])});
      }else{

        await _firestore.collection('users').doc(followId).update({'followers' : FieldValue.arrayUnion([uid])});

        await _firestore.collection('users').doc(uid).update({'following' : FieldValue.arrayUnion([followId])});
      }


    }catch(e){
      print(e);
    }
  }
}
