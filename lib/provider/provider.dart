import 'package:flutter/material.dart';
import 'package:project/models/commentModel.dart';
import 'package:project/methods/auth_methods.dart';
import 'package:project/models/user.dart';

class UserProvider extends ChangeNotifier{

  UserModel? _userModel;

  UserModel get getUser => _userModel!;

  CommentModel? _commentModel;

  CommentModel get getComment => _commentModel!;


  Future<void> refreshUser()async{
    UserModel userModel = await AuthMethods().getUserDetails();
    _userModel = userModel;
    notifyListeners();
  }

  Future<void> refresh(String docId)async{
    CommentModel  commentModel = await AuthMethods().getComments(docId);
      _commentModel = commentModel;
      notifyListeners();
  }


}