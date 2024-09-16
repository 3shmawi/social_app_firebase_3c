import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:social_3c/ctrl/auth_ctrl.dart';
import 'package:social_3c/ctrl/layout_ctrl.dart';
import 'package:social_3c/ctrl/post_ctrl.dart';
import 'package:social_3c/model/user.dart';
import 'package:social_3c/screens/_resourses/navigation.dart';
import 'package:social_3c/screens/layout/home/comments/comment_view.dart';

import '../../../model/post.dart';

class PostItem extends StatelessWidget {
  const PostItem(this.post, {this.postIdFromComment, super.key});

  final PostModel post;
  final String? postIdFromComment;

  @override
  Widget build(BuildContext context) {
    final myData = context.read<AuthCtrl>().myData;
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          color: Colors.green,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.cyan,
                radius: 35,
                backgroundImage: NetworkImage(post.user.imgUrl),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.user.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      post.createdAt.toString(),
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              if (post.user.id == myData!.id)
                PopupMenuButton(
                  onSelected: (value) {
                    if (value == 2) {
                      if (postIdFromComment == null) {
                        context.read<PostCtrl>().deletePost(post.postId);
                      } else {
                        context
                            .read<PostCtrl>()
                            .deleteComment(postIdFromComment!, post.postId);
                      }
                    } else if (value == 1) {
                      if (postIdFromComment == null) {
                        context.read<PostCtrl>().enableEditPost(post);
                        context.read<LayoutCtrl>().changeIndex(2);
                      } else {
                        context.read<PostCtrl>().enableEditPost(post);
                      }
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 1,
                      child: Text("Edit"),
                    ),
                    const PopupMenuItem(
                      value: 2,
                      child: Text("Delete"),
                    ),
                  ],
                ),
            ],
          ),
          const Divider(
            color: Colors.grey,
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              post.content,
              textAlign: TextAlign.center,
            ),
          ),
          if (post.postImgUrl != null)
            SizedBox(
              height: 250,
              width: double.infinity,
              child: Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Image.network(
                  post.postImgUrl!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          if (postIdFromComment == null)
            Row(
              children: [
                const Spacer(),
                StreamBuilder<List<UserModel>>(
                    stream: context.read<PostCtrl>().getLikes(post.postId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        final likes = snapshot.data;

                        if (likes == null || likes.isEmpty) {
                          return Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  context.read<PostCtrl>().likeUnLike(
                                        postId: post.postId,
                                        user: myData,
                                        isLiked: false,
                                      );
                                },
                                icon: const Icon(
                                  Icons.favorite_border,
                                  color: Colors.red,
                                ),
                              ),
                              const Text("Love"),
                            ],
                          );
                        }
                        bool isLiked = false;

                        for (UserModel user in likes) {
                          if (user.id == myData.id) {
                            isLiked = true;
                            break;
                          }
                        }
                        return Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                context.read<PostCtrl>().likeUnLike(
                                      postId: post.postId,
                                      user: myData,
                                      isLiked: isLiked,
                                    );
                              },
                              icon: Icon(
                                isLiked
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Colors.red,
                              ),
                            ),
                            Text("${likes.length} Love"),
                          ],
                        );
                      }
                      return Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              context.read<PostCtrl>().likeUnLike(
                                    postId: post.postId,
                                    user: myData,
                                    isLiked: false,
                                  );
                            },
                            icon: const Icon(
                              Icons.favorite_border,
                              color: Colors.red,
                            ),
                          ),
                          const Text("Love"),
                        ],
                      );
                    }),
                const Spacer(
                  flex: 5,
                ),
                IconButton(
                  onPressed: () {
                    context.read<PostCtrl>().fetchComments(post.postId);
                    push(context, CommentView(post.postId));
                  },
                  icon: const Icon(
                    Icons.chat,
                    color: Colors.grey,
                  ),
                ),
                const Text("Comments"),
                const Spacer(
                  flex: 5,
                ),
                IconButton(
                  onPressed: () async {
                    if (post.postImgUrl == null) {
                      await Share.share(post.content,
                          subject: 'Look what ${post.user.name} made!');
                    } else {
                      sharePostWithImage(post.postImgUrl!, post.content);
                    }
                  },
                  icon: const Icon(
                    Icons.share,
                    color: Colors.green,
                  ),
                ),
                const Text("Share"),
                const Spacer(),
              ],
            )
        ],
      ),
    );
  }

  Future<void> sharePostWithImage(String imageUrl, String content) async {
    try {
      // Get the app's temporary directory
      final directory = await getTemporaryDirectory();

      // Define the image path to save the downloaded image
      String imagePath = '${directory.path}/shared_image.jpg';

      // Download the image from the URL
      Dio dio = Dio();
      await dio.download(imageUrl, imagePath);

      // Share the image and content
      Share.shareXFiles([XFile(imagePath)], text: content);
    } catch (e) {
      print('Error downloading or sharing the image: $e');
    }
  }
}
