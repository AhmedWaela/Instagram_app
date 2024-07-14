// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// class PostsScreen extends StatefulWidget {
//   final DocumentSnapshot postSnapshot;
//
//   const PostsScreen({required this.postSnapshot});
//
//   @override
//   State<PostsScreen> createState() => _PostsScreenState();
// }
//
// class _PostsScreenState extends State<PostsScreen> {
//   bool isLiked = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: const Icon(Icons.arrow_back_ios),
//         ),
//         title: Text('Post Details'),
//       ),
//       body: Column(
//         children: [
//           Container(
//             height: 500,
//             width: double.infinity,
//             decoration: BoxDecoration(
//               image: DecorationImage(image: NetworkImage(widget.postSnapshot['photo']))
//             ),
//           ),
//           IconButton(onPressed: () {
//
//           },
//               icon: const Icon(Icons.favorite_border)),
//           Text('${widget.postSnapshot['likes'].length}')
//         ],
//       ),
//     );
//   }
// }
