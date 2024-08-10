import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_3c/controller/posts_ctrl.dart';
import 'package:social_3c/screens/_resources/assets_path/icon_broken.dart';
import 'package:social_3c/screens/layout/home/widgets.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostsCtrl, PostsStates>(
      builder: (context, state) {
        if (state is GetPostLoadingState) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: Colors.green,
                ),
                SizedBox(height: 16),
                Text(
                  'Loading posts...',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }
        if (state is GetPostErrorState) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 150,
                ),
                SizedBox(height: 16),
                Text(
                  'Error while fetching posts',
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
              ],
            ),
          );
        }

        final cubit = context.read<PostsCtrl>();
        if (cubit.posts.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  IconBroken.category,
                  color: Colors.grey,
                  size: 150,
                ),
                SizedBox(height: 16),
                Text(
                  'There is no post now,\ntry add one',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async => cubit.fetchPosts(),
          child: ListView.builder(
            itemBuilder: (context, index) => PostCardItem(cubit.posts[index]),
            itemCount: cubit.posts.length,
          ),
        );
      },
    );
  }
}
