import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_3c/controller/settings_ctrl.dart';
import 'package:social_3c/model/user.dart';

import '../../_resources/assets_path/icon_broken.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage(this.user, {super.key});

  final UserModel user;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<SettingsCtrl>().enableEdit(widget.user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: BlocListener<SettingsCtrl, SettingsStates>(
        listener: (context, state) {
          if (state is EditUserDataSuccessState) {
            Navigator.of(context).pop();
          }
        },
        child: BlocBuilder<SettingsCtrl, SettingsStates>(
          builder: (context, state) {
            final cubit = context.read<SettingsCtrl>();
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: cubit.selectedImage != null
                        ? FileImage(File(cubit.selectedImage!.path))
                        : NetworkImage(cubit.imgUrl!),
                  ),
                  OutlinedButton(
                    onPressed: cubit.pickImage,
                    child: const Text("Select Image"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: cubit.userNameCtrl,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: cubit.bioCtrl,
                    decoration: InputDecoration(
                      labelText: 'bio',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: state is EditUserDataLoadingState
                          ? null
                          : () {
                              cubit.editUserData(widget.user);
                            },
                      icon: const Icon(IconBroken.edit),
                      label: const Text("Edit Profile"),
                    ),
                  ),
                  if (state is EditUserDataLoadingState)
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: LinearProgressIndicator(
                        color: Colors.green,
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
