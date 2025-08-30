import 'package:auto_route/auto_route.dart';
import 'package:changemaker_flutter_app/app_router.dart';
import 'package:changemaker_flutter_app/common/widgets/background_gradient_widget.dart';
import 'package:changemaker_flutter_app/features/auth/providers/reset_password_providers.dart';
import 'package:changemaker_flutter_app/i18n/strings.g.dart';
import 'package:changemaker_flutter_app/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_validator/form_validator.dart';
import 'package:gap/gap.dart';

final _formKey = GlobalKey<FormState>();

@RoutePage()
class PasswordResetPage extends ConsumerWidget {
  const PasswordResetPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(resetPasswordProvider);
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
                  const Gap(kToolbarHeight),
                  InkWell(
                    onTap: () => ref.read(routeProvider).pop(),
                    child: const Align(
                      alignment: Alignment.topLeft,
                      child: Icon(FontAwesomeIcons.angleLeft),
                    ),
                  ),
                  const Gap(16),
                  Text(
                    t.resetpassword.resetPassword,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    t.resetpassword.provideInfo,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black38,
                    ),
                    textAlign: TextAlign.center,
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
                            .read(resetPasswordProvider.notifier)
                            .updateEmail,
                        errorBuilder: (context, errorText) => const SizedBox(),
                      ),
                      Visibility(
                        visible:
                            ref
                                    .watch(resetPasswordProvider.notifier)
                                    .isEmailHasError() !=
                                null ||
                            (ref
                                    .watch(resetPasswordProvider.notifier)
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
                                        resetPasswordProvider.notifier,
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
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: FilledButton(
                      onPressed:
                          state.isLoading ||
                              ref
                                  .read(resetPasswordProvider.notifier)
                                  .isButtonEnanbled()
                          ? null
                          : () {
                              if (_formKey.currentState?.validate() ?? false) {
                                ref
                                    .read(resetPasswordProvider.notifier)
                                    .resetPassword();
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
                      child: state.isLoading
                          ? const CircularProgressIndicator()
                          : Text(
                              t.resetpassword.resetPassword,
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
