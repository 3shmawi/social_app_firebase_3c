import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_3c/controller/layout_ctrl.dart';
import 'package:social_3c/controller/post_ctrl.dart';
import 'package:social_3c/screens/_resources/assets_path/icon_broken.dart';

class LayoutView extends StatelessWidget {
  const LayoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LayoutCtrl, LayoutStates>(
      builder: (context, state) {
        final cubit = context.read<LayoutCtrl>();
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            centerTitle: false,
            title: const Text(
              'MYM Social',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  IconBroken.search,
                ),
              ),
            ],
          ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.shifting,
            selectedItemColor: Colors.green,
            unselectedItemColor: Colors.grey,
            backgroundColor: Colors.white,
            currentIndex: cubit.currentIndex,
            onTap: (index) {
              context.read<PostCtrl>().clearDate();
              cubit.changeIndex(index);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(IconBroken.home),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(IconBroken.chat),
                label: "Chat",
              ),
              BottomNavigationBarItem(
                icon: Icon(IconBroken.upload),
                label: "___",
              ),
              BottomNavigationBarItem(
                icon: Icon(IconBroken.notification),
                label: "Notifications",
              ),
              BottomNavigationBarItem(
                icon: Icon(IconBroken.setting),
                label: "Settings",
              ),
            ],
          ),
        );
      },
    );
  }
}
