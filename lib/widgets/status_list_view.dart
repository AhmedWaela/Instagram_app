import 'package:flutter/material.dart';
import 'package:project/widgets/story.dart';

class StatusListView extends StatelessWidget {
  const StatusListView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: 1,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return const Story();
        },
      ),
    );
  }
}