// ignore_for_file: non_constant_identifier_names

import 'package:chat_app/core/services/chat_service.dart';
import 'package:chat_app/models/commnctn.dart';
import 'package:chat_app/view_model/base_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

class ChatsModel extends BaseModel {
  final ChatService _chatService = GetIt.instance<ChatService>();
  Stream<List<Communaciton>> communaciton(String userId) {
    return _chatService.getCommunaciton(userId);
  }
}
