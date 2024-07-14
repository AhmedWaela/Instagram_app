import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel{
  final String postId;
  final String text;
  final String uid;
  final String name;
  final String profilePic;
  final String commentid;

  CommentModel({required this.commentid,required this.uid,required this.postId, required this.text,required this.name, required this.profilePic});

  Map<String,dynamic> toJson() => {
  'profilePic': profilePic,
  'name': name,
  'text': text,
  'post id': postId,
  'datePublished': DateTime.now(),
   'uid':uid,
    'comment id': commentid
  };

  static CommentModel fromSnap(DocumentSnapshot snapshot){
    var snap = snapshot.data() as Map<String,dynamic>;
    return CommentModel(postId: snap['post id'], text: snap['text'], uid: snap['uid'], name: snap['name'], profilePic: snap['profilePic'], commentid: snap['comment id']);
  }
}
