import 'package:chat_app/core/locator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'view/chat_main.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: const Color(0xff075E54),
      ),
      home: const ChatMain(),
    );
  }
}
