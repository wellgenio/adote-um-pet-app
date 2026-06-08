import 'package:flutter/material.dart';
import 'package:result_dart/result_dart.dart';
import 'package:signal_form/signal_form.dart';

import '../../../../../core/client_http/app_response.dart';
import '../../../../../core/command/command.dart';
import '../../../../../core/typedefs/types.dart';
import '../../domain/dtos/login_params.dart';
import '../../domain/dtos/register_params.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';

class AuthViewmodel {
  AuthViewmodel({
    required SignUpUsecase signUpUsecase,
    required LoginUsecase loginUsecase,
  })  : _signUpUsecase = signUpUsecase,
        _loginUsecase = loginUsecase,
        super() {
    signUpCommand = Command1(_signUpAuth);
    loginCommand = Command1(_loginUsecase.call);
  }

  final isPasswordVisible = ValueNotifier(false);

  late final form = formCtrl(() => (
        email: Field<String>('email')
            .required(message: 'O e-mail não pode estar vazio')
            .email(message: 'O e-mail informado é inválido'),
        password: Field<String>('password')
            .required(message: 'A senha não pode estar vazia')
            .minLength(8, message: 'A senha deve ter no mínimo 8 caracteres'),
      ));

  late final Command1<AppResponse<AuthEntity>, RegisterParams> signUpCommand;
  late final Command1<AppResponse<AuthEntity>, LoginParams> loginCommand;

  late final SignUpUsecase _signUpUsecase;
  late final LoginUsecase _loginUsecase;

  Output<AppResponse<AuthEntity>> _signUpAuth(RegisterParams registerParams) =>
      _signUpUsecase(registerParams) // Execute o signUpUsecase
          .pure(convertToLoginParams(registerParams))
          .flatMap(_loginUsecase.call); // Execute o loginUsecase

  LoginParams convertToLoginParams(RegisterParams registerParams) =>
      LoginParams(
        email: registerParams.email,
        password: registerParams.password,
      );
}
