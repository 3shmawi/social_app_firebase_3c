import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_3c/controller/auth_ctrl.dart';
import 'package:social_3c/controller/layout_ctrl.dart';
import 'package:social_3c/controller/post_ctrl.dart';
import 'package:social_3c/screens/_resources/assets_path/icon_broken.dart';
import 'package:social_3c/screens/_resources/shared/toast.dart';

class CreatePostView extends StatelessWidget {
  const CreatePostView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCtrl, PostStates>(
      listener: (context, state) {
        if (state is GetPostsSuccessState) {
          context.read<LayoutCtrl>().changeIndex(0);
        }
      },
      builder: (context, state) {
        final cubit = context.read<PostCtrl>();
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextField(
                controller: cubit.contentCtrl,
                minLines: 5,
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'Write your post content...',
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 250,
                    decoration: BoxDecoration(
                      image: cubit.selectedMedia != null
                          ? DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(
                                File(
                                  cubit.selectedMedia!.path,
                                ),
                              ),
                            )
                          : cubit.imgUrl != null
                              ? DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(cubit.imgUrl!),
                                )
                              : null,
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: cubit.selectedMedia == null && cubit.imgUrl == null
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  IconBroken.paperUpload,
                                  color: Colors.green,
                                  size: 100,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Attach images or videos (optional)',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : null,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.black38,
                        child: IconButton(
                          onPressed: () {
                            cubit.pickMedia();
                          },
                          icon: const Icon(
                            Icons.photo_camera,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.black38,
                        child: IconButton(
                          onPressed: () {
                            cubit.clearMedia();
                          },
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: state is CreatePostLoadingState
                    ? null
                    : () {
                        final user = context.read<AuthCtrl>().myData;

                        if (user == null) {
                          AppToast.error("You must login to create a new post");
                        } else {
                          cubit.createOrEditPost(user);
                        }
                      },
                child: Text(cubit.post == null ? 'CREATE' : "EDIT"),
              ),
              if (state is CreatePostLoadingState)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: LinearProgressIndicator(
                    color: Colors.green,
                  ),
                ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
