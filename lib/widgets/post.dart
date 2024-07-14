import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/screens/profile_screen.dart';
import '../screens/comments.dart';
class Post extends StatefulWidget {
  const Post({super.key, this.snap});
  final snap;

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {

  bool isLikes = false;

  double containerWidth = 0;
  double containerHeight = 0;
  double imageAspectRatio = 1.0; // Default aspect ratio

  @override
  void initState() {
    super.initState();
    _getImageSize();
  }

  void _getImageSize() async {
    Image image = Image.network(widget.snap['photo']);
    Completer<Size> completer = Completer();
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(Size(info.image.width.toDouble(), info.image.height.toDouble()));
      }),
    );

    Size imageSize = await completer.future;
    setState(() {
      // Calculate aspect ratio to maintain proportions
      imageAspectRatio = imageSize.width / imageSize.height;
      // Set container width and height based on image dimensions
      containerWidth = imageSize.width;
      containerHeight = imageSize.height;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ProfileScreen(uid: widget.snap['uid'],snap: widget.snap,);
            },));
          },
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
                widget.snap['profImage']
            ),
          ),
          title: Text(
              widget.snap['username']
          ),
          subtitle: const Text('2h'),
          trailing: IconButton(
              onPressed: () {
                User? user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  final postRef = FirebaseFirestore.instance
                      .collection('posts')
                      .doc(
                      widget.snap['post id']
                  );

                  postRef.get().then((DocumentSnapshot documentSnapshot) {
                    if (documentSnapshot.exists) {
                      if (widget.snap['uid'] == user.uid) {
                        postRef.delete();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'You are not allowed to delete this post.'),
                          ),
                        );
                      }
                    }
                  }).catchError((error) {
                  });
                }
              },
              icon: const Icon(
                  Icons.more_horiz,
              ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 5,right: 15),
          child: Text(
              widget.snap['description']
          ),
        ),
        Container(
          width: containerHeight,
          height: containerWidth,
          child: Image(
            fit: BoxFit.cover,
            image: NetworkImage(
            widget.snap['photo'],
          ),),
          // child: AspectRatio(
          //   aspectRatio: imageAspectRatio,
          //   child: Image.network(
          //     widget.snap['photo'],
          //     fit: BoxFit.fitWidth,
          //   ),
          // ),
        ),
        Row(
          children: [
            IconButton(
                onPressed: () {
                  User? user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    FirebaseFirestore.instance
                        .collection('posts')
                        .doc(widget.snap['post id'])
                        .get()
                        .then((DocumentSnapshot documentSnapshot) {
                      if (documentSnapshot.exists) {
                        List<dynamic> likes = widget.snap['likes'] ?? [];

                        if (likes.contains(user.uid)) {
                          likes.remove(user.uid);
                          setState(() {
                            isLikes = false;
                          });
                        } else {
                          likes.add(user.uid);
                          setState(() {
                            isLikes = true;
                          });
                        }
                        FirebaseFirestore.instance
                            .collection('posts')
                            .doc(widget.snap['post id'])
                            .update({'likes': likes}).then((value) {
                        }).catchError((error) {
                        });
                      }
                    }).catchError((error) {
                    });
                  }
                },
                icon: isLikes ?
                const Icon(
                  Icons.favorite,
                  color: Colors.red,
                ): const Icon(
                    Icons.favorite_border,
                ),
            ),
            Text(
                '${widget.snap['likes'].length}'
            ),
            IconButton(
              onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                return Comments(
                  snap: widget.snap['post id'],
                );
              },
                  ),
              );
            },
              icon: const Icon(
                Icons.comment,
            ),
            ),
            // Text('${widget.snap[p]}')
          ],
        )
      ],
    );
  }
}



//     .then((_) {
// }).catchError((error) {
// });

