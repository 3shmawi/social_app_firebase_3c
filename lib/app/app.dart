import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_3c/app/theme.dart';
import 'package:social_3c/ctrl/auth_ctrl.dart';
import 'package:social_3c/ctrl/layout_ctrl.dart';
import 'package:social_3c/ctrl/theme_ctrl.dart';
import 'package:social_3c/services/local_database.dart';

import '../screens/splash.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCtrl()),
        BlocProvider(create: (_) => AuthCtrl()),
        BlocProvider(create: (_) => LayoutCtrl()),
      ],
      child: BlocBuilder<ThemeCtrl, bool>(
        builder: (context, state) {
          final isDark = CacheHelper.getData(key: "isDark") ?? false;
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            home: const SplashView(),
          );
        },
      ),
    );
  }
}
