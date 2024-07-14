import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project/models/commentModel.dart';
import 'package:project/methods/storages_methods.dart';
import 'package:project/models/post.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods{
  var post;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  Future<String> uploadPost(String uid , Uint8List file , String description,String username,String profImage)async{
    String message = 'no post';
    try{
      String photo = await StoragesMethods().uploadImage('posts', file, true);
      String postId = const Uuid().v1();
      PostModel postModel = PostModel(description: description, uid: uid, photo: photo, username: username, postId: postId, datePublished: DateTime.now(), profImage: profImage, likes: []);
   post = firebaseFirestore.collection('posts').doc(postId).set(postModel.toJson());
    message = 'success';
    }catch(e){
      message = e.toString();
    }
    return message;
  }

  // Future<void> likePost(String postId  , String uid, List likes)async{
  //
  //   var identfier = FirebaseAuth.instance.currentUser!.uid;
  //   var i = firebaseFirestore.collection('posts').doc(postId).get().then((snap){
  //     if(!snap.data()?['likes'].contains(identfier)){
  //       snap[likes].add(identfier);
  //     }
  //   }
  //
  //   try {
  //     if (!like.contains()) {
  //       // await firebaseFirestore.collection('posts').doc(postId).update(
  //       //     {'likes': FieldValue.arrayUnion([uid])});
  //       like.add(FirebaseAuth.instance.currentUser!.uid);
  //     } else {
  //       for (var u in like) {
  //         if (FirebaseAuth.instance.currentUser!.uid == post['uid']) {
  //           like.remove(FirebaseAuth.instance.currentUser!.uid);
  //         }
  //       }
  //     }



     //   );
     //
     //   if()
     //
     // if(FirebaseAuth.instance.currentUser!.uid == uid){
     //   for(var uid in likes){
     //
     //   }
     // }



  //
  //   }catch(e){
  //     throw Exception(e.toString());
  //   }
  //
  // }


  // Future<void> toggleLikePost(String postId, String userId) async {
  //   // التحقق من أن معرف المستخدم غير فارغ
  //   if (userId.isEmpty) {
  //     print("User ID is empty.");
  //     return;
  //   }
  //
  //   final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);
  //
  //   // بدء معاملة Firestore
  //   FirebaseFirestore.instance.runTransaction((transaction) async {
  //     final snapshot = await transaction.get(postRef);
  //
  //     if (!snapshot.exists) {
  //       print("Post does not exist!");
  //       return;
  //     }
  //
  //     // الحصول على قائمة الإعجابات الحالية
  //     List<dynamic> likes = snapshot.data()?['likes'] ?? [];
  //
  //
  //       // إذا لم يكن المستخدم قد أعجب بالمنشور، قم بإضافة الإعجاب
  //       likes.add(userId);
  //       print("User liked the post.");
  //
  //     // تحديث بيانات المنشور
  //     transaction.update(postRef, {'likes': likes});
  //   }).then((_) {
  //     print("Post like status toggled successfully!");
  //   }).catchError((error) {
  //     print("Failed to toggle like status: $error");
  //   });
  // }

  Future<void> postComment(String postId, String text, String uid, String name , String profilePic)async{
    try{
      if(text.isNotEmpty){
        String commentId = const Uuid().v1();
        CommentModel commentModel = CommentModel(postId: postId, text: text, uid: uid, name: name, profilePic: profilePic, commentid: commentId);
        firebaseFirestore.collection('posts').doc(postId).collection('comments').doc(commentId).set(
          commentModel.toJson()
        );

      }else{
        print('Text is empty');
      }
    }catch(e){
      print(e.toString());
    }

  }
}