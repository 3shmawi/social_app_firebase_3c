import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_3c/controller/auth_ctrl.dart';
import 'package:social_3c/controller/layout_ctrl.dart';
import 'package:social_3c/controller/like_ctrl.dart';
import 'package:social_3c/controller/posts_ctrl.dart';
import 'package:social_3c/model/post.dart';
import 'package:social_3c/model/user.dart';
import 'package:social_3c/screens/_resources/shared/navigation.dart';
import 'package:social_3c/screens/layout/home/comments.dart';
import 'package:social_3c/services/local_storage.dart';

import '../../_resources/assets_path/icon_broken.dart';

class PostCardItem extends StatelessWidget {
  const PostCardItem(this.post, {this.isComment = false, super.key});

  final PostModel post;
  final bool isComment;

  @override
  Widget build(BuildContext context) {
    final myId = CacheHelper.getData(key: "myId");
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
                CircleAvatar(
                  radius: 27,
                  backgroundColor: Colors.green,
                  child: CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(post.user.imgUrl),
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
                if (post.user.id == myId) _buildPopupMenuButton(context),
              ],
            ),
            const Divider(color: Colors.green),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                post.title,
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
                    image: NetworkImage(post.postImageUrl!),
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
                    stream: LikeCtrl().likes(post.postId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        final likes = snapshot.data;

                        if (likes == null || likes.isEmpty) {
                          return GestureDetector(
                            onTap: () {
                              LikeCtrl().like(
                                postId: post.postId,
                                myData: myData!,
                                isLiked: false,
                              );
                            },
                            child: const Row(
                              children: [
                                SizedBox(width: 5),
                                Icon(
                                  IconBroken.heart,
                                  color: Colors.red,
                                ),
                                SizedBox(width: 5),
                                Text("Likes"),
                              ],
                            ),
                          );
                        }
                        bool isLiked = false;
                        for (final like in likes) {
                          if (like.id == myData!.id) {
                            isLiked = true;
                            break;
                          }
                        }

                        return GestureDetector(
                          onTap: () {
                            LikeCtrl().like(
                              postId: post.postId,
                              myData: myData!,
                              isLiked: isLiked,
                            );
                          },
                          child: Row(
                            children: [
                              const SizedBox(width: 5),
                              Icon(
                                isLiked
                                    ? CupertinoIcons.heart_fill
                                    : IconBroken.heart,
                                color: Colors.red,
                              ),
                              const SizedBox(width: 5),
                              Text("${likes.length} Likes"),
                            ],
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      toPage(context, CommentsPage(post.postId));
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
          context.read<PostsCtrl>().editPost(post);
          context.read<LayoutCtrl>().changeIndex(2);
        } else if (index == 1) {
          context.read<PostsCtrl>().deletePost(post.postId);
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
