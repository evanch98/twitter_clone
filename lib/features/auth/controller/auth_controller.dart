import 'package:flutter/material.dart';
import 'package:appwrite/models.dart' as model;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/apis.dart';
import 'package:twitter_clone/core/core.dart';
import 'package:twitter_clone/features/auth/view/login_view.dart';
import 'package:twitter_clone/features/home/view/home_view.dart';

// we need to explicitly provide the type for the StateNotifierProvider
// the first one is the datatype it is going to return
// the second one is the datatype provided to the StateNotifier
// if there is no datatype for the StateNotifier, the second one should be the
// dynamic datatype
final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  final authAPI = ref.watch(authAPIProvider);
  final userAPI = ref.watch(userAPIProvider);
  return AuthController(authAPI: authAPI, userAPI: userAPI);
});

// currentUserAccountProvider will return the currentUser
// it will watch any changes that will happen to the authControllerProvider
final currentUserAccountProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.currentUser();
});

// AuthController
class AuthController extends StateNotifier<bool> {
  final AuthAPI _authAPI;
  final UserAPI _userAPI;

  // the type of StateNotifier is set to bool to set the state isLoading or not
  AuthController({required AuthAPI authAPI, required UserAPI userAPI})
      : _authAPI = authAPI,
        _userAPI = userAPI,
        super(false);

  // return the current user account if the user is logged in else null
  Future<model.Account?> currentUser() => _authAPI.currentUserAccount();

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
    state = false; // then the state is finished loading
    // the fold method is from Either (l = left, r = right)
    res.fold(
      // since l = left = Failure datatype, we can use the message field
      (l) => showSnackBar(context, l.message),
      (r) {
        // if the account is created successfully, it will show the confirmation
        // message and navigate to the LoginView
        showSnackBar(context, "Account has been created! Please login");
        Navigator.push(context, LoginView.route());
      },
    );
  }

  void login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.login(
      email: email,
      password: password,
    );
    state = false; // then the state is finished loading
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        // after logging in successfully, navigate to the HomeView
        Navigator.push(context, HomeView.route());
      },
    );
  }
}
