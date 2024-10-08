import 'package:flutter/material.dart';
import 'package:social_3c/app/constants.dart';
import 'package:social_3c/screens/_resources/assets_path/icon_broken.dart';

import '../../../app/functions.dart';

class ChatItem extends StatelessWidget {
  const ChatItem({
    required this.img,
    required this.name,
    required this.lastMessage,
    required this.date,
    this.isStartWithArabic = false,
    this.isOpened,
    this.onTap,
    super.key,
  });

  final String date;
  final String name;
  final String lastMessage;
  final String img;
  final bool isStartWithArabic;
  final GestureTapCallback? onTap;
  final bool? isOpened;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isOpened == null ? null : Colors.grey.shade400,
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        horizontalTitleGap: 0,
        contentPadding: const EdgeInsets.symmetric(vertical: 8),
        titleAlignment: ListTileTitleAlignment.center,
        subtitle: Row(
          children: [
            Expanded(
              child: Text(
                lastMessage,
                maxLines: isOpened == null ? 1 : 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w300,
                    ),
              ),
            ),
            Text(
              daysBetween(DateTime.parse(date)),
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
        title: Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
        ),
        leading: CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage: NetworkImage(img),
        ),
        trailing: const SizedBox.shrink(),
        onTap: onTap,
      ),
    );
  }
}

class RightMessage extends StatelessWidget {
  const RightMessage(this.message, this.time, {this.onSelected, super.key});

  final String message;
  final String time;
  final PopupMenuItemSelected<int>? onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Row(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    0,
                    14,
                    14,
                    0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: message != AppConstants.deleteMessage
                              ? Colors.green.shade700
                              : Colors.grey.shade300,
                          border: Border.all(color: Colors.grey),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Text(
                          message != AppConstants.deleteMessage
                              ? message
                              : "This message is deleted",
                          textAlign: isStartWithArabic(message)
                              ? TextAlign.start
                              : TextAlign.end,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                        ),
                      ),
                      if (message != AppConstants.deleteMessage)
                        Text(
                          daysBetween(DateTime.parse(time)),
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                    ],
                  ),
                ),
              ),
              if (message != AppConstants.deleteMessage)
                PopupMenuButton(
                  icon: const Icon(
                    IconBroken.moreCircle,
                    color: Colors.grey,
                  ),
                  onSelected: onSelected,
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 0,
                      child: Row(
                        children: [
                          Icon(
                            IconBroken.edit,
                            color: Colors.blue,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Edit",
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          )
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
                            "Delete",
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        const Expanded(flex: 1, child: SizedBox()),
      ],
    );
  }
}

class LeftMessage extends StatelessWidget {
  const LeftMessage(this.message, this.time, {super.key});

  final String message;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(flex: 1, child: SizedBox()),
        Expanded(
          flex: 2,
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                14,
                14,
                0,
                0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(.3),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Text(
                      message != AppConstants.deleteMessage
                          ? message
                          : "This message is deleted",
                      textAlign: isStartWithArabic(message)
                          ? TextAlign.start
                          : TextAlign.end,
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                  if (message != AppConstants.deleteMessage)
                    Text(
                      daysBetween(DateTime.parse(time)),
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
