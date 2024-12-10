import 'dart:developer';

import 'package:result_dart/result_dart.dart';

import '../../../../../core/errors/default_exception.dart';
import '../../../../../core/services/session_service.dart';
import '../../../../../core/typedefs/types.dart';
import '../../../../../core/usecase/usecase_interface.dart';

class LogoutUsecase implements UseCase<Unit, Object?> {
  final SessionService _sessionService;

  LogoutUsecase({required SessionService sessionService})
      : _sessionService = sessionService;

  @override
  Output<Unit> call([_]) async {
    final removed = await _sessionService.removeToken();
    if (removed) {
      log('Remove Token');
      return const Success(unit);
    }
    return const Failure(DefaultException(message: 'Not remove token'));
  }
}