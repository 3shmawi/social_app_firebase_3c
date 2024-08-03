import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_3c/controller/posts_ctrl.dart';
import 'package:social_3c/screens/layout/home/widgets.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostsCtrl, PostsStates>(
      builder: (context, state) {
        final cubit = context.read<PostsCtrl>();
        return ListView.builder(
          itemBuilder: (context, index) => PostCardItem(cubit.posts[index]),
          itemCount: cubit.posts.length,
        );
      },
    );
  }
}
