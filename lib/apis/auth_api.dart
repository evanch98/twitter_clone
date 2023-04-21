import 'package:fpdart/fpdart.dart';

// interface for the AuthAPI class
abstract class IAuthAPI {
  // Either lets allows us to return two data types from a function (from the
  // fpdart package).
  Future<Either<int, String>> signUp({
    required String email,
    required String password,
  });
}
