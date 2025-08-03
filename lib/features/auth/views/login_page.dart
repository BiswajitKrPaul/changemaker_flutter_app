import 'package:auth_buttons/auth_buttons.dart';
import 'package:auto_route/auto_route.dart';
import 'package:changemaker_flutter_app/features/auth/providers/login_provider.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 16,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
                validator: ValidationBuilder().email().build(),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                onChanged: ref
                    .read(loginStateNotifierProvider.notifier)
                    .updateEmail,
              ),
              TextFormField(
                obscureText: !loginWatchProvider.isPasswordVisible,
                validator: ValidationBuilder().minLength(6).build(),
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Password',
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
                        _formKey.currentState?.validate() != true
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
                    : const Text(
                        'Login',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
              ),
              TextButton(
                onPressed: () {},
                child: RichText(
                  text: TextSpan(
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.black),
                    children: const [
                      TextSpan(text: "Don't have an account? "),
                      TextSpan(
                        text: 'Register',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 0.2,
                    ),
                  ),
                  Text(
                    '   Or   ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Expanded(
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
                child: const Text('Forgot Password?'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
