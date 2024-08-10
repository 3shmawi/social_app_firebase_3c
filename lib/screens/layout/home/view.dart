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
        if (state is GetPostsLoadingState || state is DeletePostLoadingState) {
          return const Center(
            child: Card(
              elevation: 10,
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 20.0),
                    Text("Get Posts Loading..."),
                  ],
                ),
              ),
            ),
          );
        }

        if (state is GetPostsErrorState) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 150,
                ),
                SizedBox(height: 20.0),
                Text(
                  'No posts found.',
                  textAlign: TextAlign.center,
                ),
                Text(
                  'An error occurred while fetching posts.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
          );
        }
        final cubit = context.read<PostCtrl>();
        if (cubit.posts.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  IconBroken.category,
                  color: Colors.green,
                  size: 100,
                ),
                SizedBox(height: 20.0),
                Text(
                  'No posts found.',
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Please add your post',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          itemBuilder: (context, index) => PostCardItem(cubit.posts[index]),
          itemCount: cubit.posts.length,
        );
      },
    );
  }
}
