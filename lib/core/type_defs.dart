import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/core/failure.dart';

// typedef simply allows us to create our own type definition
typedef FutureEither<T> = Future<Either<Failure, T>>;
