import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_3c/ctrl/auth_ctrl.dart';
import 'package:social_3c/screens/_resourses/toast.dart';

import '../../../../ctrl/post_ctrl.dart';
import '../widgets.dart';

class CommentView extends StatelessWidget {
  const CommentView(this.postId, {super.key});

  final String postId;

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthCtrl>().myData;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<PostCtrl, PostStates>(
              builder: (context, state) {
                if (state is PostLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is PostErrorState) {
                  return const Center(child: Text("Error loading comments"));
                }
                final comments = context.read<PostCtrl>().comments;
                if (comments.isEmpty) {
                  return const Center(child: Text("No comments found"));
                }
                return RefreshIndicator(
                  onRefresh: () async =>
                      context.read<PostCtrl>().fetchComments(postId),
                  child: ListView.builder(
                    itemBuilder: (context, index) => PostItem(
                      comments[index],
                      postIdFromComment: postId,
                    ),
                    itemCount: comments.length,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: context.read<PostCtrl>().contentCtrl,
                    decoration: InputDecoration(
                      hintText: 'Write your comment',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (user == null) {
                      AppToast.error("Please sign in first");
                    } else {
                      context
                          .read<PostCtrl>()
                          .createOrEditComment(postId, user);
                    }
                  },
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
