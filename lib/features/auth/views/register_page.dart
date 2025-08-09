import 'package:auto_route/auto_route.dart';
import 'package:changemaker_flutter_app/features/auth/providers/register_provider.dart';
import 'package:changemaker_flutter_app/i18n/strings.g.dart';
import 'package:changemaker_flutter_app/utils/extension_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validator/form_validator.dart';

@RoutePage()
class RegisterPage extends ConsumerWidget {
  RegisterPage({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  InputDecoration _getDecoration(String label, {Widget? suffix}) {
    return InputDecoration(
      border: const OutlineInputBorder(),
      labelText: label,
      suffixIcon: suffix,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registerNotifier = ref.read(registerProvider.notifier);
    final registerState = ref.watch(registerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.register.register),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 16,
              children: [
                Image.asset(
                  'assets/logo/changemaker_logo.png',
                  height: 250,
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: _getDecoration(t.register.email),
                  onChanged: registerNotifier.updateEmail,
                  validator: ValidationBuilder(
                    localeName: LocaleSettings.currentLocale.languageCode,
                  ).email().build(),
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: _getDecoration(t.register.name),
                  onChanged: registerNotifier.updateName,
                  validator: ValidationBuilder(
                    localeName: LocaleSettings.currentLocale.languageCode,
                  ).minLength(5).build(),
                ),
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
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: _getDecoration(
                    t.register.password,
                    suffix: IconButton(
                      icon: !registerState.isPasswordVisible
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.remove_red_eye),
                      onPressed: registerNotifier.togglePasswordVisibility,
                    ),
                  ),
                  obscureText: !registerState.isPasswordVisible,
                  validator: ValidationBuilder(
                    localeName: LocaleSettings.currentLocale.languageCode,
                  ).minLength(8).build(),
                  onChanged: registerNotifier.updatePassword,
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: _getDecoration(
                    t.register.confirmPassword,
                    suffix: IconButton(
                      icon: !registerState.isConfirmPasswordVisible
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.remove_red_eye),
                      onPressed:
                          registerNotifier.toggleConfirmPasswordVisibility,
                    ),
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
                ),
                FilledButton(
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
                      borderRadius: BorderRadius.circular(12),
                    ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
