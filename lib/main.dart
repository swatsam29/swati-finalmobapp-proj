import 'package:flutter/material.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/viewscreen/addphotomemo_screen.dart';
import 'package:lesson3/viewscreen/deletephotos.dart';
import 'package:lesson3/viewscreen/detailedview_screen.dart';
import 'package:lesson3/viewscreen/error_screen.dart';
import 'package:lesson3/viewscreen/myfavorite.dart';
import 'package:lesson3/viewscreen/notifications.dart';
import 'package:lesson3/viewscreen/profile.dart';
import 'package:lesson3/viewscreen/sharedwith_screen.dart';
import 'package:lesson3/viewscreen/signup_screen.dart';
import 'package:lesson3/viewscreen/start_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lesson3/viewscreen/userhome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const Lesson3App());
}

class Lesson3App extends StatelessWidget {
  const Lesson3App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: Constant.devMode,
      initialRoute: StartScreen.routeName,
      routes: {
        StartScreen.routeName: (context) => const StartScreen(),
        UserHomeScreen.routeName: (context) {
          Object? args = ModalRoute.of(context)?.settings.arguments;
          if (args == null) {
            return const ErrorScreen('args is null for UserHomeSccreen');
          } else {
            var argument = args as Map;
            var user = argument[ArgKey.user];
            var photoMemoList = argument[ArgKey.photoMemoList];
            return UserHomeScreen(
              user: user,
              photoMemoList: photoMemoList,
            );
          }
        },
        AddPhotoMemoScreen.routeName: (context) {
          Object? args = ModalRoute.of(context)?.settings.arguments;
          if (args == null) {
            return const ErrorScreen('args is null for UserHomeSccreen');
          } else {
            var argument = args as Map;
            var user = argument[ArgKey.user];
            var photoMemoList = argument[ArgKey.photoMemoList];
            return AddPhotoMemoScreen(
              user: user,
              photoMemoList: photoMemoList,
            );
          }
        },
        DetailedViewScreen.routeName: (context) {
          Object? args = ModalRoute.of(context)?.settings.arguments;
          if (args == null) {
            return const ErrorScreen('args is null for DetailedViewScreen');
          } else {
            var argument = args as Map;
            var user = argument[ArgKey.user];
            var photoMemo = argument[ArgKey.onePhotoMemo];
            return DetailedViewScreen(
              user: user,
              photoMemo: photoMemo,
            );
          }
        },
        SignUpScreen.routeName: (context) => const SignUpScreen(),
        SharedWithScreen.routeName: (context) {
          Object? args = ModalRoute.of(context)?.settings.arguments;
          if (args == null) {
            return const ErrorScreen('args is null for SharedWithScreen');
          } else {
            var argument = args as Map;
            var user = argument[ArgKey.user];
            var photoMemoList = argument[ArgKey.photoMemoList];
            return SharedWithScreen(
              user: user,
              photoMemoList: photoMemoList,
            );
          }
        },
        DeletedPhotoScreen.routeName: (context) {
          Object? args = ModalRoute.of(context)?.settings.arguments;
          if (args == null) {
            return const ErrorScreen('args is null for DeletedPhotoScreen');
          } else {
            var argument = args as Map;
            var user = argument[ArgKey.user];
            var photoMemoList = argument[ArgKey.photoMemoList];
            return DeletedPhotoScreen(
              user: user,
              photoMemoList: photoMemoList,
            );
          }
        },
        NotificationsScreen.routeName: (context) {
          Object? args = ModalRoute.of(context)?.settings.arguments;
          if (args == null) {
            return const ErrorScreen('args is null for DeletedPhotoScreen');
          } else {
            var argument = args as Map;
            var user = argument[ArgKey.user];
            var notifications = argument[ArgKey.notifications];
            return NotificationsScreen(
              user: user,
              notifications: notifications,
            );
          }
        },
        ProfileScreen.routeName: (context) {
          Object? args = ModalRoute.of(context)?.settings.arguments;
          if (args == null) {
            return const ErrorScreen('args is null for ProfileScreen');
          } else {
            var argument = args as Map;
            var userProfile = argument[ArgKey.userProfile];
            var user = argument[ArgKey.user];
            return ProfileScreen(
              userProfile: userProfile,
              user: user,
            );
          }
        },
        FavoriteScreen.routeName: (context) {
          Object? args = ModalRoute.of(context)?.settings.arguments;
          if (args == null) {
            return const ErrorScreen('args is null for UserHomeScreen');
          } else {
            var argument = args as Map;
            var user = argument[ArgKey.user];
            var photoMemoList = argument[ArgKey.photoMemoList];
            return FavoriteScreen(
              user: user,
              photoMemoList: photoMemoList,
            );
          }
        },
      },
    );
  }
}
