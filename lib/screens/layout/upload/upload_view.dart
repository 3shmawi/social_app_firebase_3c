import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_3c/ctrl/auth_ctrl.dart';
import 'package:social_3c/ctrl/post_ctrl.dart';
import 'package:social_3c/screens/_resourses/toast.dart';

class UploadView extends StatelessWidget {
  const UploadView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthCtrl>().myData;
    return BlocBuilder<PostCtrl, PostStates>(
      builder: (context, state) {
        final cubit = context.read<PostCtrl>();
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              TextField(
                controller: cubit.contentCtrl,
                maxLines: 5,
                minLines: 5,
                decoration: InputDecoration(
                  hintText: 'Enter your caption',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    height: 250,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green, width: 2),
                      borderRadius: BorderRadius.circular(10),
                      image: cubit.selectedImage != null
                          ? DecorationImage(
                              image: FileImage(
                                File(cubit.selectedImage!.path),
                              ),
                              fit: BoxFit.cover,
                            )
                          : cubit.imgUrl != null
                              ? DecorationImage(
                                  image: NetworkImage(cubit.imgUrl!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                    ),
                    child: cubit.selectedImage == null && cubit.imgUrl == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.image,
                                color: Colors.grey,
                                size: 125,
                              ),
                              Text(
                                'Select a picture(optional)',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ],
                          )
                        : null,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: cubit.clearSelectedImg,
                        child: CircleAvatar(
                          backgroundColor: Colors.grey.shade400,
                          child: const Icon(
                            Icons.delete_outline,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: cubit.pickImg,
                        child: CircleAvatar(
                          backgroundColor: Colors.grey.shade400,
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: state is PostLoadingState
                    ? null
                    : () {
                        if (user == null) {
                          AppToast.error("Please login first");
                        } else {
                          cubit.createOrEditPost(user);
                        }
                      },
                child: Text(
                  cubit.editedPost == null ? "UPLOAD" : "EDIT",
                ),
              ),
              if (state is PostLoadingState)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: LinearProgressIndicator(),
                )
            ],
          ),
        );
      },
    );
  }
}
