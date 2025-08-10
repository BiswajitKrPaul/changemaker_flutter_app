import 'package:auth_buttons/auth_buttons.dart';
import 'package:auto_route/auto_route.dart';
import 'package:changemaker_flutter_app/app_router.dart';
import 'package:changemaker_flutter_app/app_router.gr.dart';
import 'package:changemaker_flutter_app/features/auth/providers/login_provider.dart';
import 'package:changemaker_flutter_app/i18n/strings.g.dart';
import 'package:changemaker_flutter_app/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validator/form_validator.dart';

@RoutePage()
class LoginPage extends ConsumerWidget {
  LoginPage({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginWatchProvider = ref.watch(loginStateNotifierProvider);
    ref.listen(
      loginStateNotifierProvider,
      (previous, next) {
        if (next.isSocialLoginLoading) {
          showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 16,
              children: [
                Image.asset(
                  'assets/logo/changemaker_logo.png',
                  height: 250,
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: t.login.email,
                  ),
                  validator: ValidationBuilder(
                    localeName: LocaleSettings.currentLocale.languageCode,
                  ).email().build(),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  onChanged: ref
                      .read(loginStateNotifierProvider.notifier)
                      .updateEmail,
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  obscureText: !loginWatchProvider.isPasswordVisible,
                  validator: ValidationBuilder(
                    localeName: LocaleSettings.currentLocale.languageCode,
                  ).minLength(6).build(),
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: t.login.password,
                    suffixIcon: IconButton(
                      icon: !loginWatchProvider.isPasswordVisible
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.remove_red_eye),
                      onPressed: () {
                        ref
                            .read(loginStateNotifierProvider.notifier)
                            .togglePasswordVisibility();
                      },
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  onChanged: ref
                      .read(loginStateNotifierProvider.notifier)
                      .updatePassword,
                ),
                FilledButton(
                  onPressed:
                      loginWatchProvider.isLoading ||
                          loginWatchProvider.isSocialLoginLoading ||
                          ref
                              .read(loginStateNotifierProvider.notifier)
                              .isButtonEnanbled()
                      ? null
                      : () {
                          if (_formKey.currentState?.validate() ?? false) {
                            ref
                                .read(loginStateNotifierProvider.notifier)
                                .signIn();
                          }
                        },
                  style: FilledButton.styleFrom(
                    fixedSize: const Size(140, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: loginWatchProvider.isLoading
                      ? const CircularProgressIndicator()
                      : Text(
                          t.login.login,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                ),
                TextButton(
                  onPressed: () {
                    ref.read(routeProvider).push(RegisterPageRoute());
                  },
                  child: RichText(
                    text: TextSpan(
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.black),
                      children: [
                        TextSpan(text: '${t.login.dontHaveAccount} '),
                        TextSpan(
                          text: t.login.register,
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Expanded(
                      child: Divider(
                        thickness: 0.2,
                      ),
                    ),
                    Text(
                      '   ${t.login.or}   ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Expanded(
                      child: Divider(
                        thickness: 0.2,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 32,
                  children: [
                    GoogleAuthButton(
                      themeMode: ThemeMode.light,
                      onPressed: () {
                        ref
                            .read(loginStateNotifierProvider.notifier)
                            .signInUsingGoogle();
                      },
                      style: const AuthButtonStyle(
                        buttonType: AuthButtonType.icon,
                      ),
                    ),
                    FacebookAuthButton(
                      themeMode: ThemeMode.light,
                      onPressed: () {
                        AppUtils.showSnackBar('Comming soon');
                      },
                      materialStyle: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      style: const AuthButtonStyle(
                        buttonType: AuthButtonType.icon,
                      ),
                    ),
                    AppleAuthButton(
                      themeMode: ThemeMode.light,
                      onPressed: () {
                        AppUtils.showSnackBar('Comming soon');
                      },
                      style: const AuthButtonStyle(
                        buttonType: AuthButtonType.icon,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(t.login.forgotPassword),
                ),
                DropdownButton(
                  value: LocaleSettings.currentLocale.languageCode,
                  items: const [
                    DropdownMenuItem(
                      value: 'en',
                      child: Text('English'),
                    ),
                    DropdownMenuItem(
                      value: 'de',
                      child: Text('Deutsch'),
                    ),
                  ],
                  onChanged: (value) {
                    LocaleSettings.setLocaleRaw(value!);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
