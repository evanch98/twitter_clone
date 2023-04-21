import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/auth_api.dart';
import 'package:twitter_clone/core/core.dart';

// we need to explicitly provide the type for the StateNotifierProvider
// the first one is the datatype it is going to return
// the second one is the datatype provided to the StateNotifier
final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
      final authAPI = ref.watch(authAPIProvider);
  return AuthController(authAPI: authAPI);
});

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
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.signUp(
      email: email,
      password: password,
    );
    // the fold method is from Either (l = left, r = right)
    res.fold(
      // since l = left = Failure datatype, we can use the message field
      (l) => showSnackBar(context, l.message),
      (r) => print(r.email),
    );
  }
}
