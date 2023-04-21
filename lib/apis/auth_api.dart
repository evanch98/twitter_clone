import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as model;
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/core/core.dart';

// to signup, use Account from appwrite.dart (to get user accounts)
// to access user related data, use Account from models.dart

// interface for the AuthAPI class
abstract class IAuthAPI {
  // the reason to use model.Account is that after signing up, the method should
  // return the user's account model (user related data)
  FutureEither<model.Account> signUp({
    required String email,
    required String password,
  });
}

class AuthAPI implements IAuthAPI {
  final Account _account; // to signup
  // the last part assign the named variable from the constructor to the private
  // variable
  AuthAPI({required Account account}) : _account = account;

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
    } catch (e, stackTrace) {
      // left() means datatype from the left side of Either
      return left(
        Failure(e.toString(), stackTrace),
      );
    }
  }
}
