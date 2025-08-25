import 'package:auto_route/auto_route.dart';
import 'package:changemaker_flutter_app/app_router.dart';
import 'package:changemaker_flutter_app/common/widgets/background_gradient_widget.dart';
import 'package:changemaker_flutter_app/features/auth/providers/login_provider.dart';
import 'package:changemaker_flutter_app/i18n/strings.g.dart';
import 'package:changemaker_flutter_app/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_validator/form_validator.dart';
import 'package:gap/gap.dart';

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
      body: SingleChildScrollView(
        child: BackgroundGradientWidget(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 16,
                children: [
                  const Gap(50),
                  InkWell(
                    onTap: () => ref.read(routeProvider).pop(),
                    child: const Align(
                      alignment: Alignment.topLeft,
                      child: Icon(FontAwesomeIcons.angleLeft),
                    ),
                  ),
                  const Gap(16),
                  Text(
                    t.login.welcomeBack,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    t.login.loginBackMessage,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black38,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  const Gap(16),
                  Stack(
                    children: [
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          hintText: t.login.email,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: ValidationBuilder().email().build(),
                        onChanged: ref
                            .read(loginStateNotifierProvider.notifier)
                            .updateEmail,
                        errorBuilder: (context, errorText) => const SizedBox(),
                      ),
                      Visibility(
                        visible:
                            ref
                                    .watch(loginStateNotifierProvider.notifier)
                                    .isEmailHasError() !=
                                null ||
                            (ref
                                    .watch(loginStateNotifierProvider.notifier)
                                    .isEmailHasError()
                                    ?.isNotEmpty ??
                                false),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            margin: const EdgeInsets.all(1),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              color: ref.read(colorProvider).gradientStartColor,
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                              ),
                            ),
                            child: Text(
                              ref
                                      .watch(
                                        loginStateNotifierProvider.notifier,
                                      )
                                      .isEmailHasError() ??
                                  '',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        obscureText: !loginWatchProvider.isPasswordVisible,
                        validator: ValidationBuilder(
                          localeName: LocaleSettings.currentLocale.languageCode,
                        ).minLength(6).build(),
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          hintText: t.login.password,

                          // suffixIcon: IconButton(
                          //   icon: !loginWatchProvider.isPasswordVisible
                          //       ? const Icon(Icons.visibility_off)
                          //       : const Icon(Icons.remove_red_eye),
                          //   onPressed: () {
                          //     ref
                          //         .read(loginStateNotifierProvider.notifier)
                          //         .togglePasswordVisibility();
                          //   },
                          // ),
                        ),
                        keyboardType: TextInputType.text,
                        errorBuilder: (context, errorText) => const SizedBox(),
                        onChanged: ref
                            .read(loginStateNotifierProvider.notifier)
                            .updatePassword,
                      ),
                      Visibility(
                        visible:
                            ref
                                    .watch(loginStateNotifierProvider.notifier)
                                    .isPasswordHasError() !=
                                null ||
                            (ref
                                    .watch(loginStateNotifierProvider.notifier)
                                    .isPasswordHasError()
                                    ?.isNotEmpty ??
                                false),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            margin: const EdgeInsets.all(1),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              color: ref.read(colorProvider).gradientStartColor,
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                              ),
                            ),
                            child: Text(
                              ref
                                      .watch(
                                        loginStateNotifierProvider.notifier,
                                      )
                                      .isPasswordHasError() ??
                                  '',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                      ),
                      child: Text(t.login.forgotPassword),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: FilledButton(
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        foregroundColor: Colors.white,
                        backgroundColor: ref
                            .read(colorProvider)
                            .filledButtonColor,
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
