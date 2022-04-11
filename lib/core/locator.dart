import 'package:chat_app/core/services/chat_service.dart';
import 'package:chat_app/core/services/storage_service.dart';
import 'package:chat_app/view_model/chat_detail_model.dart';
import 'package:chat_app/view_model/chats_model.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

setupLocator() {
  getIt.registerLazySingleton(() => ChatService());
  getIt.registerLazySingleton(() => StorageService());

  getIt.registerFactory(() => ChatsModel());
  getIt.registerFactory(() => ChatDetailModel());
}
