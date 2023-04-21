import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as model;
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
