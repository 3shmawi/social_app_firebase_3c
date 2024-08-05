import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_3c/controller/post_ctrl.dart';
import 'package:social_3c/screens/_resources/assets_path/icon_broken.dart';
import 'package:social_3c/screens/layout/home/widgets.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostCtrl, PostStates>(
      builder: (context, state) {
        final cubit = context.read<PostCtrl>();
        if (state is GetPostsLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is GetPostsErrorState) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  IconBroken.lock,
                  color: Colors.red,
                  size: 100,
                ),
                SizedBox(height: 20),
                Text(
                  'Failed to load posts',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          );
        }
        if (cubit.posts.isEmpty) {
          return const Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                IconBroken.document,
                color: Colors.grey,
                size: 100,
              ),
              SizedBox(height: 20),
              Text(
                'No posts found',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ));
        }
        return ListView.builder(
          itemBuilder: (context, index) => PostCardItem(cubit.posts[index]),
          itemCount: cubit.posts.length,
        );
      },
    );
  }
}
