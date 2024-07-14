import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../methods/firestore_methods.dart';
import '../methods/storages_methods.dart';
import '../provider/provider.dart';
import '../models/user.dart';
import 'custom_text-form_field.dart';

class CustomAddPostAppBar extends StatefulWidget {
  const CustomAddPostAppBar({super.key});

  @override
  State<CustomAddPostAppBar> createState() => _CustomAddPostAppBarState();
}

class _CustomAddPostAppBarState extends State<CustomAddPostAppBar> {
  TextEditingController description = TextEditingController();
  Uint8List? image;
  bool isLoading = false;
  selectImage() async {
    Uint8List file = await StoragesMethods().pickImage(ImageSource.gallery);
    setState(() {
      image = file;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    description.dispose();
  }

  postImage(String uid, String username, String profImage) async {
    setState(() {
      isLoading = true;
    });
    try {
      String message = await FirestoreMethods()
          .uploadPost(uid, image!, description.text, username, profImage);
      if (message == 'success') {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('posted')));
        setState(() {
          image = null;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('error')));
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    UserModel userModel = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            children: [
              Row(
                children: [
                  IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(CupertinoIcons.xmark)),
                  const SizedBox(
                    width: 70,
                  ),
                  const Text(
                    'Create post',
                    style: TextStyle(fontSize: 20),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () async {
                      await postImage(FirebaseAuth.instance.currentUser!.uid,
                          userModel.username, userModel.photo);
                      description.clear();
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.indigo,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      height: 37,
                      width: 55,
                      child: const Center(
                        child: Text(
                          'Share',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              isLoading ? const LinearProgressIndicator() : Container(),
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(userModel.photo),
                ),
                contentPadding: const EdgeInsets.only(left: 10),
                title:  Text(userModel.username),
              ),
              CustomTextFormField(
                controller: description,
                hintText: 'Write a post',
                keyboardType: TextInputType.text,
                icon: Icons.add,
              ),
              image == null
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        selectImage();
                      },
                      icon: const Icon(CupertinoIcons.photo)),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(child: const Text('Add photo'))
                ],
              )
                  : Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Container(
                    height: 400,
                    width: 350,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                            image: MemoryImage(image!), fit: BoxFit.cover)),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}