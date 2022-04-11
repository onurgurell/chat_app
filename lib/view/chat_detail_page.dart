import 'dart:io';

import 'package:chat_app/view_model/chat_detail_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';

class ChatDetailPage extends StatefulWidget {
  final String userId;
  final String comId;

  const ChatDetailPage({Key? key, required this.userId, required this.comId})
      : super(key: key);

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController _editingController = TextEditingController();
  late CollectionReference _ref;
  FocusNode? _focus;
  ScrollController? _scrollController;
  @override
  void initState() {
    _ref = FirebaseFirestore.instance
        .collection('communication/${widget.comId}/messages');
    _focus = FocusNode();
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _focus!.dispose();
    _scrollController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var model = GetIt.instance<ChatDetailModel>();
    return ChangeNotifierProvider(
      create: (BuildContext context) => model,
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: -5,
          title: Row(
            children: const [
              CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://odtukaltev.com.tr/wp-content/uploads/2018/04/person-placeholder.jpg'),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('onur'),
              )
            ],
          ),
          actions: <Widget>[
            InkWell(
              onTap: () {},
              child: const Icon(Icons.phone),
            ),
            const SizedBox(
              width: 15,
            ),
            InkWell(
              onTap: () {},
              child: const Icon(Icons.more_vert),
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                  'https://upload.wikimedia.org/wikipedia/tr/6/67/Avengersendgame.jpg'),
            ),
          ),
          //area of messages
          child: Column(
            children: <Widget>[
              Consumer<ChatDetailModel>(
                builder: (context, value, child) {
                  return model.mediaUrl.isEmpty
                      ? Container()
                      : Align(
                          alignment: Alignment.bottomRight,
                          child: SizedBox(
                            width: 150,
                            child: Image.network(model.mediaUrl),
                          ),
                        );
                },
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => _focus!.unfocus(),
                  child: StreamBuilder(
                    stream: model.getComnctn(widget.comId),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      return !snapshot.hasData
                          ? CircularProgressIndicator()
                          : ListView(
                              controller: _scrollController,
                              children: snapshot.data!.docs
                                  .map(
                                    (document) => ListTile(
                                      title: model.isFile == true
                                          ? document['file'] == '' ||
                                                  document['file'] == null
                                              ? Container()
                                              : Align(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: SizedBox(
                                                    height: 150,
                                                    width: 100,
                                                    child: InkWell(
                                                      onTap: () {},
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.all(12),
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .horizontal(
                                                            // ignore: unnecessary_const
                                                            left: const Radius
                                                                .circular(10),
                                                            right:
                                                                Radius.circular(
                                                                    10),
                                                          ),
                                                        ),
                                                        child: Text(
                                                          document['file']
                                                              .toString(),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                          : document['media'] == ''
                                              ? Container()
                                              : Align(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: SizedBox(
                                                    height: 150,
                                                    width: 100,
                                                    child: Image.network(
                                                      document['media'],
                                                    ),
                                                  ),
                                                ),
                                      subtitle: Align(
                                        alignment: widget.userId ==
                                                document['senderId']
                                            ? Alignment.centerRight
                                            : Alignment.centerLeft,
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).primaryColor,
                                            borderRadius:
                                                const BorderRadius.horizontal(
                                              // ignore: unnecessary_const
                                              left: const Radius.circular(10),
                                              right: Radius.circular(10),
                                            ),
                                          ),
                                          child: Text(
                                            document['message'],
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList());
                    },
                  ),
                ),
              ),
              //Area of write message
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(12),
                              right: Radius.circular(12))),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: InkWell(
                              child: Icon(
                                Icons.tag_faces,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              focusNode: _focus,
                              controller: _editingController,
                              decoration: const InputDecoration(
                                  hintText: 'Mesaj Giriniz',
                                  border: InputBorder.none),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: InkWell(
                              child: const Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.grey,
                              ),
                              onTap: () =>
                                  model.uploadMedia(ImageSource.camera),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: InkWell(
                              child: const Icon(
                                Icons.attach_file,
                                color: Colors.grey,
                              ),
                              onTap: () async =>
                                  await model.uploadMedia(ImageSource.gallery),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: InkWell(
                              child: const Icon(
                                Icons.file_copy,
                                color: Colors.grey,
                              ),
                              onTap: () async {
                                await model.shareFile();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColor),
                    child: IconButton(
                      onPressed: () async {
                        await model.add(
                          {
                            'senderId': widget.userId,
                            'message': _editingController.text,
                            'timeStamp': DateTime.now(),
                            'media':
                                model.mediaUrl.isEmpty ? "" : model.mediaUrl,
                            'file':
                                model.file!.path.isEmpty ? '' : model.file!.path
                          },
                        );
                        _scrollController!.animateTo(
                            _scrollController!.position.maxScrollExtent,
                            duration: Duration(microseconds: 200),
                            curve: Curves.easeIn);
                        _editingController.text = '';
                      },
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
