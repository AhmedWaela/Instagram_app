import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/models/commentModel.dart';
import 'package:project/methods/auth_methods.dart';
import 'package:project/methods/firestore_methods.dart';
import 'package:provider/provider.dart';

import '../provider/provider.dart';
import '../models/user.dart';

class Comments extends StatefulWidget {
  const Comments({super.key, this.snap});
  final snap;
  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {

  TextEditingController textEditingController = TextEditingController();
  CommentModel? _commentModel;


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    textEditingController.dispose();

  }

  // refresh()async{
  //   UserProvider userProvider =  Provider.of<UserProvider>(context);
  //   await userProvider.refresh(widget.snap['post id']);
  //   setState(() {
  //
  //   });
  @override
  Widget build(BuildContext context) {
    UserModel userModel = Provider.of<UserProvider>(context).getUser;
    // _commentModel = Provider.of<UserProvider>(context).getComment;
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').doc(widget.snap).collection('comments').snapshots() ,
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return  CustomCard(snap : snapshot.data!.docs[index]);
              },
            );
          }else{
            return Center(
              child: CircularProgressIndicator(),
            );
          }



        },
      ),
      appBar: AppBar(
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: Icon(CupertinoIcons.xmark)),
        title:  Text('Comments as ${userModel.username}'),
        centerTitle: true,
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 50,
          margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        padding: const EdgeInsets.only(left: 16,right: 16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(userModel.photo),
              ),
               Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16,left: 16),
                  child: TextField(
                    controller: textEditingController,
                    decoration: const InputDecoration(
                      hintText: 'Write a comment',
                      border: InputBorder.none
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
               await  FirestoreMethods().postComment(widget.snap, textEditingController.text, userModel.uid, userModel.username, userModel.photo);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.indigo,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  height: 37,
                  width: 70,
                  child: const Center(
                    child: Text('Comment',style: TextStyle(color: Colors.white),),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


class CustomCard extends StatefulWidget {
  const CustomCard({super.key, this.snap});
  final snap;
  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    // return Container(
      // child:  Row(
      //   children: [
      //     CircleAvatar(
      //       radius: 18,
      //       backgroundImage: NetworkImage(widget.snap['profilePic']),
      //     ),
      //     Padding(
      //         padding: EdgeInsets.only(left: 16),
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           RichText(text:  TextSpan(
      //             children: [
      //               TextSpan(
      //                 text: widget.snap['text'],
      //                 style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)
      //               ),
      //               TextSpan(
      //                   text: 'some description to insert',
      //                 style: TextStyle(color: Colors.black)
      //               )
      //             ]
      //           )),
      //           const Padding(
      //               padding: EdgeInsets.only(top: 4),
      //             child: Text('23/12/2023',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
      //           ),
      //         ],
      //       ),
      //     ),
      //     Spacer(),
      //     Container(
      //       padding: EdgeInsets.all(8),
      //       child: Icon(Icons.favorite,size: 16,),
      //     )
      //   ],
      // ),
      child: return ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(widget.snap['profilePic']),
        ),
        title: Text(widget.snap['name']),
        subtitle: Text(widget.snap['text']),
        trailing: IconButton(
          onPressed: () {
            User? user = FirebaseAuth.instance.currentUser;

            if (user != null) {
              final postRef = FirebaseFirestore.instance
                  .collection('posts')
                  .doc(widget.snap['post id']).collection('comments').doc(widget.snap['comment id']);

              postRef.get().then((DocumentSnapshot documentSnapshot) {
                if (documentSnapshot.exists) {
                  if (widget.snap['uid'] == user.uid) {
                    postRef.delete().then((_) {
                    }).catchError((error) {
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('You are not allowed to delete this comment.'),
                      ),
                    );
                  }
                } else {
                }
              }).catchError((error) {
              });
            } else {

            }
          },
          icon: Icon(Icons.more_horiz),
        ),
      );
    // );
  }
}

