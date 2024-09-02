import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_3c/controller/auth_ctrl.dart';
import 'package:social_3c/controller/post_ctrl.dart';
import 'package:social_3c/model/post.dart';
import 'package:social_3c/screens/_resources/assets_path/icon_broken.dart';
import 'package:social_3c/screens/_resources/shared/navigation.dart';
import 'package:social_3c/screens/auth/login_view.dart';

import 'edit_profile.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
//services
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCtrl, AuthStates>(
      builder: (context, state) {
        final cubit = context.read<AuthCtrl>();
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 68,
                  backgroundColor: Colors.green,
                  child: CircleAvatar(
                    radius: 65,
                    backgroundImage: NetworkImage(cubit.myData!.imgUrl),
                  ),
                ),
                Text(
                  cubit.myData!.name,
                  style: const TextStyle(
                    fontSize: 24,
                    height: 1.7,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  cubit.myData!.bio,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.green, width: 2),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            IconBroken.document,
                            color: Colors.green,
                          ),
                          FutureBuilder<List<PostModel>>(
                            future: context
                                .read<PostCtrl>()
                                .getMyPost(cubit.myData!.id),
                            builder: (context, snapshot) {
                              final posts = snapshot.data;
                              if (posts == null || posts.isEmpty) {
                                return const Text(
                                  " My Posts [0]",
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }
                              return Text(
                                " My Posts [${posts.length}]",
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.green, width: 2),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            IconBroken.user1,
                            color: Colors.green,
                          ),
                          Text(
                            " Followers[1.6K]",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.green,
                        thickness: 2,
                      ),
                    ),
                    Text(
                      "  PHOTOS  ",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.green,
                        thickness: 2,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                FutureBuilder<List<PostModel>>(
                  future: context
                      .read<PostCtrl>()
                      .getMyPostPhotos(cubit.myData!.id),
                  builder: (context, snapshot) {
                    final posts = snapshot.data;
                    if (posts == null || posts.isEmpty) {
                      return const SizedBox(
                        height: 250,
                        child: Center(
                          child: Text(
                            " No photos yet",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      );
                    }
                    return SizedBox(
                      height: 250,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Card(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: Image.network(
                              posts[index].postImageUrl!,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(width: 5);
                        },
                        itemCount: posts.length,
                      ),
                    );
                  },
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
                    onPressed: () {
                      toPage(context, EditProfilePage(cubit.myData!));
                    },
                    icon: const Icon(IconBroken.edit),
                    label: const Text("Edit Profile"),
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    context.read<AuthCtrl>().logout().then(
                      (value) {
                        if (value) {
                          toAndFinish(context, const LoginView());
                        }
                      },
                    );
                  },
                  child: const Text(
                    "LOGOUT",
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
