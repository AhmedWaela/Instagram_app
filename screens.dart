import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/screens/home_screen.dart';
import 'package:project/screens/profile_screen.dart';

List<Widget> screens = [
  const HomeScreen(),
  TracksGirdView(),
   ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid,)
];


class TracksGirdView extends StatelessWidget {
   TracksGirdView({super.key});
  final List<TrackModel> tracks = [
    TrackModel(title: 'Social Media', image: 'assets/images/content-strategy.png'),
    TrackModel(title: 'Public Relation', image: 'assets/images/icons8-public-relation-64.png'),
    TrackModel(title: 'Training', image: 'assets/images/Training Courses.png'),
    TrackModel(title: 'Human Resources', image: 'assets/images/Human resources.png'),
    TrackModel(title: 'OR', image: 'assets/images/Event planning.png'),
    TrackModel(title: 'Media', image: 'assets/images/Social-Media-Free-Download-PNG.png'),
  ];
  @override
  Widget build(BuildContext context) {
    return
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Column(
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: tracks.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: 220,
                        crossAxisCount: 2),
                    itemBuilder: (context, index) {
                      return Track(trackModel: tracks[index]);
                    },),
                const Expanded( 
                  child: Card(
                      child: Row(
                        children: [
                          Image(image: AssetImage('assets/images/9321618.png'),width: 100,),
                          SizedBox(
                            width: 95,
                          ),
                          Text('R&D',style: TextStyle(fontSize: 20),)
                        ],
                      ),
                  ),
                )
              ],
            ),
          ),
        );
  }
}


class Track extends StatelessWidget {
  const Track({super.key, required this.trackModel});
  final TrackModel trackModel;
  @override
  Widget build(BuildContext context) {
    return  Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(trackModel.image,height: 100,),
          const SizedBox(
            height: 15,
          ),
          Text(trackModel.title,style: const TextStyle(fontSize: 20),),
        ],
      ),
    );
  }
}



class TrackModel{
  final String title;
  final String image;

  TrackModel({required this.title, required this.image});
}
