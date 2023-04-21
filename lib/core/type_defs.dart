import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/core/failure.dart';

// typedef simply allows us to create our own type definition
// Either lets allows us to return two data types from a function (from the
// fpdart package).

// FutureEither will return the data type Failure when there is a failure
// FutureEither will return the appropriate data type when there is a success
typedef FutureEither<T> = Future<Either<Failure, T>>;
// FutureEitherVoid will return nothing when there is a success
typedef FutureEitherVoid = FutureEither<void>;
typedef FutureVoid = Future<void>;
