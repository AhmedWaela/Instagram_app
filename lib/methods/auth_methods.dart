
import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/models/commentModel.dart';
import 'package:project/methods/storages_methods.dart';
import 'package:project/models/user.dart';

class AuthMethods{
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;


 Future<UserModel> getUserDetails()async{
   DocumentSnapshot snapshot = await firebaseFireStore.collection('users').doc(auth.currentUser!.uid).get();
   return UserModel.fromSnap(snapshot);
 }

 Future<CommentModel> getComments(String docId)async{
   DocumentSnapshot snapshot = await firebaseFireStore.collection('posts').doc(docId).collection('comments').doc(docId).get();
   return CommentModel.fromSnap(snapshot);
 }



 Future<void> signUp(
  {
    required TextEditingController email,
    required TextEditingController password,
    required TextEditingController username,
    required Uint8List image,
}
     )async{
   try{
     UserCredential userCredential =   await  auth.createUserWithEmailAndPassword(email: email.text, password: password.text);

     CollectionReference collectionReference =  firebaseFireStore.collection('users');
     DocumentReference documentReference = collectionReference.doc(userCredential.user!.uid);
     String file = await StoragesMethods().uploadImage('profilePic', image, false);
     UserModel userModel = UserModel(photo: file, email: email.text, uid: userCredential.user!.uid, username: username.text, followers: [], following: []);

     await firebaseFireStore.collection('users').doc(userCredential.user!.uid).set(userModel.toJson());
   }catch(e){
     throw Exception(e.toString());
   }
 }

 Future<void> login({required TextEditingController email , required TextEditingController password})async{
    try{
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email.text, password: password.text);

    }catch(e){
      throw Exception(e.toString());
    }
    }
 }