import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_3c/controller/auth_ctrl.dart';
import 'package:social_3c/controller/post_ctrl.dart';
import 'package:social_3c/screens/_resources/shared/toast.dart';

import '../../_resources/assets_path/icon_broken.dart';

class CreatePostView extends StatelessWidget {
  const CreatePostView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCtrl, PostStates>(
      listener: (context, state) {
        if (state is GetPostsSuccessState) {}
      },
      builder: (context, state) {
        final cubit = context.read<PostCtrl>();
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextField(
                controller: cubit.contentCtrl,
                maxLines: 5,
                minLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'Write post content...',
                  hintStyle: TextStyle(
                      color: Colors.grey.shade500, fontWeight: FontWeight.w300),
                ),
              ),
              const SizedBox(height: 20),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: double.infinity,
                    height: 250,
                    decoration: BoxDecoration(
                      image: cubit.selectedImage != null
                          ? DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(
                                File(
                                  cubit.selectedImage!.path,
                                ),
                              ),
                            )
                          : null,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.green,
                        width: 2,
                      ),
                    ),
                    child: cubit.selectedImage == null
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  IconBroken.image2,
                                  color: Colors.green,
                                  size: 100,
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'Select Post image(optional)',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          )
                        : null,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.black38,
                    child: IconButton(
                      icon: const Icon(
                        Icons.camera_alt,
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
                onPressed: state is CreatePostLoadingState
                    ? null
                    : () {
                        final user = context.read<AuthCtrl>().myData;
                        if (user == null) {
                          AppToast.error(
                              "You must be logged in to create a new post");
                        } else {
                          cubit.createPost(user);
                        }
                      },
                child: const Text('CREATE'),
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
