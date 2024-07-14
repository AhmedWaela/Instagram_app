import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/models/user.dart';
import 'package:project/provider/provider.dart';
import 'package:project/screens/posts_screen.dart';
import 'package:provider/provider.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.uid, this.snap});
  final String uid;
  final snap;
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData ={};
  int? postLength = 0;
  int? followers;
  int? following;
  getData()async{
    try{
      var snap = await FirebaseFirestore.instance.collection('users').doc(widget.uid).get();
      var snapshot = await FirebaseFirestore.instance.collection('posts').where('uid',isEqualTo: widget.uid).get();
    setState(() {
      userData = snap.data()!;
      postLength = snapshot.docs.length;
      followers = snap.data()!['followers'].length;
      following = snap.data()!['following'].length;

    });
    }catch(e){}

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
  @override
  Widget build(BuildContext context) {
    UserModel userModel = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(onPressed: () {
                  Navigator.pop(context);
                }, icon: const Icon(Icons.arrow_back)),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: FirebaseAuth.instance.currentUser!.uid == widget.uid ? CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(userModel.photo),
                      ):CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(widget.snap['profImage']),
                      ),
                    ),
                    const SizedBox(
                      width: 80,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              postLength != null ? Text('$postLength',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),):Text(''),
                              const Text('posts',)
                            ],
                          ),
                          Column(
                            children: [
                              followers != null?  Text('$followers',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)):Text(''),
                              const Text('followers'),
                            ],
                          ),
                          Column(
                            children: [
                              following != null ?  Text('$following',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)): Text(''),
                              const Text('following')
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20,right: 10),
                      child: FirebaseAuth.instance.currentUser!.uid == widget.uid ? Text(userModel.username,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)):
                      Text(widget.snap['username'],style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
                    ),
                    Expanded(child: FirebaseAuth.instance.currentUser!.uid == widget.uid ?
                    Container(
                      padding: const EdgeInsets.only(top: 20),
                      child: TextButton(onPressed: () {

                      }, child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        alignment: Alignment.center,
                        child: const Text('edit',style: TextStyle(color: Colors.black),),
                      )),
                    ): Container(
                      padding: const EdgeInsets.only(top: 20),
                      child: TextButton(onPressed: () {

                      }, child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        alignment: Alignment.center,
                        child: const Text('follow',style: TextStyle(color: Colors.black),),
                      )),
                    ) ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            FutureBuilder(
                future: FirebaseFirestore.instance.collection('posts').where('uid',isEqualTo: widget.uid).get(),
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                    return GridView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 20,
                          crossAxisCount: 3),
                      itemBuilder: (context, index) {
                        DocumentSnapshot snap= (snapshot.data! as dynamic).docs[index];
                        return GestureDetector(
                          onTap: () {
                            // Navigator.push(context, MaterialPageRoute(builder: (context) {
                            //   return  PostsScreen(postSnapshot: snapshot.data!.docs[index],);
                            // },));
                          },
                          child: Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                                image: DecorationImage(image: NetworkImage(snap['photo']),fit: BoxFit.fitWidth)
                            ),
                          ),
                        );
                      },);
                  }else{
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                },
            )
          ],
        ),
      ),
    );
  }
}











