import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as model;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/core/core.dart';

// to signup, use Account from appwrite.dart (to get user accounts)
// to access user related data, use Account from models.dart

final authAPIProvider = Provider.autoDispose((ref) {
  // the account will come from the appwriteAccountProvider
  // it will watch any changes that will happen to appwriteAccountProvider
  final account = ref.watch(appwriteAccountProvider);
  return AuthAPI(account: account);
});

// interface for the AuthAPI class
abstract class IAuthAPI {
  // the reason to use model.Account is that after signing up, the method should
  // return the user's account model (user related data)
  FutureEither<model.Account> signUp({
    required String email,
    required String password,
  });

  FutureEither<model.Session> login({
    required String email,
    required String password,
  });

  // current user account which can be null
  Future<model.Account?> currentUserAccount();
}

class AuthAPI implements IAuthAPI {
  final Account _account; // to signup
  // the last part assign the named variable from the constructor to the private
  // variable
  AuthAPI({required Account account}) : _account = account;

  @override
  Future<model.Account?> currentUserAccount() async {
    try {
      // if _account.get() has some values, it means that the user is logged in
      // return the account
      return await _account.get();
    } on AppwriteException {
      // if _account.get() does not have any value, it means that the user is
      // not logged in
      // return null
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  FutureEither<model.Account> signUp({
    required String email,
    required String password,
  }) async {
    try {
      // "unique" or ID.unique argument for the userId parameter will ask
      // appwrite to create unique id for us
      final account = await _account.create(
        userId: ID.unique(),
        email: email,
        password: password,
      );
      // right() means datatype from the right side of Either
      return right(account);
    } on AppwriteException catch (e, stackTrace) {
      return left(
        Failure(e.message ?? 'Some unexpected error occurred', stackTrace),
      );
    } catch (e, stackTrace) {
      // left() means datatype from the left side of Either
      return left(
        Failure(e.toString(), stackTrace),
      );
    }
  }

  @override
  FutureEither<model.Session> login({
    required String email,
    required String password,
  }) async {
    try {
      // create an email session
      final session = await _account.createEmailSession(
        email: email,
        password: password,
      );
      return right(session);
    } on AppwriteException catch (e, stackTrace) {
      return left(
        Failure(e.message ?? 'Some unexpected error occurred', stackTrace),
      );
    } catch (e, stackTrace) {
      return left(
        Failure(e.toString(), stackTrace),
      );
    }
  }
}
