import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/core/core.dart';

final storageAPIProvider = Provider((ref) {
  final storage = ref.watch(appwriteStorageProvider);
  return StorageAPI(storage: storage);
});

class StorageAPI {
  final Storage _storage;

  StorageAPI({required Storage storage}) : _storage = storage;

  Future<List<String>> uploadImage(List<File> files) async {
    List<String> imageLinks = [];
    for (final file in files) {
      final uploadedImage = await _storage.createFile(
        bucketId: AppwriteConstants.imagesBucket,
        fileId: ID.unique(),
        file: InputFile.fromPath(path: file.path),
      );
      imageLinks.add(
        AppwriteConstants.imageUrl(uploadedImage.$id),
      );
    }
    return imageLinks;
  }
}
