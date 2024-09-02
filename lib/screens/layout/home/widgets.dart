import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_3c/ctrl/layout_ctrl.dart';
import 'package:social_3c/ctrl/post_ctrl.dart';

import '../../../model/post.dart';

class PostItem extends StatelessWidget {
  const PostItem(this.post, {super.key});

  final PostModel post;

  @override
  Widget build(BuildContext context) {
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
              const CircleAvatar(
                backgroundColor: Colors.cyan,
                radius: 35,
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
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              PopupMenuButton(
                onSelected: (value) {
                  if (value == 2) {
                    context.read<PostCtrl>().deletePost(post.postId);
                  } else if (value == 1) {
                    context.read<PostCtrl>().enableEditPost(post);
                    context.read<LayoutCtrl>().changeIndex(2);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    child: Text("Edit"),
                    value: 1,
                  ),
                  const PopupMenuItem(
                    child: Text("Delete"),
                    value: 2,
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
          Row(
            children: [
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
              ),
              const Text("Love"),
              const Spacer(
                flex: 5,
              ),
              IconButton(
                onPressed: () {},
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
                onPressed: () {},
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
}
