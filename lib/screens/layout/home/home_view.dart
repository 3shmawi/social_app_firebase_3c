import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_3c/ctrl/post_ctrl.dart';
import 'package:social_3c/screens/layout/home/widgets.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostCtrl, PostStates>(
      builder: (context, state) {
        if (state is PostLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is PostErrorState) {
          return const Center(child: Text("Error loading posts"));
        }
        final posts = context.read<PostCtrl>().posts;
        if (posts.isEmpty) {
          return const Center(child: Text("No posts found"));
        }
        return RefreshIndicator(
          onRefresh: () async => context.read<PostCtrl>().refresh(),
          child: ListView.builder(
            itemBuilder: (context, index) => PostItem(posts[index]),
            itemCount: posts.length,
          ),
        );
      },
    );
  }
}
