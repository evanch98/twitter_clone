import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/auth_api.dart';

// AuthController
class AuthController extends StateNotifier<bool> {
  final AuthAPI _authAPI;

  // the type of StateNotifier is set to bool to set the state isLoading or not
  AuthController({required AuthAPI authAPI})
      : _authAPI = authAPI,
        super(false);

  void signUp({
    required String email,
    required String password,
  }) async {
    state = true;
    final res = await _authAPI.signUp(
      email: email,
      password: password,
    );
    // the fold method is from Either (l = left, r = right)
    res.fold((l) => null, (r) => print(r.email));
  }
}
