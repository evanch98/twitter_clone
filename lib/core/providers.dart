import "package:appwrite/appwrite.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:twitter_clone/constants/constants.dart";

final appwriteClientProvider = Provider.autoDispose((ref) {
  Client client = Client();
  return client
      .setEndpoint(AppwriteConstants.endPoint)
      .setProject(AppwriteConstants.projectId)
      .setSelfSigned(status: true); // selfSigned should only be used in the development
});

final appwriteAccountProvider = Provider.autoDispose((ref) {
  // ref allows us to communicate with other providers
  // ref.watch means it will continuously watching any changes that will happen
  // to appwriteClientProvider
  // ref.read can also be used, but it will only read once and won't update any
  // changes
  final client = ref.watch(appwriteClientProvider);
  return Account(client);
});

final appwriteDatabaseProvider = Provider.autoDispose((ref) {
  final client = ref.watch(appwriteClientProvider);
  return Databases(client);
});

final appwriteStorageProvider = Provider.autoDispose((ref) {
  final client = ref.watch(appwriteClientProvider);
  return Storage(client);
});

final appwriteRealtimeProviderForTweet = Provider.autoDispose((ref) {
  final client = ref.watch(appwriteClientProvider);
  return Realtime(client);
});

final appwriteRealtimeProviderForUserProfile = Provider.autoDispose((ref) {
  final client = ref.watch(appwriteClientProvider);
  return Realtime(client);
});

final appwriteRealtimeProviderForNotification = Provider.autoDispose((ref) {
  final client = ref.watch(appwriteClientProvider);
  return Realtime(client);
});
