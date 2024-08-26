import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_3c/controller/auth_ctrl.dart';
import 'package:social_3c/controller/comment_ctrl.dart';
import 'package:social_3c/controller/layout_ctrl.dart';
import 'package:social_3c/controller/like_ctrl.dart';
import 'package:social_3c/controller/post_ctrl.dart';
import 'package:social_3c/model/post.dart';
import 'package:social_3c/model/user.dart';
import 'package:social_3c/screens/_resources/shared/navigation.dart';
import 'package:social_3c/screens/layout/home/comment_view.dart';

import '../../_resources/assets_path/icon_broken.dart';

class PostCardItem extends StatelessWidget {
  const PostCardItem(
    this.post, {
    this.isComment = false,
    this.postIdFromComment,
    super.key,
  });

  final PostModel post;
  final bool isComment;
  final String? postIdFromComment;

  @override
  Widget build(BuildContext context) {
    final myData = context.read<AuthCtrl>().myData;
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 27,
                  backgroundColor: Colors.green,
                  child: CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(
                      'https://picsum.photos/150/150',
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.user.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          post.createdAt.toString(),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (post.user.id == myData!.id) _buildPopupMenuButton(context),
              ],
            ),
            const Divider(color: Colors.green),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                post.content,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            if (post.postImageUrl != null) ...[
              const SizedBox(height: 10),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(
                      post.postImageUrl!,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
            const Divider(color: Colors.green),
            if (!isComment)
              Row(
                children: [
                  StreamBuilder<List<UserModel>>(
                    stream: LikeCtrl().getLikes(post.postId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        final likes = snapshot.data;
                        if (likes == null || likes.isEmpty) {
                          return Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  LikeCtrl().likeUnLike(
                                    postId: post.postId,
                                    isLiked: false,
                                    user: myData,
                                  );
                                },
                                icon: const Icon(IconBroken.heart),
                              ),
                              const Text("Love"),
                            ],
                          );
                        }
                        bool isLiked = false;
                        for (var like in likes) {
                          if (like.id == myData.id) {
                            isLiked = true;
                            break;
                          }
                        }
                        return Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                LikeCtrl().likeUnLike(
                                  postId: post.postId,
                                  isLiked: isLiked,
                                  user: myData,
                                );
                              },
                              icon: Icon(
                                isLiked
                                    ? CupertinoIcons.heart_fill
                                    : IconBroken.heart,
                                color: Colors.red,
                              ),
                            ),
                            Text("${likes.length} Likes"),
                          ],
                        );
                      }
                      return Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              LikeCtrl().likeUnLike(
                                postId: post.postId,
                                isLiked: false,
                                user: myData,
                              );
                            },
                            icon: const Icon(IconBroken.heart),
                          ),
                          const Text("Love"),
                        ],
                      );
                    },
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      context.read<CommentCtrl>().getComment(post.postId);
                      toPage(context, CommentView(post.postId));
                    },
                    icon: const Icon(IconBroken.chat),
                  ),
                  const Text("Comments"),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(IconBroken.send),
                  ),
                  const Text("Share"),
                ],
              )
          ],
        ),
      ),
    );
  }

  PopupMenuButton<int> _buildPopupMenuButton(BuildContext context) {
    return PopupMenuButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      icon: const Icon(IconBroken.moreSquare),
      onSelected: (index) {
        if (index == 0) {
          if (isComment) {
            context.read<CommentCtrl>().enableEditComment(post);
          } else {
            context.read<LayoutCtrl>().changeIndex(2);
            context.read<PostCtrl>().enableEditPost(post);
          }
        } else if (index == 1) {
          if (isComment) {
            context
                .read<CommentCtrl>()
                .deleteComment(postIdFromComment!, post.postId);
          } else {
            context.read<PostCtrl>().deletePost(post.postId);
          }
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 0,
          child: Row(
            children: [
              Icon(
                IconBroken.edit,
                color: Colors.blue.shade900,
              ),
              const SizedBox(width: 10),
              Text(
                'Edit',
                style: TextStyle(color: Colors.blue.shade900),
              ),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 1,
          child: Row(
            children: [
              Icon(
                IconBroken.delete,
                color: Colors.red,
              ),
              SizedBox(width: 10),
              Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
