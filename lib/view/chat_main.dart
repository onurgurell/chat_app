// ignore_for_file: unnecessary_const, prefer_const_literals_to_create_immutables

import 'package:chat_app/view/home_page.dart';
import 'package:chat_app/view/second_page.dart';
import 'package:flutter/material.dart';

class ChatMain extends StatefulWidget {
  const ChatMain({Key? key}) : super(key: key);

  @override
  State<ChatMain> createState() => _ChatMainState();
}

class _ChatMainState extends State<ChatMain>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this, initialIndex: 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat App'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: <Widget>[
            const Tab(
              icon: Icon(Icons.home),
            ),
            const Tab(
              icon: Icon(Icons.security_update_outlined),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          const HomePage(),
          const SecondPage(),
        ],
      ),
    );
  }
}
