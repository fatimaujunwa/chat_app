import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ichat/chat_screen.dart';
import 'package:ichat/chatroom.dart';
import 'package:ichat/groups.dart';
import 'package:ichat/members.dart';
import 'package:ichat/my_groups.dart';
import 'package:ichat/search_screen.dart';
import 'package:ichat/sign_in_screen.dart';
import 'package:ichat/sign_up_screen.dart';
import 'package:ichat/test.dart';

import 'chat.dart';
import 'group_chat.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(builder: (context,_){
      return MaterialApp(
        debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(


          ),
          home:SignUpScreen()

          // MyGroups(uid: '2sCfGjM6WnNonRH5OK1hqUmZUuo1', username: 'mazel')
      );

    },
    designSize: Size(375, 812),
    );

  }
}


