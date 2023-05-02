import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/apis.dart';
import 'package:twitter_clone/models/models.dart';

final exploreControllerProvider =
    StateNotifierProvider.autoDispose<ExploreController, bool>((ref) {
  final userAPI = ref.watch(userAPIProvider);
  return ExploreController(userAPI: userAPI);
});

// provide the searchUser method from the ExploreController
final searchUserProvider =
    FutureProvider.family.autoDispose((ref, String name) {
  final exploreController = ref.watch(exploreControllerProvider.notifier);
  return exploreController.searchUser(name);
});

class ExploreController extends StateNotifier<bool> {
  final UserAPI _userAPI;

  ExploreController({
    required UserAPI userAPI,
  })  : _userAPI = userAPI,
        super(false);

  Future<List<UserModel>> searchUser(String name) async {
    final users = await _userAPI.searchUserByName(name);
    return users.map((e) => UserModel.fromMap(e.data)).toList();
  }
}
