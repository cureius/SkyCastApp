import 'package:sky_cast/core/error/failures.dart';
import 'package:sky_cast/core/usecase/usecase.dart';
import 'package:sky_cast/core/common/entities/user.dart';
import 'package:sky_cast/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class CurrentUser implements UseCase<User, NoParams> {
  final AuthRepository authRepository;
  CurrentUser(this.authRepository);

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await authRepository.currentUser();
  }
}
