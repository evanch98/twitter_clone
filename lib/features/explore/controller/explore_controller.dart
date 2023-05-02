import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/apis.dart';

class ExploreController extends StateNotifier<bool> {
  final UserAPI _userAPI;

  ExploreController({
    required UserAPI userAPI,
  })  : _userAPI = userAPI,
        super(false);
}
