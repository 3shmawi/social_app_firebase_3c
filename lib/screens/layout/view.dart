import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_3c/ctrl/layout_ctrl.dart';
import 'package:social_3c/ctrl/theme_ctrl.dart';

class LayoutView extends StatelessWidget {
  const LayoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LayoutCtrl, LayoutStates>(
      buildWhen: (_, current) => current is ChangeIndexState,
      builder: (context, state) {
        final cubit = context.read<LayoutCtrl>();
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green.shade700,
            foregroundColor: Colors.white,
            centerTitle: false,
            title: const Text(
              "App Name",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(15),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.dark_mode_outlined),
                onPressed: () {
                  context.read<ThemeCtrl>().toggleTheme();
                },
              ),
            ],
          ),
          body: cubit.myScreen(),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.upload), label: 'Upload'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.notifications), label: 'Notifications'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings), label: 'Settings'),
            ],
            currentIndex: cubit.currentIndex,
            selectedItemColor: Colors.green.shade600,
            unselectedItemColor: Colors.grey.shade400,
            onTap: cubit.changeIndex,
          ),
        );
      },
    );
  }
}
