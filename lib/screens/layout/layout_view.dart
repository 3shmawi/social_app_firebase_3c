import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_3c/controller/layout_ctrl.dart';

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
                  Icons.search,
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
            onTap: (index) => cubit.changeIndex(index),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat),
                label: "Chat",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notification_important_outlined),
                label: "Notifications",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: "Settings",
              ),
            ],
          ),
        );
      },
    );
  }
}
