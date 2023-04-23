import 'package:twitter_clone/core/core.dart';
import 'package:twitter_clone/models/models.dart';

abstract class IUserAPI {
  FutureEitherVoid saveUserData(UserModel userModel);
}