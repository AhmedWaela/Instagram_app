import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  final String email;
  final String uid;
  final String photo;
  final String username;
  final List followers;
  final List following;

  UserModel({required this.photo, required this.email, required this.uid, required this.username, required this.followers, required this.following});


  Map<String,dynamic> toJson() => {
    'username': username,
    'email': email,
    'uid': uid,
    'following': following,
    'followers': followers,
    'photo':photo,
  };

  static UserModel fromSnap(DocumentSnapshot snapshot){
    var snap = snapshot.data() as Map<String,dynamic>;
    return UserModel(photo: snap['photo'], email: snap['email'], uid: snap['uid'], username: snap['username'], followers: snap['followers'], following: snap['following']);
  }
}