import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/provider.dart';
import '../models/user.dart';

class Story extends StatelessWidget {
  const Story({super.key});

  @override
  Widget build(BuildContext context) {
    UserModel userModel = Provider.of<UserProvider>(context).getUser;
    return Padding(
      padding: const EdgeInsets.only(
        right: 8,
      ),
      child: Stack(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundImage: NetworkImage(
              userModel.photo,
            ),
          ),
          const Positioned(
            right: 2,
            bottom: 15,
            child: CircleAvatar(
              backgroundColor: Color(
                0xff1c0759,
              ),
              radius: 9,
              child: Center(
                child: Icon(
                  Icons.add,
                  size: 13,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
