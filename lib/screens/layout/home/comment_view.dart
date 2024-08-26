import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_3c/controller/comment_ctrl.dart';
import 'package:social_3c/screens/layout/home/widgets.dart';

import '../../../controller/auth_ctrl.dart';
import '../../_resources/assets_path/icon_broken.dart';
import '../../_resources/shared/toast.dart';

class CommentView extends StatelessWidget {
  const CommentView(this.postId, {super.key});

  final String postId;

  @override
  Widget build(BuildContext context) {
    final sender = context.read<AuthCtrl>().myData;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comment'),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<CommentCtrl, CommentStates>(
              builder: (context, state) {
                final cubit = context.read<CommentCtrl>();
                if (state is GetCommentsLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is GetCommentsErrorState) {
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
                          'Failed to load comments',
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
                          IconBroken.chat,
                          color: Colors.grey,
                          size: 100,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'No comments found',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  itemBuilder: (context, index) => PostCardItem(
                    cubit.posts[index],
                    isComment: true,
                    postIdFromComment: postId,
                  ),
                  itemCount: cubit.posts.length,
                );
              },
            ),
          ),
          BlocBuilder<CommentCtrl, CommentStates>(
            builder: (context, state) {
              final cubit = context.read<CommentCtrl>();
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    if (cubit.imgUrl != null || cubit.selectedImage != null)
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 200,
                            child: Card(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: cubit.selectedImage != null
                                  ? Image.file(
                                      File(cubit.selectedImage!.path),
                                      fit: BoxFit.cover,
                                    )
                                  : Image.network(
                                      cubit.imgUrl!,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.black38,
                            child: IconButton(
                              onPressed: () => cubit.clearSelectedImage(),
                              icon: const Icon(
                                IconBroken.delete,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    if (state is CreateCommentLoadingState)
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: LinearProgressIndicator(),
                      ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: cubit.contentCtrl,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              hintText: 'Write your comment...',
                              hintStyle: TextStyle(
                                color: Colors.grey.shade400,
                              ),
                              suffixIcon: IconButton(
                                icon: const Icon(
                                  IconBroken.image,
                                  color: Colors.green,
                                ),
                                onPressed: cubit.pickImage,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (sender == null) {
                              AppToast.error("Please Login first!");
                            } else {
                              cubit.createOrEdit(
                                postId: postId,
                                user: sender,
                              );
                            }
                          },
                          icon: const Icon(
                            IconBroken.send,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
