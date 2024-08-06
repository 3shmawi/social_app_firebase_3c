import 'package:flutter/material.dart';
import 'package:social_3c/model/post.dart';

import '../../_resources/assets_path/icon_broken.dart';

class PostCardItem extends StatelessWidget {
  const PostCardItem(this.post, {super.key});

  final PostModel post;

  @override
  Widget build(BuildContext context) {
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
                    backgroundImage: NetworkImage(
                      post.user.imgUrl,
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
                _buildPopupMenuButton(),
              ],
            ),
            const Divider(color: Colors.green),
            Text(
              post.content,
              style: const TextStyle(fontSize: 16),
            ),
            if (post.mediaUrl != null) ...[
              const SizedBox(height: 10),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(
                      post.mediaUrl!,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
            const Divider(color: Colors.green),
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(IconBroken.heart),
                ),
                const Text("Love"),
                const Spacer(),
                IconButton(
                  onPressed: () {},
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

  PopupMenuButton<int> _buildPopupMenuButton() {
    return PopupMenuButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      icon: const Icon(IconBroken.moreSquare),
      onSelected: (index) {},
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
