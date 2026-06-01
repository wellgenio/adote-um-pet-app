import 'package:lucid_validation/lucid_validation.dart';
import 'package:result_dart/result_dart.dart';

import '../errors/errors.dart';

extension LucidValidatorExtensions<T extends Object> on LucidValidator<T> {
  Result<T, BaseException> validateResult(T object) {
    final result = validate(object);
    if (result.isValid) {
      return Success(object);
    }

    return Failure(
      CredentialsValidationException(message: result.exceptions.first.message),
    );
  }
}

extension CustomValidPasswordValidator on SimpleValidationBuilder<String> {
  SimpleValidationBuilder<String> customValidPassword() {
    return notEmpty(message: "A senha não pode estar vazia") //
        .minLength(8, message: "A senha deve ter no mínimo 8 caracteres");
    // .mustHaveLowercase(message: "A senha deve ter pelo menos uma letra minúscula")
    // .mustHaveUppercase(message: "A senha deve ter pelo menos uma letra maiúscula")
    // .mustHaveNumber(message: "A senha deve ter pelo menos um número")
    // .mustHaveSpecialCharacter(message: "A senha deve ter pelo menos um caractere especial");
  }
}
