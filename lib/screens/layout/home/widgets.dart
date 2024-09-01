import 'package:flutter/material.dart';

class PostItem extends StatelessWidget {
  const PostItem({super.key});

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
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Mohamed Ashraf",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "now",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              PopupMenuButton(
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    child: Text("Delete"),
                    value: 1,
                  ),
                  const PopupMenuItem(
                    child: Text("Edit"),
                    value: 2,
                  ),
                ],
              ),
            ],
          ),
          const Divider(
            color: Colors.grey,
          ),
          const Align(
            alignment: Alignment.topLeft,
            child: Text(
              " s sdf sdf sdf sdf sdf",
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 250,
            width: double.infinity,
            child: Card(),
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
