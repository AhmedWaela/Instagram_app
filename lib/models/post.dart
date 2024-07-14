import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel{
  final String description;
  final String uid;
  final String photo;
  final String username;
  final String postId;
  final DateTime datePublished;
  final String profImage;
  final likes;

  PostModel(
      {required this.description,
      required this.uid,
     required this.photo,
     required this.username,
     required this.postId,
     required this.datePublished,
     required this.profImage,
     required this.likes});





  Map<String,dynamic> toJson() => {
    'username': username,
    'datePublished': datePublished,
    'uid': uid,
    'description': description,
    'post id': postId,
    'profImage': profImage,
    'photo':photo,
    'likes':likes,
  };

  static PostModel fromSnap(DocumentSnapshot snapshot){
    var snap = snapshot.data() as Map<String,dynamic>;
    return PostModel(photo: snap['photo'], description: snap['description'], uid: snap['uid'], username: snap['username'], postId: snap['post id'], datePublished: snap['datePublished'], profImage: snap['profImage'], likes: snap['likes']);
  }
}