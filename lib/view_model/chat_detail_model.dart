// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:io';

import 'package:chat_app/core/locator.dart';
import 'package:chat_app/core/services/storage_service.dart';
import 'package:chat_app/view_model/base_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_share/flutter_share.dart';
import '../core/services/storage_service.dart';

class ChatDetailModel extends BaseModel {
  final StorageService _storageService = getIt<StorageService>();
  CollectionReference? _ref;
  String mediaUrl = "";
  File? file;
  bool? isFile;

  Stream<QuerySnapshot> getComnctn(String id) {
    _ref = FirebaseFirestore.instance.collection('communication/$id/messages');
    return _ref!.orderBy('timeStamp').snapshots();
  }

  Future<DocumentReference<Object?>> add(Map<String, dynamic> data) {
    mediaUrl = '';
    file;
    notifyListeners();
    return _ref!.add(data);
  }

  uploadMedia(
    ImageSource source,
  ) async {
    var pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile == null) return;

    mediaUrl = await _storageService.uploadMedia(File(pickedFile.path));
    isFile = false;
    notifyListeners();
  }

  Future<void> shareFile() async {
    // List<String> docs = await DocumentsPicker.pickDocuments;

    // await FlutterShare.shareFile(
    //   title: 'Example share',
    //   text: 'Example share text',
    //   filePath: docs[0],
    // );

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc'],
    );

    if (result != null) {
      final path = result.files.single.path;
      file = File(path!);
    }
    isFile = true;
    notifyListeners();
  }
}
