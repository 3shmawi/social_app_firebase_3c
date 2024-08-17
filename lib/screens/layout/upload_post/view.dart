import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_3c/controller/auth_ctrl.dart';
import 'package:social_3c/controller/layout_ctrl.dart';
import 'package:social_3c/controller/posts_ctrl.dart';
import 'package:social_3c/screens/_resources/assets_path/icon_broken.dart';
import 'package:social_3c/screens/_resources/shared/toast.dart';

class UploadPostView extends StatelessWidget {
  const UploadPostView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostsCtrl, PostsStates>(
      listener: (context, state) {
        if (state is GetPostSuccessState) {
          context.read<LayoutCtrl>().changeIndex(0);
        }
      },
      builder: (context, state) {
        final cubit = context.read<PostsCtrl>();
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextField(
                minLines: 5,
                maxLines: 5,
                controller: cubit.titleCtrl,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'write any thing you want...',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: double.infinity,
                    height: 250,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.green, width: 2),
                        borderRadius: BorderRadius.circular(20)),
                    child: cubit.image != null
                        ? Image.file(
                            File(cubit.image!.path),
                            fit: BoxFit.cover,
                          )
                        : cubit.imageUrl != null
                            ? Image.network(
                                cubit.imageUrl!,
                                fit: BoxFit.cover,
                              )
                            : Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      IconBroken.image,
                                      color: Colors.grey.shade400,
                                      size: 100,
                                    ),
                                    const SizedBox(height: 20.0),
                                    const Text(
                                      "Attach an Image (optional)",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.black38,
                    child: IconButton(
                      icon: const Icon(
                        IconBroken.image,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        cubit.pickImage();
                      },
                    ),
                  )
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
                    )),
                onPressed: state is UploadPostLoadingState
                    ? null
                    : () {
                        final user = context.read<AuthCtrl>().myData;
                        if (user == null) {
                          AppToast.error("Login to enable upload post");
                        } else {
                          cubit.newOrEditPost(user);
                        }
                      },
                child: Text(cubit.editedPost == null ? 'UPLOAD' : "EDIT"),
              ),
              if (state is UploadPostLoadingState)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: LinearProgressIndicator(
                    color: Colors.green,
                  ),
                ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
