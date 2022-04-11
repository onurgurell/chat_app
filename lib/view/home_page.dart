import 'package:chat_app/core/locator.dart';
import 'package:chat_app/models/commnctn.dart';
import 'package:chat_app/view/chat_detail_page.dart';
import 'package:chat_app/view_model/chats_model.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  final String userId = 'IEv4erVSSpg7xmxM1HWqTIZo3VL2';
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var model = getIt<ChatsModel>();
    return ChangeNotifierProvider(
      create: (BuildContext context) => model,
      child: StreamBuilder<List<Communaciton>>(
        stream: model.communaciton(userId),
        builder:
            (BuildContext context, AsyncSnapshot<List<Communaciton>> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Text(
                'Loading...',
                style: TextStyle(fontSize: 25),
              ),
            );
          }
          return ListView(
            children: snapshot.data!
                .map(
                  (doc) => ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(doc.profileImage),
                    ),
                    title: Text(
                      doc.name,
                    ),
                    subtitle: Text(
                      doc.displayMessage,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatDetailPage(
                            userId: userId,
                            comId: doc.id,
                          ),
                        ),
                      );
                    },
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }
}
