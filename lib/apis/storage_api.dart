import "dart:io";

import "package:appwrite/appwrite.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:twitter_clone/constants/constants.dart";
import "package:twitter_clone/core/core.dart";

/// A provider that creates a [StorageAPI] instance using an [AppwriteStorage] instance.
///
/// This provider is used to manage the lifecycle of the [StorageAPI] object and ensure
/// that it is properly disposed of when it is no longer needed. It depends on the
/// [appwriteStorageProvider], which provides an instance of [AppwriteStorage] that is
/// used to interact with the cloud storage service.
///
/// To use this provider, you can call the `read` or `watch` method on the [ProviderReference] and
/// pass in the [storageAPIProvider] to obtain a [StorageAPI] instance. The [StorageAPI]
/// object can then be used to upload images to the cloud storage service.
final storageAPIProvider = Provider.autoDispose((ref) {
  final storage = ref.watch(appwriteStorageProvider);
  return StorageAPI(storage: storage);
});

/// Provides a simple API for uploading images to a cloud storage service.
class StorageAPI {
  final Storage _storage;

  /// Creates a new instance of [StorageAPI].
  ///
  /// The [storage] parameter is required and must be an instance of [Storage],
  /// which is used to interact with the cloud storage service.
  StorageAPI({required Storage storage}) : _storage = storage;

  /// Uploads the specified [files] to the cloud storage service and returns a
  /// list of URLs that can be used to access the uploaded images.
  ///
  /// Each file in the [files] list should be a [File] object that represents
  /// an image file on the local file system.
  ///
  /// The returned list of URLs corresponds to the uploaded images and can be
  /// used to display the images in a user interface or share them with others.
  ///
  /// If there are any errors during the upload process, a [StorageException]
  /// will be thrown with details about the error.
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
