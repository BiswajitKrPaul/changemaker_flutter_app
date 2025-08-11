import 'package:auto_route/auto_route.dart';
import 'package:changemaker_flutter_app/app_router.dart';
import 'package:changemaker_flutter_app/common/widgets/background_gradient_widget.dart';
import 'package:changemaker_flutter_app/features/auth/providers/register_provider.dart';
import 'package:changemaker_flutter_app/i18n/strings.g.dart';
import 'package:changemaker_flutter_app/utils/color_utils.dart';
import 'package:changemaker_flutter_app/utils/extension_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_validator/form_validator.dart';
import 'package:gap/gap.dart';

@RoutePage()
class RegisterPage extends ConsumerWidget {
  RegisterPage({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  InputDecoration _getDecoration(String label, {Widget? suffix}) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      hintText: label,
      suffixIcon: suffix,
    );
  }

  Widget _getErrorString(String? validation) {
    return Visibility(
      visible: validation != null || (validation?.isNotEmpty ?? false),
      child: Align(
        alignment: Alignment.topRight,
        child: Container(
          margin: const EdgeInsets.all(1),
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 1,
          ),
          decoration: const BoxDecoration(
            color: Color(0xffF55053),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(8),
              bottomLeft: Radius.circular(8),
            ),
          ),
          child: Text(
            validation ?? '',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registerNotifier = ref.read(registerProvider.notifier);
    final registerState = ref.watch(registerProvider);

    return Scaffold(
      body: SingleChildScrollView(
        child: BackgroundGradientWidget(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 32,
                children: [
                  const Gap(50),
                  InkWell(
                    onTap: () => ref.read(routeProvider).pop(),
                    child: const Align(
                      alignment: Alignment.topLeft,
                      child: Icon(FontAwesomeIcons.angleLeft),
                    ),
                  ),

                  Text(
                    t.register.registration,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    t.register.provideInfo,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black38,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Stack(
                    children: [
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: _getDecoration(t.register.email),
                        onChanged: registerNotifier.updateEmail,
                        validator: ValidationBuilder(
                          localeName: LocaleSettings.currentLocale.languageCode,
                        ).email().build(),
                        errorBuilder: (context, errorText) => const SizedBox(),
                      ),
                      _getErrorString(
                        registerNotifier.isEmailHasError(),
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: _getDecoration(t.register.name),
                        onChanged: registerNotifier.updateName,
                        validator: ValidationBuilder(
                          localeName: LocaleSettings.currentLocale.languageCode,
                        ).minLength(5).build(),
                        errorBuilder: (context, errorText) => const SizedBox(),
                      ),
                      _getErrorString(
                        registerNotifier.isNameHasError(),
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      DropdownButtonFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: _getDecoration(t.register.gender),
                        value: registerState.gender?.name,
                        validator: ValidationBuilder(
                          localeName: LocaleSettings.currentLocale.languageCode,
                        ).required().build(),
                        items: [
                          DropdownMenuItem(
                            value: Gender.male.name,
                            child: Text(t.register.genderTypes.male),
                          ),
                          DropdownMenuItem(
                            value: Gender.female.name,
                            child: Text(t.register.genderTypes.female),
                          ),
                          DropdownMenuItem(
                            value: Gender.other.name,
                            child: Text(t.register.genderTypes.other),
                          ),
                        ],
                        onChanged: (String? value) {
                          if (value != null) {
                            registerNotifier.updateGender(value);
                          }
                        },
                      ),
                      _getErrorString(
                        registerNotifier.isGenderHasError(),
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: _getDecoration(
                          t.register.password,
                          // suffix: IconButton(
                          //   icon: !registerState.isPasswordVisible
                          //       ? const Icon(Icons.visibility_off)
                          //       : const Icon(Icons.remove_red_eye),
                          //   onPressed:
                          //       registerNotifier.togglePasswordVisibility,
                          // ),
                        ),
                        obscureText: !registerState.isPasswordVisible,
                        validator: ValidationBuilder(
                          localeName: LocaleSettings.currentLocale.languageCode,
                        ).minLength(8).build(),
                        onChanged: registerNotifier.updatePassword,
                        errorBuilder: (context, errorText) => const SizedBox(),
                      ),
                      _getErrorString(registerNotifier.isPasswordHasError()),
                    ],
                  ),
                  Stack(
                    children: [
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: _getDecoration(
                          t.register.confirmPassword,
                          // suffix: IconButton(
                          //   icon: !registerState.isConfirmPasswordVisible
                          //       ? const Icon(Icons.visibility_off)
                          //       : const Icon(Icons.remove_red_eye),
                          //   onPressed: registerNotifier
                          //       .toggleConfirmPasswordVisibility,
                          // ),
                        ),
                        obscureText: !registerState.isConfirmPasswordVisible,
                        validator:
                            ValidationBuilder(
                                  localeName:
                                      LocaleSettings.currentLocale.languageCode,
                                )
                                .minLength(8)
                                .confirmPassword(registerState.password)
                                .build(),
                        onChanged: registerNotifier.updateConfirmPassword,
                        errorBuilder: (context, errorText) => const SizedBox(),
                      ),
                      _getErrorString(
                        registerNotifier.isConfirmPasswordHasError(),
                      ),
                    ],
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: FilledButton(
                      onPressed:
                          registerNotifier.isButtonEnanbled() ||
                              registerState.isLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                registerNotifier.register();
                              }
                            },
                      style: FilledButton.styleFrom(
                        fixedSize: const Size(140, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        foregroundColor: Colors.white,
                        backgroundColor: ref
                            .read(colorProvider)
                            .filledButtonColor,
                      ),
                      child: registerState.isLoading
                          ? const CircularProgressIndicator()
                          : Text(
                              t.register.register,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
