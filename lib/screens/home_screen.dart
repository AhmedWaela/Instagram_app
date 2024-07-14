import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/provider.dart';
import '../models/user.dart';
import '../widgets/custom_add_post_.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/post.dart';
import '../widgets/status_list_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    UserModel userModel = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(
                child: CustomAppBar(),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 40,
                ),
              ),
              const SliverToBoxAdapter(
                child: StatusListView(),
              ),
              const SliverToBoxAdapter(
                child: Divider(
                  height: 1,
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 5,
                ),
              ),
              SliverToBoxAdapter(
                child: GestureDetector(
                  onTap: () async {
                    UserProvider userProvider =
                        Provider.of(context, listen: false);
                    await userProvider.refreshUser();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const CustomAddPostAppBar();
                        },
                      ),
                    );
                  },
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(userModel.photo),
                    ),
                    title: const Text('Write a Post'),
                    trailing: IconButton(
                      onPressed: () {},
                      icon: const Icon(CupertinoIcons.photo),
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 5,
                ),
              ),
              const SliverToBoxAdapter(
                child: Divider(
                  height: 1,
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 20,
                ),
              ),
              StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('posts').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SliverToBoxAdapter(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      childCount: snapshot.data!.docs.length,
                      (context, index) {
                        return Post(
                          snap: snapshot.data!.docs[index],
                        );
                      },
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
