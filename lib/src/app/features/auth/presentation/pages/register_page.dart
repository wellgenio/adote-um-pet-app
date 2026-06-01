import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/enums/user_type_enum.dart';
import '../../../../../core/routes/routes.dart';
import '../../../../../core/utils/show_snack_bar.dart';
import '../../domain/dtos/register_params.dart';
import '../../domain/validators/register_params_validator.dart';
import '../viewmodels/auth_viewmodel.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, required this.typeUser});

  final UserType typeUser;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  MaskedTextController numberController = MaskedTextController(mask: '(00) 00000-0000');
  MaskedTextController cepController = MaskedTextController(mask: '00000-000');
  MaskedTextController cnpjController = MaskedTextController(mask: '00.000.000/0000-00');

  late final _registerParams = RegisterParams.empty()..setUserType(widget.typeUser);
  final _validator = RegisterParamsValidator();

  final formKey = GlobalKey<FormState>();

  final authViewmodel = GetIt.I.get<AuthViewmodel>();

  @override
  void initState() {
    super.initState();
    authViewmodel.signUpCommand.addListener(listener);
  }

  listener() {
    authViewmodel.signUpCommand.result?.fold(
      (appResponse) {
        authViewmodel.signUpCommand.clearResult();
        formKey.currentState!.reset();
        showMessageSnackBar(
          context,
          appResponse.message,
          icon: Icons.check,
          iconColor: AppColors.whiteColor,
          color: AppColors.secondaryColor,
        );
        router.go('/auth/welcome');
      },
      (exception) {
        authViewmodel.signUpCommand.clearResult();
        showMessageSnackBar(
          context,
          exception.message,
          icon: Icons.error,
          iconColor: AppColors.whiteColor,
          color: AppColors.primaryColor,
        );
      },
    );
  }

  @override
  void dispose() {
    authViewmodel.signUpCommand.removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(17),
        width: size.width,
        height: size.height,
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _registerParams.isIndividual ? 'Cadastro Pessoa Física' : 'Cadastro Organização',
                  style: theme.textTheme.displaySmall,
                ),
                const Gap(29),

                // Campos básicos (comuns a ambos)
                TextInputDs(
                  label: _registerParams.isOrganization ? 'nome da organização' : 'nome',
                  width: size.width,
                  onChanged: _registerParams.isOrganization ? _registerParams.setOrganizationName : _registerParams.setName,
                  validator: _validator.byField(_registerParams, 'name'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const Gap(25),

                // Campos específicos para organizações
                if (_registerParams.isOrganization) ...[
                  TextInputDs(
                    label: 'CNPJ',
                    controller: cnpjController,
                    width: size.width,
                    onChanged: _registerParams.setCnpj,
                    validator: _validator.byField(_registerParams, 'cnpj'),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const Gap(25),
                  TextInputDs(
                    label: 'nome do responsável',
                    width: size.width,
                    onChanged: _registerParams.setResponsibleName,
                    validator: _validator.byField(_registerParams, 'responsibleName'),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const Gap(25),
                ],

                TextInputDs(
                  label: 'e-mail',
                  textInputType: TextInputType.emailAddress,
                  width: size.width,
                  onChanged: _registerParams.setEmail,
                  validator: _validator.byField(_registerParams, 'email'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const Gap(25),
                TextInputDs(
                  width: size.width,
                  label: 'senha',
                  isPassword: true,
                  onChanged: _registerParams.setPassword,
                  validator: _validator.byField(_registerParams, 'password'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const Gap(25),
                TextInputDs(
                  width: size.width,
                  label: 'confirmar senha',
                  isPassword: true,
                  onChanged: _registerParams.setConfirmPassword,
                  validator: _validator.byField(_registerParams, 'confirmPassword'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const Gap(25),
                TextInputDs(
                  label: 'telefone (opcional)',
                  controller: numberController,
                  textInputType: TextInputType.number,
                  width: size.width,
                  onChanged: _registerParams.setPhone,
                  validator: _validator.byField(_registerParams, 'phone'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),

                // Campos específicos para organizações
                if (_registerParams.isOrganization) ...[
                  const Gap(25),
                  TextInputDs(
                    label: 'declaração de missão (opcional)',
                    //maxLines: 3,
                    width: size.width,
                    onChanged: _registerParams.setMissionStatement,
                    validator: _validator.byField(_registerParams, 'missionStatement'),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const Gap(25),
                  TextInputDs(
                    label: 'website (opcional)',
                    width: size.width,
                    onChanged: _registerParams.setWebsite,
                    validator: _validator.byField(_registerParams, 'website'),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const Gap(25),
                  Text(
                    'Redes Sociais (opcional)',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Gap(15),
                  TextInputDs(
                    label: 'Facebook',
                    width: size.width,
                    onChanged: _registerParams.setFacebook,
                    validator: _validator.byField(_registerParams, 'facebook'),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const Gap(15),
                  TextInputDs(
                    label: 'Instagram',
                    width: size.width,
                    onChanged: _registerParams.setInstagram,
                    validator: _validator.byField(_registerParams, 'instagram'),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const Gap(15),
                  TextInputDs(
                    label: 'Twitter',
                    width: size.width,
                    onChanged: _registerParams.setTwitter,
                    validator: _validator.byField(_registerParams, 'twitter'),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                ],

                const Gap(25),
                Text(
                  'Endereço (opcional)',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Gap(15),
                TextInputDs(
                  label: 'CEP',
                  controller: cepController,
                  textInputType: TextInputType.number,
                  width: size.width,
                  onChanged: _registerParams.setZipCode,
                  validator: _validator.byField(_registerParams, 'zipCode'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const Gap(15),
                TextInputDs(
                  label: 'Rua',
                  width: size.width,
                  onChanged: _registerParams.setStreet,
                  validator: _validator.byField(_registerParams, 'street'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const Gap(15),
                TextInputDs(
                  label: 'Bairro',
                  width: size.width,
                  onChanged: _registerParams.setNeighborhood,
                  validator: _validator.byField(_registerParams, 'neighborhood'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const Gap(15),
                Row(
                  children: [
                    TextInputDs(
                      label: 'Número',
                      textInputType: TextInputType.number,
                      width: size.width * 0.3,
                      onChanged: _registerParams.setNumberHouse,
                      validator: _validator.byField(_registerParams, 'numberHouse'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    const Gap(10),
                    Flexible(
                      child: TextInputDs(
                        label: 'Complemento',
                        width: size.width * 0.59,
                        onChanged: _registerParams.setComplement,
                        validator: _validator.byField(_registerParams, 'complement'),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                    ),
                  ],
                ),
                const Gap(15),
                Row(
                  children: [
                    Expanded(
                      child: TextInputDs(
                        label: 'Cidade',
                        width: size.width * 0.6,
                        onChanged: _registerParams.setCity,
                        validator: _validator.byField(_registerParams, 'city'),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                    ),
                    const Gap(10),
                    SizedBox(
                      width: size.width * 0.25,
                      child: TextInputDs(
                        label: 'Estado',
                        width: size.width * 0.25,
                        onChanged: _registerParams.setState,
                        validator: _validator.byField(_registerParams, 'state'),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                    ),
                  ],
                ),
                const Gap(40),
                Align(
                  alignment: Alignment.center,
                  child: ListenableBuilder(
                    listenable: authViewmodel.signUpCommand,
                    builder: (context, _) {
                      return PrimaryButtonDs(
                        title: 'Cadastrar',
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            authViewmodel.signUpCommand.execute(_registerParams);
                          }
                        },
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
