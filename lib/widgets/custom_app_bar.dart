import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          'assets/images/belo (1).png',
          height: 50,
          width: 50,
        ),
        const SizedBox(
          width: 5,
        ),
        const Text('YLY NEWS',style: TextStyle(fontSize: 21,color: Color(0xff15035d),fontWeight: FontWeight.bold),),
        const Spacer(),
        IconButton(
            onPressed: () {},
            icon: const Icon(CupertinoIcons.bubble_left_bubble_right))
      ],
    );
  }
}