import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/core/failure.dart';

// typedef simply allows us to create our own type definition
// Either lets allows us to return two data types from a function (from the
// fpdart package).
typedef FutureEither<T> = Future<Either<Failure, T>>;
