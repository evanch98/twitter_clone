import "package:flutter/material.dart";
import "package:appwrite/models.dart" as model;
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:twitter_clone/apis/apis.dart";
import "package:twitter_clone/core/core.dart";
import "package:twitter_clone/features/auth/view/login_view.dart";
import "package:twitter_clone/features/auth/view/signup_view.dart";
import "package:twitter_clone/features/home/view/home_view.dart";
import "package:twitter_clone/models/models.dart";

// we need to explicitly provide the type for the StateNotifierProvider
// the first one is the datatype it is going to return
// the second one is the datatype provided to the StateNotifier
// if there is no datatype for the StateNotifier, the second one should be the
// dynamic datatype
final authControllerProvider =
    StateNotifierProvider.autoDispose<AuthController, bool>((ref) {
  final authAPI = ref.watch(authAPIProvider);
  final userAPI = ref.watch(userAPIProvider);
  return AuthController(authAPI: authAPI, userAPI: userAPI);
});

// currentUserAccountProvider will return the currentUser
// it will watch any changes that will happen to the authControllerProvider
final currentUserAccountProvider = FutureProvider.autoDispose((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.currentUser();
});

// userDetailsProvider is a reusable provider that returns the user data for the
// the given uid
final userDetailsProvider =
    FutureProvider.family.autoDispose((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

// currentUserDetailsProvider will return the current user's details
final currentUserDetailsProvider = FutureProvider.autoDispose((ref) {
  final currentUserId = ref.watch(currentUserAccountProvider).value!.$id;
  final userDetails = ref.watch(userDetailsProvider(currentUserId));
  return userDetails.value;
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
      (r) async {
        // create a userModel to be stored in the appwrite database
        UserModel userModel = UserModel(
          email: email,
          name: getNameFromEmail(email),
          followers: const [],
          following: const [],
          profilePic: "",
          bannerPic: "",
          uid: r.$id,
          bio: "",
          isTwitterBlue: false,
        );
        // save the user model to the appwrite database upon signing up
        final res2 = await _userAPI
            .saveUserData(userModel); // response from the saveUserData
        res2.fold((l) => showSnackBar(context, l.message), (r) {
          // if the account is created successfully and stored in the database,
          // it will show the confirmation message and navigate to the LoginView
          showSnackBar(context, "Account has been created! Please login");
          Navigator.push(context, LoginView.route());
        });
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

  // retrieve the user data from the server
  Future<UserModel> getUserData(String uid) async {
    final document = await _userAPI.getUserData(uid);
    final updatedUser = UserModel.fromMap(document.data);
    return updatedUser;
  }

  void logout(BuildContext context) async {
    final res = await _authAPI.logout();
    res.fold((l) => null, (r) {
      Navigator.pushAndRemoveUntil(
        context,
        SignUpView.route(),
        (route) => false,
      );
    });
  }
}
