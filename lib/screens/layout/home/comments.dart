import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_3c/controller/comment_ctrl.dart';
import 'package:social_3c/screens/layout/home/widgets.dart';

import '../../../controller/auth_ctrl.dart';
import '../../_resources/assets_path/icon_broken.dart';
import '../../_resources/shared/toast.dart';

class CommentsPage extends StatefulWidget {
  const CommentsPage(this.postId, {super.key});

  final String postId;

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  @override
  void initState() {
    super.initState();
    context.read<CommentsCtrl>().fetchComments(widget.postId);
  }

  @override
  Widget build(BuildContext context) {
    final sender = context.read<AuthCtrl>().myData;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Comments'),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<CommentsCtrl, CommentsStates>(
              builder: (context, state) {
                if (state is GetCommentLoadingState) {
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
                if (state is GetCommentErrorState) {
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

                final cubit = context.read<CommentsCtrl>();
                if (cubit.comments.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          IconBroken.chat,
                          color: Colors.grey,
                          size: 150,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'There is no comments now,\ntry add one',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async => cubit.fetchComments(widget.postId),
                  child: ListView.builder(
                    itemBuilder: (context, index) => PostCardItem(
                      cubit.comments[index],
                      isComment: true,
                    ),
                    itemCount: cubit.comments.length,
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
                    controller: context.read<CommentsCtrl>().commentCtrl,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: "Write your comment...",
                        hintStyle:
                            const TextStyle(color: Colors.grey, fontSize: 14)),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (sender == null) {
                      AppToast.error("please login first");
                    } else {
                      context.read<CommentsCtrl>().newOrEditComment(
                            widget.postId,
                            sender,
                          );
                    }
                  },
                  icon: const Icon(
                    IconBroken.send,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
